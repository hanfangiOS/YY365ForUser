//
//  MapMerchantView.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-21.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Clinic;

@protocol MapMerchantViewDelegate <NSObject>

- (void)MapMerchantViewturnToClinicVCWithMerchant:(Clinic *)merchant;

@end

@interface MapMerchantView : UIView{
//    id <MapMerchantViewDelegate> delegate;
}

@property (nonatomic, strong) Clinic *merchant;

- (void)update;

+ (float)defaultWidth;
+ (float)defaultHeight;

@property (nonatomic, retain) id <MapMerchantViewDelegate> delegate;

@end
