//
//  SNSlideController.m
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"
#import "SNSlideController+SNSlideAttribute.h"
#import "UIViewController+SNSlideStatus.h"
#import "SNSlideController+SNSlideStatus.h"
#import "SNSlideController+SNGeometry.h"
#import "SNSlideController+SNControllerHierarchy.h"
#import "SNSlideController+SNObserver.h"
#import "UIViewController+SNAppearance.h"
#import "NSMutableArray+SNSlideStack.h"
#import "SNSlideNavigationController.h"
#import "SNViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface SNSlideController ()

@property (nonatomic, readwrite, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, readwrite, retain) UIPanGestureRecognizer *panGestureRecognizer;

- (BOOL)shouldReceivePoint:(CGPoint)point withGesture:(UIGestureRecognizer *)gesture;
- (BOOL)shouldReceivePoint:(CGPoint)point;
- (CGPoint)adjustedTranslation:(CGPoint)translation;
- (void)tap:(UITapGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;

@end

@implementation SNSlideController

@synthesize topController = _topController,
            currentController = _currentController,
            leftController = _leftController,
            rightController = _rightController,
            selectedController = _selectedController;

@synthesize panGestureRecognizer = _panGestureRecognizer,
            tapGestureRecognizer = _tapGestureRecognizer;

@synthesize tapValid = _tapValid,
            panValid = _panValid,
            layouting = _layouting;

@synthesize lastControllerStatus = _lastControllerStatus,
            topControllerStatus = _topControllerStatus;

@synthesize attributesDict = _attributesDict,
            observerDict = _observerDict,
            controllerStack = _controllerStack;

#pragma mark - Synthesize

- (void)setTopControllerStatus:(SNSlideStatus)topControllerStatus
{
    if (_topControllerStatus == topControllerStatus) {
        return;
    }
    
    _topControllerStatus = topControllerStatus;
    
    switch (topControllerStatus) {
        case SNSlideStatusCenter:
            break;
            
        case SNSlideStatusLeft:
        case SNSlideStatusLeftOutOfScreen:
        {
            [self bringController:self.rightController toFrontOfController:self.leftController];
        }
            break;
            
        case SNSlideStatusRight:
        case SNSlideStatusRightOutOfScreen:
        {
            [self bringController:self.leftController toFrontOfController:self.rightController];
        }
            break;
            
        default:
            break;
    }
}

- (void)setTopController:(SNViewController *)topController
{
    [_topController release];
    _topController = [topController retain];
    
    [self setSlideControllerForController:_topController];
}

- (void)setLeftController:(SNViewController *)leftController
{
    [_leftController release];
    _leftController = [leftController retain];
    
    [self setSlideControllerForController:leftController];
}

- (void)setRightController:(SNViewController *)rightController
{
    [_rightController release];
    _rightController = [rightController retain];
    
    [self setSlideControllerForController:rightController];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self removeAllObservers];
    
    self.observerDict = nil;
    self.attributesDict = nil;
    self.controllerStack = nil;
    
    self.topController = nil;
    self.currentController = nil;
    self.leftController = nil;
    self.rightController = nil;
    self.selectedController = nil;
    
    self.tapGestureRecognizer = nil;
    self.panGestureRecognizer = nil;
    
    [super dealloc];
}

#pragma mark - Init

- (id)init
{
    self = [super init];
    if (self) {
        self.hasNavigationBar = NO;
        self.hasRightViewController = NO;
        
        NSMutableDictionary *attrDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        self.attributesDict = attrDict;
        [attrDict release];
        
        NSMutableDictionary *obseDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        self.observerDict = obseDict;
        [obseDict release];
        
        NSMutableArray *controllerStack = [[NSMutableArray alloc] initWithCapacity:5];
        self.controllerStack = controllerStack;
        [controllerStack release];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.delaysTouchesEnded = NO;
        panGestureRecognizer.delegate = self;
        self.panGestureRecognizer = panGestureRecognizer;
        [panGestureRecognizer release];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        tapGestureRecognizer.delaysTouchesEnded = NO;
        tapGestureRecognizer.delegate = self;
        self.tapGestureRecognizer = tapGestureRecognizer;
        [tapGestureRecognizer release];
        
        [self.tapGestureRecognizer requireGestureRecognizerToFail:self.panGestureRecognizer];
        
        self.tapValid = NO;
        self.panValid = NO;
        self.layouting = NO;
        self.topControllerStatus = SNSlideStatusCenter;
        self.lastControllerStatus = SNSlideStatusCenter;
    }
    
    return self;
}

