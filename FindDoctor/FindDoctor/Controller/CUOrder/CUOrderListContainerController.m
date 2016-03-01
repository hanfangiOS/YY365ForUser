//
//  CUOrderListContainerController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/31.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderListContainerController.h"
#import "SNViewController+Nav.h"
#import "SNTopTabViewController.h"
#import "CUOrderListViewController.h"
#import "SNTopTabBarItem.h"
#import "UIConstants.h"

@interface CUOrderListContainerController ()

@end

@implementation CUOrderListContainerController

- (id)initWithHeight:(NSInteger)height
{
    self = [super initWithHeight:height];
    
    if (self) {
        self.hasNavigationBar = YES;
        
        self.showBottomLine = YES;
        self.bottomLineWidth = kScreenWidth / 2;// 76 * kScreenRatio;
        
        [self initControllers];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的记录";
    
    [self addLeftBackButtonItemWithImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControllers
{
    CUOrderListModel * listModel1 = [[CUOrderListModel alloc] initWithOrderStatus:ORDERSTATUS_ALL];
    CUOrderListViewController * controller1 = [[CUOrderListViewController alloc] initWithPageName:@"OrderListController_All" listModel:listModel1];
    controller1.customTabBarItem = [self orderTabBarItemAtIndex:0];
    
    CUOrderListModel * listModel2 = [[CUOrderListModel alloc] initWithOrderStatus:ORDERSTATUS_FINISHED];
    CUOrderListViewController * controller2 = [[CUOrderListViewController alloc] initWithPageName:@"OrderListController_Finished" listModel:listModel2];
    controller2.customTabBarItem = [self orderTabBarItemAtIndex:1];
    
    self.viewControllers = @[controller1,controller2];
}

- (id)orderTabBarItemAtIndex:(int)index
{
    NSArray *titles = @[@"我的约诊",@"我的就诊"];
    
    float tabBarWidth = kScreenWidth / titles.count;
    SNTopTabBarItem *customTabBarItem = [[SNTopTabBarItem alloc] initWithFrame:CGRectMake(tabBarWidth * index, 0, tabBarWidth, kTopTabBarHeight)];
    customTabBarItem.title = [titles objectAtIndex:index];
    customTabBarItem.titleColor = kBlackColor;
    customTabBarItem.selectedTitleColor = kGreenColor;
    //customTabBarItem.showBottomLine = NO;
    
    return customTabBarItem;
}

@end
