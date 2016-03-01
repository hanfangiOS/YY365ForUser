//
//  SNTabViewController.m
//  YiRen
//
//  Created by frostfeng on 14-3-6.
//  Copyright (c) 2014年. All rights reserved.
//

#import "SNTopTabViewController.h"
#import "SNTopTabBar.h"
#import "UIViewController+ViewControllerContainerment.h"
#import "SNSlideNavigationController+SNSlideStack.h"
#import "UIImage+Color.h"

#define kTabBarHeight 44.0f

@interface SNTopTabViewController ()<SNTopTabBarDelegate>
{
    NSMutableArray * _viewControllers;
}

@property (nonatomic, retain) SNTopTabBar      *customTabBar;
@property (nonatomic, assign,readwrite) CGFloat       tabBarHeight;
@property (nonatomic, readonly) NSUInteger  lastSelectedIndex;
@property (nonatomic, assign) UIViewController  *selectedViewController;

@end

@implementation SNTopTabViewController

#pragma mark life cycle
- (instancetype)initWithHeight:(NSInteger)height
{
    if (self = [super init])
    {
       
        self.hasNavigationBar = NO;
        self.hasRightViewController = NO;
        self.tabBarHeight = height;
        _selectedIndex = NSNotFound;        //do not use self.selectedIndex, which will invoke a method call
        self.releaseViewWhileMemoryWarning = NO;
      
    }
    return self;
}


- (id)init
{
    if (self = [super init])
    {
        
        self.hasNavigationBar = NO;
        self.hasRightViewController = NO;
        self.tabBarHeight = kTabBarHeight;
        _selectedIndex = NSNotFound;        //do not use self.selectedIndex, which will invoke a method call
        self.releaseViewWhileMemoryWarning = NO;
        
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hasNavigationBar = NO;
        self.hasRightViewController = NO;
        self.tabBarHeight = kTabBarHeight;
        _selectedIndex = NSNotFound;        //do not use self.selectedIndex, which will invoke a method call
        self.releaseViewWhileMemoryWarning = NO;
    }
    return self;
}

- (void)dealloc
{
    [self releaseChildViewControllers];
    self.viewControllers = nil;
    self.selectedViewController = nil;
    self.customTabBar = nil;
    
    [super dealloc];
}


#pragma mark view life cycle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect tabBarFrame = CGRectMake(0, 64.5, CGRectGetWidth(self.view.bounds), self.tabBarHeight);
    self.customTabBar = [[[SNTopTabBar alloc] initWithFrame:tabBarFrame] autorelease];
    _customTabBar.animateSelection = NO;
    _customTabBar.delegate = self;
    _customTabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _customTabBar.showBottomLine = self.showBottomLine;
    _customTabBar.bottomLineWidth = self.bottomLineWidth;
    _customTabBar.backgroundColor = [UIColor whiteColor];
    _customTabBar.shadowImage = [UIImage createImageWithColor:UIColorFromHex(0xdddddd)];
    [self.view addSubview:self.customTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.slideNavigationController currentViewController] == self)
    {
        [self.selectedViewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.slideNavigationController currentViewController] == self)
    {
        [self.selectedViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.slideNavigationController currentViewController] == self)
    {
        [self.selectedViewController endAppearanceTransition];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self.slideNavigationController currentViewController] == self)
    {
        [self.selectedViewController endAppearanceTransition];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (NSArray *)viewControllers
{
    return [[_viewControllers copy] autorelease];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    (void)(self.view);
    if (_viewControllers != viewControllers)
    {
        _viewControllers = viewControllers ? [viewControllers mutableCopy] : [NSMutableArray array];
        
        _selectedIndex = NSNotFound;
        
        if ([viewControllers count] > 0)
        {
            NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:5];
            for (SNViewController *viewController in _viewControllers)
            {
                [self sn_addChildViewController:viewController];
                [viewController didMoveToParentViewController:self];
                
                if ([viewController isKindOfClass:[SNViewController class]])
                {
                    [items addObject:viewController.customTabBarItem];
                }
            }
            [self.customTabBar setItems:items animated:NO];
            [items release];
            
            self.selectedIndex = SNTabBarDefaultSelctedIndex;
        }
    }
}