- (id)initWithTopController:(SNViewController *)topController
{
    self = [self init];
    if (self) {
        self.topController = topController;
        self.currentController = self.topController;
        
        self.leftController = nil;
        self.rightController = nil;
    }
    
    return self;
}

- (id)initWithTopController:(SNViewController *)topController leftController:(SNViewController *)leftController
{
    self = [self initWithTopController:topController];
    if (self) {
        self.leftController = leftController;
    }
    
    return self;
}

- (id)initWithTopController:(SNViewController *)topController rightController:(SNViewController *)rightController
{
    self = [self initWithTopController:topController];
    if (self) {
        self.rightController = rightController;
    }
    
    return self;
}

- (id)initWithTopController:(SNViewController *)topController
             leftController:(SNViewController *)leftController
            rightController:(SNViewController *)rightController
{
    self = [self initWithTopController:topController];
    if (self) {
        self.leftController = leftController;
        self.rightController = rightController;
    }
    
    return self;
}

- (void)setSlideControllerForController:(SNViewController *)controller
{
    controller.slideController = self;
}

- (void)setSlideNavigationController:(SNSlideNavigationController *)naviController forController:(SNViewController *)controller
{
    controller.slideNavigationController = naviController;
}

- (void)setSlideNavigationController:(SNSlideNavigationController *)slideNavigationController
{
    _slideNavigationController = slideNavigationController;
    
    [self setSlideNavigationController:_slideNavigationController forController:self.topController];
    
    [self setSlideNavigationController:_slideNavigationController forController:self.leftController];
    
    [self setSlideNavigationController:_slideNavigationController forController:self.rightController];
}

#pragma mark - Slide

- (void)slideToLeftAnimated:(BOOL)animated
{
    [self setStatus:SNSlideStatusLeft forController:self.currentController animated:animated usingBounce:NO onCompletion:NULL];
}

- (void)slideToLeft:(SNSlideControllerBlock)belowControllerBlock
          attribute:(SNSlideAttributeBlock)attributeBlock
           animated:(BOOL)animated
{
    SNViewController *belowController = [self controllerBelow:self.currentController withStatus:SNSlideStatusLeft];
    if (belowController) {
        if (belowControllerBlock) {
            belowControllerBlock(belowController);
        }
        if (attributeBlock) {
            SNSlideAttribute attr = [self defaultAttributeForRightController];
            attr = attributeBlock(attr);
            [self setAttribute:attr forController:belowController];
        }
        
        [self setStatus:SNSlideStatusLeft forController:self.currentController animated:animated usingBounce:NO onCompletion:NULL];
    }
}

- (void)slideToRightAnimated:(BOOL)animated
{
    [self setStatus:SNSlideStatusRight forController:self.currentController animated:animated usingBounce:NO onCompletion:NULL];
}

- (void)slideToRight:(SNSlideControllerBlock)belowControllerBlock
           attribute:(SNSlideAttributeBlock)attributeBlock
            animated:(BOOL)animated
{
    SNViewController *belowController = [self controllerBelow:self.currentController withStatus:SNSlideStatusRight];
    if (belowController) {
        if (belowControllerBlock) {
            belowControllerBlock(belowController);
        }
        if (attributeBlock) {
            SNSlideAttribute attr = [self defaultAttributeForLeftController];
            attr = attributeBlock(attr);
            [self setAttribute:attr forController:belowController];
        }
        
        [self setStatus:SNSlideStatusRight forController:self.currentController animated:animated usingBounce:NO onCompletion:NULL];
    }
}

- (void)slidePreviousBackAnimated:(BOOL)animated
{
    SNViewController *previousController = (SNViewController *)[self.controllerStack previousControllerInStack];
    if (previousController) {
        SNSlideStatus status = [self statusForController:previousController];
        switch (status) {
            case SNSlideStatusCenter:
                break;
                
            case SNSlideStatusLeft:
            case SNSlideStatusLeftOutOfScreen:
            case SNSlideStatusRight:
            case SNSlideStatusRightOutOfScreen:
                [self setStatus:SNSlideStatusCenter forController:previousController animated:YES usingBounce:NO onCompletion:NULL];
                break;
                
            default:
                break;
        }
    }
}

