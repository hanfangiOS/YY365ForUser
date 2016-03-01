//
//  CUViewController.m
//  CollegeUnion
//
//  Created by li na on 15/3/4.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUUIContant.h"
#import "SNNavigationBar.h"
#import "UIView+Extension.h"
#import "UIImage+Color.h"

@interface CUViewController ()

@property (nonatomic,strong) UIView * content;
@property (nonatomic,assign,readwrite)CGFloat keybordHeight;


@end

@implementation CUViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keybordHeight = 220;
    self.view.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
    
    [self setShouldHaveTab];
    
    // --------------------如果有nav则重新生成一个可视的view,跟loadContentView的顺序不可以改
    [self addContentView];
    // --------------------子类执行以下方法
    self.navigationBar.shadowImage = [UIImage createImageWithColor:UIColorFromHex( Color_Hex_NavShadow)];
    [self loadNavigationBar];
    [self loadContentView];
}

- (void)removeContentView
{
    [self.content removeFromSuperview];
    self.content = nil;
}

- (void)setShouldHaveTab
{
}

- (void)addContentView
{
//    CGRect contentFrame = (self.navigationBar.hidden == YES)?CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.toolbarHeight):[self subviewFrame];
    self.content = [[UIView alloc] initWithFrame:[self subviewFrame]];
    [self.view addSubview:self.content];
    self.content.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);
    if (self.hasTab)
    {
        self.content.frameHeight -= Height_Tabbar;
    }
}

- (UIView *)contentView
{
    if (self.content != nil)
    {
        return self.content;
    }
    return self.view;
}

- (void)loadNavigationBar
{
    
}
- (void)loadContentView
{
    
}

@end


@implementation CUViewController (HUD)

//- (void)showSMS:(NSString*)message cellPhone:(NSString *)cellPhone
//{
//    
//    if(![MFMessageComposeViewController canSendText])
//    {
//        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [warningAlert show];
//        return;
//    }
//    
//
//    NSArray *recipents = @[cellPhone];
//   
//    
//    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
//    messageController.messageComposeDelegate = self;
//    [messageController setRecipients:recipents];
//    [messageController setBody:message];
//    
//    // Present message view controller on screen
//    [self presentViewController:messageController animated:YES completion:nil];
//    
//    
//}
//
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
//                 didFinishWithResult:(MessageComposeResult)result {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)showProgressView
{
    if (self.progressView == nil) {
        self.progressView = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        self.progressView.center = CGPointMake(CGRectGetWidth(self.contentView.bounds)/2.0, CGRectGetHeight(self.contentView.bounds)/2.0);
        [self.view addSubview:self.progressView];
        self.progressView.dimBackground = NO;
    }
    
    [self.view bringSubviewToFront:self.progressView];
    [self.progressView show:YES];
    self.contentView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
}

- (void)hideProgressView
{
    [self.progressView hide:NO];
    self.contentView.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}


@end


@implementation CUViewController (keybord)



-(void)setViewMovedUp:(CGFloat)movedUpOffSet
{
    CGRect rect = self.contentView.frame;
    if (rect.origin.y < 0)
    {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
   
    rect.origin.y -= movedUpOffSet;
    rect.size.height += movedUpOffSet;
    self.contentView.frame = rect;
    [UIView commitAnimations];
}


-(void)setViewMovedDown:(CGFloat)movedUpOffSet
{
    CGRect rect = self.contentView.frame;
    if (rect.origin.y > 0)
    {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    
    
    rect.origin.y += movedUpOffSet;
    rect.size.height -= movedUpOffSet;
    self.contentView.frame = rect;
    [UIView commitAnimations];
}


@end

