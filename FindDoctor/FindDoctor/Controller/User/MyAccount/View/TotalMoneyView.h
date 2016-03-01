//
//  TotalMoneyView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalMoneyView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color;
- (void)show;
@property (nonatomic, strong) NSString *fee;

@end