- (void)slidePreviousBack:(SNSlideControllerBlock)prevControllerBlock
                attribute:(SNSlideAttributeBlock)attributeBlock
                 animated:(BOOL)animated
{
    SNViewController *previousController = (SNViewController *)[self.controllerStack previousControllerInStack];
    
    if (previousController) {
        if (prevControllerBlock) {
            prevControllerBlock(previousController);
        }
        if (attributeBlock) {
            SNSlideAttribute attr = [self defaultAttribute];
            attr = attributeBlock(attr);
            [self setAttribute:attr forController:previousController];
        }
        
        SNSlideStatus status = [self statusForController:previousController];
        switch (status) {
            case SNSlideStatusCenter:
                break;
                
            case SNSlideStatusLeft:
            case SNSlideStatusLeftOutOfScreen:
            case SNSlideStatusRight:
            case SNSlideStatusRightOutOfScreen:
                [self setStatus:SNSlideStatusCenter forController:previousController animated:YES usingBounce:NO onCompletion:NULL];
                break;
                
            default:
                break;
        }
    }
}

- (void)slideToTopAnimated:(BOOL)animated
{
    [self setStatus:SNSlideStatusCenter forController:self.topController animated:animated usingBounce:NO onCompletion:NULL];
}

- (void)slideToTop:(SNSlideControllerBlock)topControllerBlock
         attribute:(SNSlideAttributeBlock)attributeBlock
          animated:(BOOL)animated
{
    if (topControllerBlock) {
        topControllerBlock(self.topController);
    }
    if (attributeBlock) {
        SNSlideAttribute attr = [self defaultAttributeForTopController];
        attr = attributeBlock(attr);
        if (self.rightController) {
            attr.slideToLeftEnable = YES;
        }
        if (self.leftController) {
            attr.slideToRightEnable = YES;
        }
        [self setAttribute:attr forController:self.topController];
    }
    [self setStatus:SNSlideStatusCenter forController:self.topController animated:animated usingBounce:NO onCompletion:NULL];
}

- (void)changeTopWith:(SNSlideTopControllerBlock)controllerBlock
            attribute:(SNSlideAttributeBlock)attributeBlock
             animated:(BOOL)animated
{
    SNViewController *controller = nil;
    if (controllerBlock) {
        controller = controllerBlock();
    }
    
    if (controller) {
        if (attributeBlock) {
            SNSlideAttribute attr = [self defaultAttributeForTopController];
            attr = attributeBlock(attr);
            if (self.rightController) {
                attr.slideToLeftEnable = YES;
            }
            if (self.leftController) {
                attr.slideToRightEnable = YES;
            }
            [self setAttribute:attr forController:controller];
        }
        
        [self resetOldTopController:self.topController withNewTopController:controller];
        [self setStatus:SNSlideStatusCenter forController:self.topController animated:animated usingBounce:NO onCompletion:NULL];
    }
}

- (void)setCurrentWantsFullScreenLayout:(BOOL)fullScreenLayout
{
    if (self.topControllerStatus == SNSlideStatusCenter) {
        return;
    }
    
    SNSlideStatus status = SNSlideStatusCenter;
    if ([self isStatus:self.topControllerStatus onSameSideWithStatus:SNSlideStatusLeft]) {
        status = (fullScreenLayout) ? SNSlideStatusLeftOutOfScreen : SNSlideStatusLeft;
    }
    else if ([self isStatus:self.topControllerStatus onSameSideWithStatus:SNSlideStatusRight]) {
        status = (fullScreenLayout) ? SNSlideStatusRightOutOfScreen : SNSlideStatusRight;
    }
    
    for (SNViewController *controller in self.controllerStack) {
        [self setStatus:status forController:controller animated:YES usingBounce:NO onCompletion:NULL];
    }
}

#pragma mark - View Lifecircle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    
    [self initAttributes];
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self layoutControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leftController viewWillAppear:animated];
    [self.topController viewWillAppear:animated];
    [self.rightController viewWillAppear:animated];
    //[self.currentController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.leftController viewWillDisappear:animated];
    [self.topController viewWillDisappear:animated];
    [self.rightController viewWillDisappear:animated];
    //[self.currentController viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.leftController viewDidAppear:animated];
    [self.topController viewDidAppear:animated];
    [self.rightController viewDidAppear:animated];
    //[self.currentController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.leftController viewDidDisappear:animated];
    [self.topController viewDidDisappear:animated];
    [self.rightController viewDidDisappear:animated];
    //[self.currentController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Pan

