//
//  SNSlideNavigationControllerPan.h
//  YiRen
//
//  Created by frost on 14-3-28.
//  Copyright (c) 2014年. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNSlideNavigationControllerPan <NSObject>

@optional
- (void)willPanToSlideNavigationController;
- (void)cancelPanToSlideNavigationController;

@end
