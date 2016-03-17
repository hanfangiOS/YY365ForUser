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

@property (strong,nonatomic) NSString           * title;
@property (strong,nonatomic) UIColor            * titleColor;
@property (strong,nonatomic) UIFont             * titleFont;
@property (assign,nonatomic) CGFloat            leftPadding;
@property (assign,nonatomic) CGFloat            rightPadding;
@property (assign,nonatomic) CGFloat            PaddingInLeftLineAndTitle;
@property (assign,nonatomic) CGFloat            PaddingInRightLineAndTitle;
@property (assign,nonatomic) TitleViewStyle     style;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title Style:(TitleViewStyle)style;

@end
