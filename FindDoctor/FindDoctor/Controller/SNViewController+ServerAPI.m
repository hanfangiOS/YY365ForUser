//
//  CUViewController+ServerAPI.m
//  CollegeUnion
//
//  Created by li na on 15/3/30.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNViewController+ServerAPI.h"
#import "AppCore.h"


@implementation SNViewController (ServerAPI)

- (void)closeAction
{
    [[AppCore sharedInstance].apiManager cancelPatchRequestsForPageNameGroup:self.pageName];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
}

- (void)backAction
{
    [self.slideNavigationController popViewControllerAnimated:YES];
    
    //取消本页面所有请求
    [[AppCore sharedInstance].apiManager cancelPatchRequestsForPageNameGroup:self.pageName];
}


@end
