//
//  SNSlideController+SNSlideStatus.h
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController.h"

@interface SNSlideController (SNSlideStatus)

- (void)setStatus:(SNSlideStatus)status
    forController:(SNViewController *)controller
         animated:(BOOL)animated
      usingBounce:(BOOL)bounce
     onCompletion:(SNSlideCompletionBlock)completionBlock;

- (void)moveController:(SNViewController *)controller
              toStatus:(SNSlideStatus)status
              animated:(BOOL)animated
           usingBounce:(BOOL)bounce
          onCompletion:(SNSlideCompletionBlock)completionBlock;

- (void)performDelegateForController:(SNViewController *)controller
                          withStatus:(SNSlideStatus)status
                       andLastStatus:(SNSlideStatus)lastStatus;

@end
