//
//  SNTextFieldLimit.h
//  CollegeUnion
//
//  Created by li na on 15/7/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNTextFieldLimit;

@protocol SNTextFieldLimitDelegate<UITextFieldDelegate>

@optional
-(void)textFieldLimit:(SNTextFieldLimit *)textFieldLimit didWentOverLimitWithDisallowedText:(NSString *)text inDisallowedRange:(NSRange)range;
-(void)textFieldLimit:(SNTextFieldLimit *)textFieldLimit didReachLimitWithLastEnteredText:(NSString *)text inRange:(NSRange)range;
@end

@interface SNTextFieldLimit : UITextField<UITextFieldDelegate> {
    long limit;
}
@property (nonatomic, weak) id<SNTextFieldLimitDelegate> limitdelegate;

@property (readwrite, nonatomic) long limit;

@end


