//
//  MapMerchantButtonView.h
//  HuiYangChe
//
//  Created by zhouzhenhua on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MapGPSAction)();
typedef void(^MapRouteAction)();

@interface MapMerchantButtonView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) MapGPSAction gpsAction;
@property (nonatomic, copy) MapRouteAction routeAction;

+ (float)defaultHeight;

@end
