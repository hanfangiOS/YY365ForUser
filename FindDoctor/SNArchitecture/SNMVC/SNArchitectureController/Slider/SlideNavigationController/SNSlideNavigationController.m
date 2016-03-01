//
//  SNSlideNavigationController.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"
#import "NSMutableArray+SNSlideStack.h"
#import "UIViewController+SNAppearance.h"
#import "SNSlideNavigationController+SNControllerHierarchy.h"
#import "SNSlideNavigationController+SNSlideStatus.h"
#import "SNSlideNavigationController+SNObserver.h"
#import "SNSlideNavigationController+SNSlideStack.h"
#import "SNSlideController.h"
#import "SNUISystemConstant.h"

#define UsesystemBrightness

@interface SNSlideNavigationController ()


@property (nonatomic, readwrite, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readwrite, retain) SNViewController *rootViewController;

- (BOOL)shouldBeginPanGestureRecognizer;
- (CGPoint)adjustedTranslation:(CGPoint)translation;
- (void)pan:(UIPanGestureRecognizer *)gesture;

@end

@implementation SNSlideNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize observerDict = _observerDict;

@synthesize panGestureRecognizer = _panGestureRecognizer;

@synthesize panValid = _panValid,
            layouting = _layouting;

@synthesize selectedController = _selectedController,
            rootViewController = _rootViewController;

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.currentViewController && ((SNViewController *)self.currentViewController).canRotate) {
        return self.currentViewController.supportedInterfaceOrientations;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)dealloc
{
    [self removeAllObservers];
    
    self.observerDict = nil;
    self.viewControllers = nil;
    self.panGestureRecognizer = nil;
    self.rootViewController = nil;
    self.selectedController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:1];
        _observerDict = [[NSMutableDictionary alloc] initWithCapacity:1];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.delaysTouchesEnded = NO;
        panGestureRecognizer.delegate = self;
        self.panGestureRecognizer = panGestureRecognizer;
        [panGestureRecognizer release];
        
        self.panValid = NO;
        self.layouting = NO;
    }
    
    return self;
}

