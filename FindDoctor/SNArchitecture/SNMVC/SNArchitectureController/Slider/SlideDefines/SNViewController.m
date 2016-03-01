//
//  SNViewController.m
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNViewController.h"
#import "SNNavigationBar.h"
#import "UINavigationBar+Background.h"
//#import "UIToolbar+Background.h"
#import "UIImage+Color.h"
#import "SNUISystemConstant.h"

@interface SNViewController ()
{
    BOOL    _navigationItemPushed;
}

@property (nonatomic, assign) BOOL  navigationItemPushed;
@property (nonatomic,retain,readwrite)NSString * identifier;

- (void)setupNavigationBar;
- (void)setupToolbar;
- (void)setupMaskView;

@end

@implementation SNViewController

@synthesize identifier = _identifier,pageName = _pageName;


@synthesize hasNavigationBar = _hasNavigationBar;
@synthesize hasToolbar = _hasToolbar;
@synthesize hasRightViewController = _hasRightViewController;

@synthesize navigationBarHeight = _navigationBarHeight;
@synthesize toolbarHeight = _toolbarHeight;

@synthesize maskView = _maskView;

@synthesize navigationBar = _navigationBar;
@synthesize toolbar = _toolbar;
@synthesize slideController = _slideController;
@synthesize slideNavigationController = _slideNavigationController;

@synthesize navigationItemPushed = _navigationItemPushed;
@synthesize isPanValid = _isPanValid;
@synthesize canRotate  = _canRotate;

@synthesize customTabBarItem = _customTabBarItem;


#pragma mark life cycle
- (void)dealloc
{
    [_identifier release], _identifier = nil;
    
    [_maskView release], _maskView = nil;
    [_navigationBar release], _navigationBar = nil;
    [_toolbar release], _toolbar = nil;
    _slideController = nil;
    _slideNavigationController = nil;
    
    self.customTabBarItem = nil;
    
    [super dealloc];
}

- (instancetype)initWithPageName:(NSString *)pageName
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.identifier = [NSString stringWithFormat:@"identifier_%p", self];
        self.pageName = pageName;
        self.hasNavigationBar = YES;
        self.hasToolbar = NO;
        self.hasRightViewController = NO;
        self.navigationItemPushed = NO;
        self.navigationBarHeight = kDefaultNavigationBarHeight;
        self.toolbarHeight = kDefaultToolbarHeight;
        self.isPanValid = YES;
        self.canRotate = NO;
        self.releaseViewWhileMemoryWarning = YES;
    }
    
    return self;

}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.identifier = [NSString stringWithFormat:@"identifier_%p", self];
        self.hasNavigationBar = YES;
        self.hasToolbar = NO;
        self.hasRightViewController = NO;
        self.navigationItemPushed = NO;
        self.navigationBarHeight = kDefaultNavigationBarHeight;
        self.toolbarHeight = kDefaultToolbarHeight;
        self.isPanValid = YES;
        self.canRotate = NO;
        self.releaseViewWhileMemoryWarning = YES;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.identifier = [NSString stringWithFormat:@"identifier_%p", self];
        self.hasNavigationBar = YES;
        self.hasToolbar = NO;
        self.hasRightViewController = NO;
        self.navigationItemPushed = NO;
        self.navigationBarHeight = kDefaultNavigationBarHeight;
        self.toolbarHeight = kDefaultToolbarHeight;
        self.isPanValid = YES;
        self.canRotate = NO;
        self.releaseViewWhileMemoryWarning = YES;
    }
    
    return self;
}

- (void)handleMessage:(NSDictionary *)message viewController:(SNViewController *)viewController
{
    
}

#pragma mark NavigationBar & TabBar & ToolBar
- (SNTabBarItem *)customTabBarItem
{
    if (!_customTabBarItem) {
        SNTabBarItem *tabBarItem = [[SNTabBarItem alloc] init];
        self.customTabBarItem = tabBarItem;
        [tabBarItem release];
    }
    
    return _customTabBarItem;
}

- (void)setCustomTabBarItem:(SNTabBarItem *)customTabBarItem
{
    if (_customTabBarItem) {
        [_customTabBarItem release], _customTabBarItem = nil;
    }
    
    _customTabBarItem = [customTabBarItem retain];
}

- (CGFloat)navigationBarHeight
{
    if (self.hasNavigationBar) {
        return _navigationBarHeight;
    }
    else {
        return 0;
    }
}

- (CGFloat)toolbarHeight
{
    if (self.hasToolbar) {
        return _toolbarHeight;
    }
    else {
        return 0;
    }
}

- (CGRect)subviewFrame
{
    return CGRectMake(0, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.navigationBarHeight-self.toolbarHeight);
}

- (SNViewController *)rightViewController
{
    return nil;
}

- (UINavigationItem *)navigationItem
{
    UINavigationItem *naviItem = [super navigationItem];
    if (naviItem && self.hasNavigationBar && !self.navigationItemPushed) {
        [self setupNavigationBar];
        [self.navigationBar pushNavigationItem:naviItem animated:NO];
        self.navigationItemPushed = YES;
    }
    
    return naviItem;
}

- (void)setToolbarItems:(NSArray *)toolbarItems
{
    [super setToolbarItems:toolbarItems];
    if (self.hasToolbar) {
        [self setupToolbar];
        [self.toolbar setItems:toolbarItems];
    }
}

- (void)setToolbarItems:(NSArray *)toolbarItems animated:(BOOL)animated
{
    [super setToolbarItems:toolbarItems animated:animated];
    if (self.hasToolbar) {
        [self setupToolbar];
        [self.toolbar setItems:toolbarItems animated:animated];
    }
}

