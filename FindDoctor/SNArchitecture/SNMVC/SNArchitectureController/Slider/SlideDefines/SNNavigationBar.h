//
//  SNNavigationBar.h
//  TestNavigation
//
//  Created by nova  on 12-12-28.
//  Copyright (c) 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNavigationBar : UINavigationBar
{
    CGRect touchBounds;
    
    UIImageView    *_shadowImageView;
}

- (void)setCustomShadowImage:(UIImage *)shadowImage;

@end
