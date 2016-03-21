//
//  AppDelegate.m
//  CollegeUnion
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "AppDelegate.h"
#import "SNTabViewController.h"
#import "AppCore.h"
#import "CUUIContant.h"
#import "BMapKit.h"
#import "CUUserManager.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "MobClick.h"
#import "CUShareConstant.h"

#import "SNTabBarItem.h"
#import "UIConstants.h"

#import "SNIntroduceView.h"
#import "CUPlatFormManager.h"

#import "HomeViewController.h"
#import "UserCenterController.h"
#import "VIPController.h"
#import "NearbyController.h"

#import "UserViewController.h"
#import "OrderManager+ThirdPay.h"
#import "Pingpp.h"

#import "LaunchView.h"

#import "IQKeyboardManager.h"

@interface AppDelegate () <BMKGeneralDelegate>

@property (nonatomic,strong)SNTabViewController * tabController;

@end

@implementation AppDelegate
{
    BMKMapManager *_mapManager;
    BMKLocationService *_locService;
    BMKGeoCodeSearch   *_geoSearcher;
}

+ (AppDelegate *)app
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AppCore sharedInstance] load];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //输入框随键盘高度自动调整位置
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
    // 地图
    [self initMapService];
    
    // TODO:暂时关闭基础组件
    // 统计
    //[MobClick startWithAppkey:UmengAppkey reportPolicy:BATCH channelId:kChannelID];
    //[MobClick setAppVersion:[CUPlatFormManager currentAppVersion]];
    
    // 分享
    //[self initShare];
    
    // 主页面
    [self startLaunchView];
//    [self launchFirstView];
    
    // 版本号
    [[CUPlatFormManager sharedInstance] sychronizeVersion];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initShare
{
    // 友盟分享
    [UMSocialData setAppKey:UmengAppkey];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx2bdc2e8d006e143a" appSecret:@"98ab890642e1bb1144334ab140abb1cd" url:kAppShareURL];
    
    //打开新浪微博的SSO开关
    //[UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104732674" appKey:@"hskafPocswDChVyA" url:kAppShareURL];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar,
                                             UIButton *closeButton,
                                             UIButton *backButton,
                                             UIButton *postButton,
                                             UIButton *refreshButton,
                                             UINavigationItem * navigationItem){
        bar.frame = CGRectMake(0, 0, kScreenWidth, kNavigationHeight);
        
        if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [bar setBackgroundImage:[UIImage imageNamed:ImgStr_NavBackground] forBarMetrics:UIBarMetricsDefault];
        }
        
        [closeButton setImage:[UIImage imageNamed:imgStr_CloseBtn] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:ImgStr_BackBtn] forState:UIControlStateNormal];
        
        [postButton setImage:nil forState:UIControlStateNormal];
        [postButton setTitle:@"发送" forState:UIControlStateNormal];
        [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [refreshButton setImage:nil forState:UIControlStateNormal];
        refreshButton.userInteractionEnabled = NO;
        
        UILabel *titleLabel = (id)navigationItem.titleView;
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            titleLabel.textColor = [UIColor whiteColor];
        }
        
        UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        leftSpacer.width = -15;
        
        if (navigationItem.leftBarButtonItems.count == 1) {
            navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSpacer, [navigationItem.leftBarButtonItems objectAtIndex:0], nil];
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [_locService stopUserLocationService];
    
    [[AppCore sharedInstance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_locService startUserLocationService];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)startLaunchView{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchFirstView) name:@"LaunchFirstView" object:nil];
    LaunchView * launchView = [[LaunchView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    launchView.alpha = 0;
    UIViewController * vc = [[UIViewController alloc] init];
    vc.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [vc.view addSubview:launchView];
    self.window.rootViewController = vc;
    [UIView animateWithDuration:0.2 animations:^{
        launchView.alpha = 1;
    }];
    
}

- (void)launchFirstView
{
    // 启动画面->新手引导->主页面
    // 新安装
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterFirstView) name:@"AfterFirstView" object:nil];
    if ([CUPlatFormManager sharedInstance].isNewInstall)
    {
        [self launchIntroduceView];
    }
    else
    {
        [self launchMainView];
    }
}

- (void)afterFirstView{
    [[CUPlatFormManager sharedInstance] save];
    [self launchMainView];
}

- (void)launchMainView
{
    //showStatusBar
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0))
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    if (self.slideNaviController == nil)
    {
        self.slideNaviController = [[SNSlideNavigationController alloc] initWithRootViewController:[self createTabBarController]];
//        [[UINavigationBar appearance] setTitleTextAttributes:
//         [NSDictionary dictionaryWithObjectsAndKeys:
//          [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
//          UITextAttributeTextColor,
//          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//          UITextAttributeTextShadowColor,
//          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//          UITextAttributeTextShadowOffset,
//          [UIFont fontWithName:@"Arial-Bold" size:0.0],
//          UITextAttributeFont,
//          nil]];
    }
    self.window.rootViewController = self.slideNaviController;
    self.slideNaviController.view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.slideNaviController.view.alpha = 1;
    }];
   
   

}

- (void)launchIntroduceView
{
//    [SNIntroduceView showWithComplete:^(SNIntroduceView *introduceView){
//        [self launchMainView];
//    }];
    SNIntroduceView *intro = [[SNIntroduceView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController * vc = [[UIViewController alloc] init];
    vc.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [vc.view addSubview:intro];
    self.window.rootViewController = vc;
    vc.view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        vc.view.alpha = 1;
    }];
    
}

