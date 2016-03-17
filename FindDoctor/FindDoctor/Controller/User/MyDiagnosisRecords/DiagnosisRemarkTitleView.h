//
//  DiagnosisRemarkTitleView.h
//  uyi365ForPatient
//
//  Created by ZhuHaoRan on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TitleViewDefaultStyle = 0,
    TitleViewStyle1 = 1,
    TitleViewStyle2 = 2,
    TitleViewStyle3 = 3,
    TitleViewStyle4 = 4,
}TitleViewStyle;

@interface DiagnosisRemarkTitleView : UIView

@property (strong,nonatomic) NSString           * title;//标题
@property (strong,nonatomic) UIColor            * titleColor;//标题颜色
@property (strong,nonatomic) UIFont             * titleFont;//标题字体
@property (strong,nonatomic) UIColor            * leftLineColor;//左线颜色
@property (strong,nonatomic) UIColor            * rightLineColor;//右线颜色
@property (assign,nonatomic) CGFloat            leftPadding;//左间距
@property (assign,nonatomic) CGFloat            rightPadding;//右间距
@property (assign,nonatomic) CGFloat            PaddingInLeftLineAndTitle;//标题与左线间距
@property (assign,nonatomic) CGFloat            PaddingInRightLineAndTitle;//标题于右线间距
@property (assign,nonatomic) TitleViewStyle     style;//目前只有TitleViewDefaultStyle

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Style:(TitleViewStyle)style;

@end
