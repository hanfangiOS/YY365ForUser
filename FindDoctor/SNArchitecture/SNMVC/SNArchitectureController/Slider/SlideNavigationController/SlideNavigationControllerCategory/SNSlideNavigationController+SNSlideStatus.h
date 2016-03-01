//
//  SNSlideNavigationController+SNSlideStatus.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideNavigationController.h"

@interface SNSlideNavigationController (SNSlideStatus)

- (void)setStatus:(SNSlideStatus)status
    forController:(UIViewController *)controller
         animated:(BOOL)animated
      usingBounce:(BOOL)bounce
     onCompletion:(SNSlideCompletionBlock)completionBlock;

- (void)moveController:(UIViewController *)controller
              toStatus:(SNSlideStatus)status
              animated:(BOOL)animated
           usingBounce:(BOOL)bounce
          onCompletion:(SNSlideCompletionBlock)completionBlock;

@end