- (id)initWithRootViewController:(SNViewController *)rootViewController
{
    self = [self init];
    if (self) {
        self.rootViewController = rootViewController;
        [self addController:rootViewController];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [self layoutControllers];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pop/Push Action

- (void)pushViewController:(SNViewController *)viewController animated:(BOOL)animated completion:(void(^)(void))completionBlock
{
    if (![self.viewControllers canPushController:viewController]) {
        return;
    }
    
    [viewController retain];
    viewController.slideNavigationController = self;
    
    [self addShadowForController:viewController];
    CGRect frame = self.view.bounds;
    frame.origin.x = CGRectGetWidth(self.view.bounds);
    viewController.view.frame = frame;
    [self.view addSubview:viewController.view];
//    // iOS < 5.0 viewWill/DidAppear not call when addSubview
//    if (iOSVersionLessThan_5_0()) {
//        [viewController viewWillAppear:NO];
//    }
    
    UIViewController *currentViewController = [[self currentViewController] retain];
    currentViewController.view.userInteractionEnabled = NO;
    [currentViewController viewWillDisappear:NO];
    [self setStatus:SNSlideStatusCenter forController:viewController animated:animated usingBounce:NO onCompletion:^{
        
        // iOS < 5.0 viewWill/DidAppear not call when addSubview
//        if (iOSVersionLessThan_5_0()) {
//            [viewController viewDidAppear:NO];
//        }
        [self addController:viewController];
        [currentViewController viewDidDisappear:NO];
        if ([viewController respondsToSelector:@selector(slideNavigationController:didPushViewController:)]) {
            [viewController slideNavigationController:self didPushViewController:viewController];
        }
        if (completionBlock) {
            completionBlock();
        }
        [viewController release];
        [currentViewController release];
        
    }];
}

- (void)pushViewController:(SNViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count < 2) {
        return nil;
    }
    
    SNViewController *controllerToPop = [[self currentViewController] retain];
    SNViewController *currentViewController = [[self currentViewController] retain];
    SNViewController *belowViewController = [[self belowViewController] retain];
    
    if ([controllerToPop respondsToSelector:@selector(slideNavigationController:willPopViewController:)]) {
        [controllerToPop slideNavigationController:self willPopViewController:controllerToPop];
        if (controllerToPop.modalViewController) {
            [controllerToPop dismissModalViewControllerAnimated:NO];
        }
    }
    
    [self removeController:controllerToPop];
    
    currentViewController.view.userInteractionEnabled = NO;
    // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//    if (iOSVersionLessThan_5_0()) {
//        [currentViewController viewWillDisappear:NO];
//    }
    [belowViewController viewWillAppear:NO];
    [self setStatus:SNSlideStatusRightOutOfScreen forController:currentViewController animated:animated usingBounce:NO onCompletion:^{
        // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//        if (iOSVersionLessThan_5_0()) {
//            [currentViewController viewDidDisappear:NO];
//        }
        [belowViewController viewDidAppear:NO];
        [currentViewController.view removeFromSuperview];
        belowViewController.view.userInteractionEnabled = YES;
        
        if ([controllerToPop respondsToSelector:@selector(slideNavigationController:didPopViewController:)]) {
            [controllerToPop slideNavigationController:self didPopViewController:controllerToPop];
        }
        
//        [self removeController:controllerToPop];
        
        [currentViewController release];
        [belowViewController release];
    }];
    
    return [controllerToPop autorelease];
}

- (NSArray *)popToViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (self.viewControllers.count < index+2) {
        return nil;
    }
    
    NSMutableArray *popControllers = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count];
    [popControllers addObjectsFromArray:self.viewControllers];
    [popControllers removeObjectAtIndex:0];
    
    while (self.viewControllers.count >= index+2) {
        SNViewController *controllerToPop = [[self currentViewController] retain];
        SNViewController *currentViewController = [[self currentViewController] retain];
        SNViewController *belowViewController = [[self belowViewController] retain];
        
        if ([controllerToPop respondsToSelector:@selector(slideNavigationController:willPopViewController:)]) {
            [controllerToPop slideNavigationController:self willPopViewController:controllerToPop];
            if (controllerToPop.modalViewController) {
                [controllerToPop dismissModalViewControllerAnimated:NO];
            }
        }
        
        [self removeController:controllerToPop];
        
        currentViewController.view.userInteractionEnabled = NO;
        // iOS < 5.0 viewWill/DidDisappear not call when addSubview
//        if (iOSVersionLessThan_5_0()) {
//            [currentViewController viewWillDisappear:NO];
//        }
        [belowViewController viewWillAppear:NO];
        [self setStatus:SNSlideStatusRightOutOfScreen forController:currentViewController animated:animated usingBounce:NO onCompletion:^{
            // iOS < 5.0 viewWill/DidDisappear not call when addSubview
            
//            if (iOSVersionLessThan_5_0()) {
//                [currentViewController viewDidDisappear:NO];
//            }
            [belowViewController viewDidAppear:NO];
            [currentViewController.view removeFromSuperview];
            belowViewController.view.userInteractionEnabled = YES;
            
            if ([controllerToPop respondsToSelector:@selector(slideNavigationController:didPopViewController:)]) {
                [controllerToPop slideNavigationController:self didPopViewController:controllerToPop];
            }
            
            [controllerToPop release];
            [currentViewController release];
            [belowViewController release];
        }];
        
//        [self removeController:controllerToPop];
    }
    
    return [popControllers autorelease];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    int index = [self.viewControllers indexOfObject:viewController];
    return [self popToViewControllerAtIndex:index animated:YES];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self popToViewControllerAtIndex:0 animated:animated];
}

- (void)clearAllViewControllers
{
    for (int index = [self.viewControllers count]-1; index >= 0; index--)
    {
        SNViewController *controller = [self.viewControllers objectAtIndex:index];
        if ([controller respondsToSelector:@selector(slideNavigationController:willPopViewController:)]) {
            [controller slideNavigationController:self willPopViewController:controller];
            if (controller.modalViewController) {
                [controller dismissModalViewControllerAnimated:NO];
            }
        }
    }
}

#pragma mark - message

- (void)pushViewController:(SNViewController *)viewController animated:(BOOL)animated message:(NSDictionary *)message
{
    [self pushViewController:viewController animated:animated completion:^{
        if ([self.viewControllers containsObject:viewController])
        {
            [viewController handleMessage:message viewController:[self belowViewController]];
        }
    }];
}

- (void)postMessageToViewController:(NSDictionary *)message viewController:(SNViewController *)viewController
{
    if (viewController != nil)
    {
        [viewController handleMessage:message viewController:viewController];
    }
}

- (void)postMessageToParentViewController:(NSDictionary *)message viewController:(SNViewController *)viewController
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index > 0 && index < [self.viewControllers count])
    {
        SNViewController * controller = self.viewControllers[index-1];
        if (controller != nil)
        {
            [controller handleMessage:message viewController:viewController];
        }

    }
    
}

