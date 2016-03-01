//
//  PhoneHelper.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-11-3.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "SNPhoneHelper.h"
#import <UIKit/UIKit.h>

static UIWebView *phoneWebView = nil;

@implementation SNPhoneHelper

+ (void)call:(NSString *)phone
{
    if (phone.length == 0) {
        return;
    }
    
    if (phoneWebView == nil) {
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    NSString *urlPhoneNumber = [NSString stringWithFormat:@"tel://%@", phone];
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPhoneNumber]]];
}

+ (void)sms:(NSString *)phone
{
    if (phone.length == 0) {
        return;
    }
    
    if (phoneWebView == nil) {
        phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    NSString *urlPhoneNumber = [NSString stringWithFormat:@"sms://%@", phone];
    [phoneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPhoneNumber]]];
}

@end
