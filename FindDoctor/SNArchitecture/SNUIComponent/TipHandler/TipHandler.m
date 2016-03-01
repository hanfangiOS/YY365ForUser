//
//  TipHandler.m
//  YiRen
//
//  Created by  on 12-7-23.
//  Copyright (c) 2012年. All rights reserved.
//

#import "TipHandler.h"
#import "FXTipView.h"

#pragma mark ============= 网络 =============

#define NetWork_NotReachable            @"哎哟～您的网络有问题,\n请查看网络设置"//数据请求失败的时候.
#define Data_Error                      @"服务异常，请稍后再试"//网络连接没问题,服务器返回的数据有问题.

#define kMarkImageSuccess               @"checkmark_success"
#define kMarkImageFail                  @"checkmark_fail"

@implementation TipHandler

+ (void)showNetWorkFailedOnlyTextWithResponseStatus:(NSInteger)responseStatus
{
    if (responseStatus != 200) 
    {
        [FXTipView showTipViewWithTextByTipView:NetWork_NotReachable];
    }
}

+ (void)showNewWorkNotReachable
{
    [FXTipView showTipViewWithTextByTipView:NetWork_NotReachable];
}

+ (void)showDataErrorWithImage
{
    [FXTipView showTipViewWithTextByTipView:Data_Error andImage:[UIImage imageNamed:@"tip_sad.png"]];
}

+ (void)showDataErrorTextOnly
{
    [FXTipView showTipViewWithTextByTipView:Data_Error];
}

+ (void)showTipOnlyTextWithNsstring:(NSString*) string
{
    if (string) 
    {
        [FXTipView showTipViewWithTextByTipView:string];
    }
}

+ (void)showTipOnlyTextWithNsstring:(NSString*) string andShowTime:(CGFloat)time
{
    if (string)
    {
        [FXTipView showTipViewWithTextByTipView:string andShowTime:time];
    }
}

+ (void)showSmallStringTipWithText:(NSString *)text
{
    if (text)
    {
        [FXTipView showSmallTipViewWithText:text];
    }

}

+ (void)showTipTextWithNsstring:(NSString*)string state:(TipState)state
{
    UIImage *image = [UIImage imageNamed:(state == TipStateSuccess ? kMarkImageSuccess : kMarkImageFail)];
    if (string && image) {
        [FXTipView showTipViewWithTextByTipView:string andImage:image];
    }
}

@end