//- (void)postMessageToParentViewController:(NSDictionary *)message viewController:(SNViewController *)viewController
//{
//    if ([[self currentViewController] isEqual:viewController])
//    {
//        if ([self belowViewController] && [[self belowViewController] isKindOfClass:[SNSlideController class]])
//        {
//            SNSlideStatus status = ((SNSlideController *)[self belowViewController]).topControllerStatus;
//            SNViewController *controller = nil;
//            switch (status) {
//                    case SNSlideStatusCenter:
//                {
//                    controller = ((SNSlideController *)[self belowViewController]).topController;
//                }
//                    break;
//                    
//                    case SNSlideStatusLeft:
//                {
//                    controller = ((SNSlideController *)[self belowViewController]).rightController;
//                }
//                    break;
//                    
//                    case SNSlideStatusRight:
//                {
//                    controller = ((SNSlideController *)[self belowViewController]).leftController;
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            if (controller != nil)
//            {
//                [controller handleMessage:message viewController:viewController];
//            }
//        }
//    }
//}


#pragma mark - Pan

- (CGPoint)adjustedTranslation:(CGPoint)translation
{
    CGPoint adjustedTranslation = translation;
    CGRect frame = CGRectOffset(self.selectedController.view.frame, translation.x, 0);
    if (translation.x < 0
             && CGRectGetMinX(frame) < CGRectGetMinX(self.view.bounds)) {
        adjustedTranslation.x = CGRectGetMinX(self.view.bounds) - CGRectGetMinX(self.selectedController.view.frame);
    }
    else if (translation.x > 0
             && CGRectGetMinX(frame) > CGRectGetMaxX(self.view.bounds)) {
        adjustedTranslation.x = CGRectGetMaxX(self.view.bounds) - CGRectGetMinX(self.selectedController.view.frame);
    }
    
    return adjustedTranslation;
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint translation = [gesture translationInView:self.view];
        SNViewController *controller = nil;
        if (translation.x >= 0) {
            controller = [self currentViewController];
        }
        else {
            SNViewController *rightController = [[self currentViewController] rightViewController];
            rightController.slideNavigationController = self;
            [self addShadowForController:rightController];
            CGRect frame = self.view.bounds;
            frame.origin.x = CGRectGetWidth(self.view.bounds);
            rightController.view.frame = frame;
            [self.view addSubview:rightController.view];
            // iOS < 5.0 viewWill/DidAppear not call when addSubview
//            if (iOSVersionLessThan_5_0()) {
//                [rightController viewWillAppear:NO];
//                [rightController viewDidAppear:NO];
//            }
            
            controller = rightController;
        }
        
        if (controller == nil || controller.isPanValid == NO) {
            self.selectedController = nil;
            self.panValid = NO;
        }
        else {
            [self addObserverForController:controller];
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
        self.selectedController.view.frame = CGRectOffset(self.selectedController.view.frame, translation.x, 0);
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded
             || gesture.state == UIGestureRecognizerStateCancelled)
    {
        if (!self.isPanValid) {
            return;
        }
        
        [self removeObserverForController:self.selectedController];
        
        [self layoutSelectedController:self.selectedController
                      andPanGestureRecognizer:gesture];
        
        self.selectedController = nil;
        self.panValid = NO;
    }
}

#pragma mark - Gesture Delegate

- (BOOL)shouldBeginPanGestureRecognizer
{
    BOOL shouldBegin = YES;
    
    SNViewController *controller = [self currentViewController];
    if (controller == nil
        || controller.modalViewController
        || (controller.navigationController && [controller.navigationController viewControllers].count > 1)
        || !controller.isPanValid) {
        shouldBegin = NO;
    }
    
    return shouldBegin;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = YES;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y)/MAX(fabs(translation.x), 0.0001) > kTriggerThreshold) {
            shouldBegin = NO;
        }
        else if (translation.x >= 0 && self.viewControllers.count < 2) {
            shouldBegin = NO;
        }
        else if (translation.x <= 0 && ![(SNViewController *)[self currentViewController] hasRightViewController]) {
            shouldBegin = NO;
        }
        else {
            shouldBegin = [self shouldBeginPanGestureRecognizer];
        }
    }
    
    return shouldBegin;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL shouldReceive = YES;
    
    if (self.isLayouting
        || self.modalViewController
        || (self.navigationController && [self.navigationController viewControllers].count > 1)) {
        shouldReceive = NO;
    }
    else if([touch.view isKindOfClass:[UISlider class]])
    {
        // 解决UISlider和Pan手势冲突的问题
        shouldReceive = NO;
    }
    
    return shouldReceive;
}

@end
