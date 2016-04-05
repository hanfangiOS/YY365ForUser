//
//  HomeViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//




#import "HomeViewController.h"

@interface HomeViewController (){
}


@end

@implementation HomeViewController

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    if (self) {
        self.hasNavigationBar = NO;
    }
    return self;
}

- (void)setShouldHaveTab
{
    self.hasTab = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