- (CGPoint)adjustedTranslation:(CGPoint)translation
{
    SNSlideAttribute attr = [self attributeForController:self.selectedController];
    
    CGPoint adjustedTranslation = translation;
    CGRect frame = CGRectOffset(self.selectedController.view.frame, translation.x, 0);
    if (translation.x > 0
        && CGRectGetMaxX(frame) > CGRectGetMaxX(self.view.bounds)
        && attr.slideToRightEnable == NO) {
        if (attr.alwaysBounceRight == NO) {
            adjustedTranslation.x = CGRectGetMaxX(self.view.bounds) - CGRectGetMaxX(self.selectedController.view.frame);
        }
        else {
            adjustedTranslation.x = translation.x*kAlwaysBounceCenterCoefficient;
        }
    }
    else if (translation.x < 0
             && CGRectGetMinX(frame) < CGRectGetMinX(self.view.bounds)
             && attr.slideToLeftEnable == NO) {
        if (attr.alwaysBounceLeft == NO) {
            adjustedTranslation.x = CGRectGetMinX(self.view.bounds) - CGRectGetMinX(self.selectedController.view.frame);
        }
        else {
            adjustedTranslation.x = translation.x*kAlwaysBounceCenterCoefficient;
        }
    }
    else if (translation.x > 0
             && CGRectGetMinX(frame) > CGRectGetRightMaxX(self.view.bounds)) {
        if (attr.alwaysBounceRight == NO) {
            adjustedTranslation.x = CGRectGetRightMaxX(self.view.bounds) - CGRectGetMinX(self.selectedController.view.frame);
        }
        else {
            adjustedTranslation.x = translation.x*kAlwaysBounceSideCoefficient;
        }
    }
    else if (translation.x < 0
             && CGRectGetMaxX(frame) < CGRectGetLeftMinX(self.view.bounds)) {
        if (attr.alwaysBounceLeft == NO) {
            adjustedTranslation.x = CGRectGetLeftMinX(self.view.bounds) - CGRectGetMaxX(self.selectedController.view.frame);
        }
        else {
            adjustedTranslation.x = translation.x*kAlwaysBounceSideCoefficient;
        }
    }
    
    return adjustedTranslation;
}

#define MAX_RESISTANCE_COEFFICIENT 10 //减速等级,移动速度递减
- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        SNViewController *controller = [self hitTest:[gesture locationInView:self.view]];
        if (controller == nil || controller.isPanValid == NO || ![controller isEqual:self.topController]) {
            self.lastControllerStatus = SNSlideStatusCenter;
            self.selectedController = nil;
            self.panValid = NO;
        }
        else {
            [controller.view.layer removeAllAnimations];
            [self addObserverForController:controller];
            self.lastControllerStatus = [self statusForController:controller];
            self.selectedController = controller;
            self.panValid = YES;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        if (!self.isPanValid) {
            return;
        }
        
        CGPoint translation = [self adjustedTranslation:[gesture translationInView:self.view]];
        
        [self layoutControllersWithSelectedController:self.selectedController translation:translation];
        
        //减速滑动
        CGFloat reduceCoefficient = 1.0;
        if(translation.x >0.0)//右侧移动
        {
            //超出正常显示宽度，开始滑动减速
            if(CGRectOffset(self.selectedController.view.frame, translation.x, 0).origin.x > CGRectGetRightMaxX(self.view.bounds))
            {
                CGFloat beyondWidth = CGRectOffset(self.selectedController.view.frame, translation.x, 0).origin.x - CGRectGetRightMaxX(self.view.bounds);
                reduceCoefficient = (CGFloat)ceil(beyondWidth/(CGRectGetRightMaxX(self.view.bounds)/2/MAX_RESISTANCE_COEFFICIENT));
            }
        }
        else
        {
            if(CGRectOffset(self.selectedController.view.frame, translation.x, 0).origin.x < CGRectGetLeftMinX(self.view.bounds) - CGRectGetWidth(self.view.bounds))
            {
                CGFloat beyondWidth = CGRectGetLeftMinX(self.view.bounds) - (CGRectOffset(self.selectedController.view.frame, translation.x, 0).origin.x + CGRectGetWidth(self.view.bounds));
                reduceCoefficient = (CGFloat)ceil(beyondWidth/(CGRectGetLeftMinX(self.view.bounds)/2/MAX_RESISTANCE_COEFFICIENT));
            }
        }
        self.selectedController.view.frame = CGRectOffset(self.selectedController.view.frame, translation.x/reduceCoefficient, 0);
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded
             || gesture.state == UIGestureRecognizerStateCancelled)
    {
        if (!self.isPanValid) {
            return;
        }
        
        [self removeObserverForController:self.selectedController];
        
        [self layoutSelectedController:self.selectedController withPanGestureRecognizer:gesture];
        
        self.lastControllerStatus = SNSlideStatusCenter;
        self.selectedController = nil;
        self.panValid = NO;
    }
}