- (SNTabViewController*)createTabBarController
{
    HomeViewController *homeVC = [[HomeViewController alloc] initWithPageName:@"HomeViewController"];
    homeVC.customTabBarItem = [self tabBarItemAtIndex:0];
    
    NearbyController *orderVC = [[NearbyController alloc] initWithPageName:@"NearbyController"];
    orderVC.customTabBarItem = [self tabBarItemAtIndex:1];
    
    VIPController *scoreBoradVC = [[VIPController alloc] initWithPageName:@"VIPController"];
    scoreBoradVC.customTabBarItem = [self tabBarItemAtIndex:2];
    
    UserViewController *userVC = [[UserViewController alloc] initWithPageName:@"UserViewController"];
    userVC.customTabBarItem = [self tabBarItemAtIndex:3];
    
    self.tabController = [[SNTabViewController alloc] initWithHeight:Height_Tabbar];
    self.tabController.viewControllers = @[homeVC,orderVC,scoreBoradVC,userVC];
    
    self.tabController.selectedIndex = 0;
    self.tabController.customTabBar.selectedIndex = 0;
    
    return self.tabController;
}

- (SNTabBarItem *)tabBarItemAtIndex:(int)index
{
    NSArray *titles = @[@"优医",@"优医馆",@"vip",@"我的"];
    NSArray *norIcons = @[@"tabbar_home_nor",@"tabbar_nearby_nor",@"tabbar_vip_nor",@"tabbar_mine_nor"];
//    NSArray *hilIcons = @[@"tabbar_icon_home_highlighted",@"tabbar_icon_service_highlighted",@"tabbar_icon_discount_highlighted",@"tabbar_icon_mine_highlighted"];
   NSArray *selIcons = @[@"tabbar_home_sel",@"tabbar_nearby_sel",@"tabbar_vip_sel",@"tabbar_mine_sel"];
    
//    NSArray *titles = @[@"养生",@"附近",@"首页",@"上门",@"我的"];
//    NSArray *norIcons = @[@"tabbar_home_nor",@"tabbar_order_nor",@"tabbar_home_nor",@"tabbar_rank_nor",@"tabbar_mine_nor"];
//    //    NSArray *hilIcons = @[@"tabbar_icon_home_highlighted",@"tabbar_icon_service_highlighted",@"tabbar_icon_discount_highlighted",@"tabbar_icon_mine_highlighted"];
//    NSArray *selIcons = @[@"tabbar_home_sel",@"tabbar_order_sel",@"tabbar_home_sel",@"tabbar_rank_sel",@"tabbar_mine_sel"];
    
    float tabBarWidth = kScreenWidth / titles.count;
    SNTabBarItem *customTabBarItem = [[SNTabBarItem alloc] initWithFrame:CGRectMake(tabBarWidth * index, 0, tabBarWidth, Height_Tabbar)];
    customTabBarItem.image = [UIImage imageNamed:[norIcons objectAtIndex:index]];
    customTabBarItem.selectedImage = [UIImage imageNamed:[selIcons objectAtIndex:index]];
    
    customTabBarItem.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    //customTabBarItem.title = [titles objectAtIndex:index];
    customTabBarItem.showTitle = NO;
    customTabBarItem.titleColor = UIColorFromHex(0xabaeb2);
    customTabBarItem.selectedTitleColor = kDarkBlueColor;
    return customTabBarItem;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[CUOrderManager sharedInstance] isThirdPayURL:url]) {
        [[CUOrderManager sharedInstance] handleThirdPayOpenURL:url];
    }
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    if ([[CUOrderManager sharedInstance] isThirdPayURL:url]) {
//        [[CUOrderManager sharedInstance] handleThirdPayOpenURL:url];
//    }
//    
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
// IOS greater than 9
    BOOL canHandleURL =  [Pingpp handleOpenURL:url withCompletion:nil];
    return canHandleURL;
}


#pragma mark - BMKMapManager Delegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark - MKMapView Delegate

//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation) {
        NSString *baiduLat = [[NSString alloc] initWithFormat:@"%f",userLocation.location.coordinate.latitude];
        
        NSString *baiduLng = [[NSString alloc] initWithFormat:@"%f",userLocation.location.coordinate.longitude];
        NSLog(@"x=%@,y=%@",baiduLat,baiduLng);
        [[NSUserDefaults standardUserDefaults] setObject:baiduLat forKey:@"lat"];
        [[NSUserDefaults standardUserDefaults] setObject:baiduLng forKey:@"lng"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_locService stopUserLocationService];
        
        BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
        option.reverseGeoPoint = userLocation.location.coordinate;
        [_geoSearcher reverseGeoCode:option];
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSString *cityName = [result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        NSLog(@"当前城市是 %@", cityName);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)initMapService
{
    // 要使用百度地图，请先启动BaiduMapManager
    // com.wallet.BaiduFinance iECHAdtn1ql3FlkGKasXyGbs
    // com.jiayu.eshijia hm8ufnt0raPVEUrMRSdrb8qq
    _mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [_mapManager start:@"iECHAdtn1ql3FlkGKasXyGbs" generalDelegate:self];
    BOOL ret = [_mapManager start:@"AZkRPuUHS62q0zY9oPQqPNmZ" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    
    _geoSearcher = [[BMKGeoCodeSearch alloc]init];
    _geoSearcher.delegate = (id)self;
}

@end
