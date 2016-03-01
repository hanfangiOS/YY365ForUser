//
//  SNWebController.m
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-10-14.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "CUWebController.h"
//#import "RetryView.h"

@interface CUWebController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CUWebController
{
//    RetryView         *_retryView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    self.webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    self.webView.delegate = (id)self;
    [self.contentView addSubview:self.webView];
    
    [self showProgressView];
    [self loadRequest];
}

- (void)loadRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideProgressView];
    
    [self showRetryView];
}



- (void)showRetryView
{
//    if (_retryView == nil) {
//        _retryView = [[RetryView alloc] initWithFrame:self.view.bounds];
//        _retryView.delegate = (id)self;
//        _retryView.hidden = YES;
//        [self.view insertSubview:_retryView belowSubview:_hud ? _hud : self.navigationBar];
//    }
//    
//    _retryView.hidden = NO;
}

- (void)hideRetryView
{
//    _retryView.hidden = YES;
}

//- (void)didClickToRetry:(RetryView *)retryView
//{
//    [self hideRetryView];
//    
//    [self showHUD];
//    [self loadRequest];
//}

@end
