//
//  AppDelegate.h
//  CollegeUnion
//
//  Created by li na on 15/2/17.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSlideNavigationController.h"
//#import "CULoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)app;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SNSlideNavigationController  * slideNaviController;
//@property (nonatomic,strong)CULoginViewController * loginViewController;



@end

