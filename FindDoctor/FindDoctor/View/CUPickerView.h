//
//  CUPickerView.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/9/23.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUPickerViewDelegate;

typedef void(^CUPickerViewAction)(NSInteger index);

@interface CUPickerView : UIView

@property NSInteger selectedIndex;
@property (nonatomic, weak) id<CUPickerViewDelegate> delegate;
@property (nonatomic, copy) CUPickerViewAction confirmBlock;

- (void)update;

- (void)display;
- (void)dismiss;

@end

@protocol CUPickerViewDelegate <NSObject>

- (NSInteger)numberOfRows;
- (NSString *)titleForRowAtIndex:(NSInteger)index;

@end
