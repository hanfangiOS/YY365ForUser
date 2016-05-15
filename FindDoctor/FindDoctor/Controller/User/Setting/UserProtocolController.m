//
//  UserProtocolController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/26.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "UserProtocolController.h"

@interface UserProtocolController ()<UIWebViewDelegate>

@property (strong,nonatomic)UIWebView       * webView;

@end

@implementation UserProtocolController

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户协议";
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSURL* url = [NSURL URLWithString:@"http://123.56.251.146:8080/screen/license.html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)initSubViews{
    self.webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.contentView addSubview:self.webView];
}

-(void)webViewDidStartLoad:(UIWebView*)webView{
    [self showProgressView];
}


-(void)webViewDidFinishLoad:(UIWebView*)webView{

    [self hideProgressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