#pragma mark - Tap

- (void)tap:(UITapGestureRecognizer *)gesture
{
    SNViewController *controller = [self hitTest:[gesture locationInView:self.view]];
    if (controller) {
        SNSlideStatus status = [self statusForController:controller];
        if (status != SNSlideStatusCenter) {
            [self setStatus:SNSlideStatusCenter forController:controller animated:YES usingBounce:NO onCompletion:NULL];
        }
    }
}

#pragma mark - Gesture Delegate

- (BOOL)shouldReceivePoint:(CGPoint)point
{
    BOOL shouldReceive = YES;
    
    UIViewController *controller = [self hitTest:point];
    if (controller == nil
        || controller.modalViewController
        || ([controller isKindOfClass:[UINavigationController class]]
            && [(UINavigationController *)controller viewControllers].count > 1)
        || (controller.navigationController && [controller.navigationController viewControllers].count > 1)
        || ([controller isKindOfClass:[SNViewController class]]
            && [(SNViewController *)controller slideNavigationController]
            && [[(SNViewController *)controller slideNavigationController] viewControllers].count > 1)) {
        shouldReceive = NO;
    }
    
    return shouldReceive;
}

- (BOOL)shouldReceivePoint:(CGPoint)point withGesture:(UIGestureRecognizer *)gesture
{
    BOOL shouldReceive = YES;
    
    UIViewController *controller = [self hitTest:point];
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]
        && controller
        && ![controller isEqual:self.topController]) {
        shouldReceive = NO;
    }
    else {
        shouldReceive = [self shouldReceivePoint:point];
    }
    
    return shouldReceive;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer * panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y)/MAX(fabs(translation.x), 0.0001) > kTriggerThreshold && [self statusForController:self.topController] == SNSlideStatusCenter) {
            shouldBegin = NO;
        }
        else {
            shouldBegin = [self shouldReceivePoint:[panGestureRecognizer locationInView:self.view] withGesture:panGestureRecognizer];
        }
    }
    
    return shouldBegin;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UISlider class]])
        
        return NO;
    
    BOOL shouldReceive = YES;
    
    if (self.isLayouting
        || self.modalViewController
        || (self.navigationController && [self.navigationController viewControllers].count > 1)
        || (self.slideNavigationController && [self.slideNavigationController viewControllers].count > 1)) {
        shouldReceive = NO;
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if ([touch.view isKindOfClass:[UIControl class]]) {
            shouldReceive = NO;
        }
        else {
            shouldReceive = [self shouldReceivePoint:[touch locationInView:self.view]];
            if (shouldReceive) {
                SNSlideStatus status = [self statusForController:self.topController];
                switch (status) {
                    case SNSlideStatusCenter:
                    case SNSlideStatusLeftOutOfScreen:
                    case SNSlideStatusRightOutOfScreen:
                        shouldReceive = NO;
                        break;
                        
                    case SNSlideStatusLeft:
                    {
                        CGRect touchBounds = self.view.bounds;
                        touchBounds.origin.x = kLeftReservedWidth;
                        touchBounds.size.width -= kLeftReservedWidth;
                        if (CGRectContainsPoint(touchBounds, [touch locationInView:self.view])) {
                            shouldReceive = NO;
                        }
                    }
                        break;
                        
                    case SNSlideStatusRight:
                    {
                        CGRect touchBounds = self.view.bounds;
                        touchBounds.size.width -= kRightReservedWidth;
                        if (CGRectContainsPoint(touchBounds, [touch locationInView:self.view])) {
                            shouldReceive = NO;
                        }
                    }
                        
                    default:
                        break;
                }
            }
        }
    }
    
    return shouldReceive;
}

@end
