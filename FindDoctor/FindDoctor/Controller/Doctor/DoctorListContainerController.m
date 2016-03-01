//
//  DoctorListContainerController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorListContainerController.h"
#import "SNViewController+Nav.h"
#import "SNTopTabViewController.h"
#import "DoctorListController.h"
#import "SNTopTabBarItem.h"
#import "UIConstants.h"

@interface DoctorListContainerController ()

@end

@implementation DoctorListContainerController

- (id)initWithHeight:(NSInteger)height
{
    self = [super initWithHeight:height];
    
    if (self) {
        self.hasNavigationBar = YES;
        
        self.showBottomLine = YES;
        self.bottomLineWidth = kScreenWidth / 3;// 76 * kScreenRatio;
        
        [self initControllers];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找医生";
    
    [self addLeftBackButtonItemWithImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControllers
{
    DoctorListModel * listModel1 = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeRate];
    DoctorListController * controller1 = [[DoctorListController alloc] initWithPageName:@"DoctorListController_rate" listModel:listModel1];
    controller1.customTabBarItem = [self orderTabBarItemAtIndex:0];
    
    DoctorListModel * listModel2 = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeDistance];
    DoctorListController * controller2 = [[DoctorListController alloc] initWithPageName:@"DoctorListController_distance" listModel:listModel2];
    controller2.customTabBarItem = [self orderTabBarItemAtIndex:1];
    
    DoctorListModel *listModel3 = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeDistance];
    DoctorListController * controller3 = [[DoctorListController alloc] initWithPageName:@"DoctorListController_available" listModel:listModel3];
    controller3.customTabBarItem = [self orderTabBarItemAtIndex:2];
    
    self.viewControllers = @[controller1,controller2,controller3];
}

- (id)orderTabBarItemAtIndex:(int)index
{
    NSArray *titles = @[@"口碑",@"距离",@"可约"];
    
    float tabBarWidth = kScreenWidth / titles.count;
    SNTopTabBarItem *customTabBarItem = [[SNTopTabBarItem alloc] initWithFrame:CGRectMake(tabBarWidth * index, 0, tabBarWidth, kTopTabBarHeight)];
    //    customTabBarItem.selectedImage = [UIImage imageNamed:[selIcons objectAtIndex:0]];
    customTabBarItem.title = [titles objectAtIndex:index];
    customTabBarItem.titleColor = kBlackColor;
    customTabBarItem.selectedTitleColor = kGreenColor;
    //customTabBarItem.showBottomLine = NO;
    
    return customTabBarItem;
}

@end