- (void)releaseChildViewControllers
{
    for (UIViewController *viewController in self.childViewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController sn_removeFromParentViewController];
    }
}


- (UIViewController *)selectedViewController
{
    return self.selectedIndex == NSNotFound ? nil : [_viewControllers objectAtIndexSafely:self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= _viewControllers.count)
    {
        return;
    }
    
    if (_selectedIndex != selectedIndex)
    {
        UIViewController * lastSelectedController = [_viewControllers objectAtIndexSafely:self.selectedIndex];
        UIViewController * selectedController = [_viewControllers objectAtIndexSafely:selectedIndex];
        
        _selectedIndex = selectedIndex;
        
        // set frame
        selectedController.view.frame = self.view.bounds;
        
        BOOL inWindow = self.view.window != nil;
        if (inWindow)
        {
            [selectedController beginAppearanceTransition:YES animated:NO];
            [lastSelectedController beginAppearanceTransition:NO animated:NO];
        }
        
        [self.view insertSubview:selectedController.view belowSubview:self.customTabBar];
        [lastSelectedController.view removeFromSuperview];
        
        if (inWindow)
        {
            [selectedController endAppearanceTransition];
            [lastSelectedController endAppearanceTransition];
        }
        
        [self.view setNeedsLayout];
    }
}

- (void)setSlideNavigationController:(SNSlideNavigationController *)slideNavigationController
{
    _slideNavigationController = slideNavigationController;
    
    for (SNViewController *viewController in self.viewControllers)
    {
        if ([viewController respondsToSelector:@selector(setSlideNavigationController:)])
        {
            viewController.slideNavigationController = slideNavigationController;
        }
    }
}

#pragma mark Override from UIContainerViewControllerCallbacks
- (BOOL)shouldAutomaticallyForwardAppearanceMethods NS_AVAILABLE_IOS(6_0)
{
    return NO;
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers NS_DEPRECATED_IOS(5_0,6_0) {
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods NS_AVAILABLE_IOS(6_0) {
    return NO;
}

#pragma mark - SNTabBarDelegate
- (void)tabBar:(SNTopTabBar *)tabBar didSelectItemAtIndex:(NSUInteger)index tabBarItem:(SNTabBarItem *)item
{
    id viewController = [self.viewControllers objectAtIndexSafely:index];
    if (index == _selectedIndex)
    {
        if ([self.viewControllers count])
        {
            if ([viewController isKindOfClass:[UINavigationController class]])
            {
                id vc = [viewController topViewController];
                if (vc == [viewController visibleViewController])
                {
                    if (vc && [vc respondsToSelector:@selector(tabViewControllerSingleTap:)])
                    {
                        [(id<SNTopTabBarTapDelegate>)vc tabViewControllerSingleTap:self];
                    }
                }
            }
            else
            {
                if (viewController && [viewController respondsToSelector:@selector(tabViewControllerSingleTap:)])
                {
                    [viewController tabViewControllerSingleTap:self];
                }
            }
        }
    }
    else
    {
        self.selectedIndex = index;
        if ([viewController isKindOfClass:[UINavigationController class]])
        {
            id vc = [viewController topViewController];
            if (vc == [viewController visibleViewController])
            {
                if (vc && [vc respondsToSelector:@selector(tabViewControllerChangeSelectTap:)])
                {
                    [(id<SNTopTabBarTapDelegate>)vc tabViewControllerChangeSelectTap:self];
                }
            }
        }
        else
        {
            if (viewController && [viewController respondsToSelector:@selector(tabViewControllerChangeSelectTap:)])
            {
                [viewController tabViewControllerChangeSelectTap:self];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSNTabViewControllerDidChangeNotification object:self];
    }
    
}

@end