- (void)setupNavigationBar
{
    if (self.navigationBar == nil)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)) {
            _navigationBar = [[SNNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.navigationBarHeight)];
        }
    }
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (self.navigationBar.superview == nil) {
        if (self.isViewLoaded) {
            //_navigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.navigationBarHeight - 0.5);
            [(SNView *)self.view suppressDelegateForAction:^{
                [self.view addSubview:_navigationBar];
            }];
        }
    }
}

- (void)setupToolbar
{
    if (self.toolbar == nil) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds])-20-self.toolbarHeight, 320, self.toolbarHeight)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    }
    
    if (self.toolbar.superview == nil) {
        if (self.isViewLoaded) {
            _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-self.toolbarHeight, CGRectGetWidth(self.view.bounds), self.toolbarHeight);
            [(SNView *)self.view suppressDelegateForAction:^{
                [self.view addSubview:_toolbar];
            }];
        }
    }
}

- (void)setupMaskView
{
    _maskView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, -kShadowRaidus, -kShadowRaidus)];
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _maskView.userInteractionEnabled = NO;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.0;
    [(SNView *)self.view suppressDelegateForAction:^{
        [self.view addSubview:_maskView];
    }];
}

- (void)setNavigationBarTintColor:(UIColor *)tintColor
{
    if (self.navigationBar && [self.navigationBar respondsToSelector:@selector(setTintColor:)])
    {
        [self.navigationBar setTintColor:tintColor];
    }
}

- (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage
{
    if (self.navigationBar && [self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setToolbarTintColor:(UIColor *)tintColor
{
    if (self.toolbar && [self.toolbar respondsToSelector:@selector(setTintColor:)])
    {
        [self.toolbar setTintColor:tintColor];
    }
}

- (void)setToolbarBackgroundImage:(UIImage *)backgroundImage
{
    if (self.toolbar && [self.toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)])
    {
        [self.toolbar setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

#pragma mark SNViewDelegate
- (void)viewDidAddSubview:(UIView *)view
{
    if (self.hasNavigationBar && self.navigationBar) {
        [self.view bringSubviewToFront:self.navigationBar];
    }
    if (self.hasToolbar && self.toolbar) {
        [self.view bringSubviewToFront:self.toolbar];
    }
    if (self.maskView) {
        [self.view bringSubviewToFront:self.maskView];
    }
}

- (void)viewDidBringSubviewToFront:(UIView *)view
{
    if (self.hasNavigationBar && self.navigationBar) {
        [(SNView *)self.view suppressDelegateForAction:^{
            [self.view bringSubviewToFront:self.navigationBar];
        }];
    }
    if (self.hasToolbar && self.toolbar) {
        [(SNView *)self.view suppressDelegateForAction:^{
            [self.view bringSubviewToFront:self.toolbar];
        }];
    }
    if (self.maskView) {
        [(SNView *)self.view suppressDelegateForAction:^{
            [self.view bringSubviewToFront:self.maskView];
        }];
    }
}

#pragma mark view life cycle

- (void)loadView
{
    [super loadView];
    SNView *view = [[SNView alloc] initWithFrame:self.view.frame];
    view.transform = self.view.transform;
    view.contentScaleFactor = self.view.contentScaleFactor;
    view.multipleTouchEnabled = self.view.isMultipleTouchEnabled;
    view.exclusiveTouch = self.view.isExclusiveTouch;
    view.autoresizingMask = self.view.autoresizingMask;
    view.clipsToBounds = self.view.clipsToBounds;
    view.backgroundColor = self.view.backgroundColor;
    view.alpha = self.view.alpha;
    view.opaque = self.view.isOpaque;
    view.clearsContextBeforeDrawing = self.view.clearsContextBeforeDrawing;
    view.hidden = self.view.isHidden;
    view.contentMode = self.view.contentMode;
    view.contentStretch = self.view.contentStretch;
    view.delegate = self;
    self.view = view;
    [view release];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
//    [self setNeedsStatusBarAppearanceUpdate];
    if (self.hasNavigationBar)
    {
        [self setupNavigationBar];
        [self.navigationBar performSelectorOnMainThread:@selector(useDefaultBlackBackgroundImage) withObject:nil waitUntilDone:YES];
        
        [self.navigationBar setShadowImage:[UIImage imageNamed:@"navigationbar_background_shadow"]];
    }
    if (self.hasToolbar) {
        [self setupToolbar];
        [self.toolbar useCustomBackgroundImage];
    }
    [self setupMaskView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (self.hasNavigationBar && self.navigationBar) {
        [self.navigationBar removeFromSuperview];
        self.navigationBar = nil;
        self.navigationItemPushed = NO;
    }
    if (self.hasToolbar && self.toolbar) {
        [self.toolbar removeFromSuperview];
        self.toolbar = nil;
    }

    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

- (void)didReceiveMemoryWarning
{
    [self handleMemoryWarning];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Memory Warning

- (void)handleMemoryWarning
{
    BOOL shouldClean = NO;
    if ([self shouldReleaseView])
    {
        shouldClean = YES;
    }
    
    [self cleanupViews:shouldClean];
}

- (BOOL)shouldReleaseView
{
    BOOL shouldReleaseView = NO;
    
    if (!self.releaseViewWhileMemoryWarning)
    {
        shouldReleaseView = NO;
    }
    else
    {
        //release rule:1.not shown in window 2.no modal view shown
        if (self.isViewLoaded && ![self.view window] && !self.presentedViewController)
        {
            shouldReleaseView = YES;
        }
    }
    
    return shouldReleaseView;
}

- (void)cleanupViews:(BOOL)shouldClean
{
    if (shouldClean)
    {
//        self.view = nil;
    }
}

- (void)backAction
{
    [self.slideNavigationController popViewControllerAnimated:YES];
}

- (void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
