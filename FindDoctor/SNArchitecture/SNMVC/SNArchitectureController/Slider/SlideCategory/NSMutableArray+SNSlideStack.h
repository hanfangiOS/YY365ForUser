//
//  NSMutableArray+SNSlideStack.h
//  SNSlideController
//
//  Created by Nova on 13-4-2.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableArray (SNSlideStack)

- (BOOL)canPushController:(UIViewController *)controller;
- (BOOL)pushController:(UIViewController *)controller;

- (BOOL)popController:(UIViewController *)controller;
- (NSArray *)popAllController;

// Only keep controllers(index less than param index) in stack.
- (NSArray *)popControllersToIndex:(NSInteger)index;

- (UIViewController *)previousControllerInStack;
- (UIViewController *)currentControllerInStack;
- (UIViewController *)belowControllerInStack;

- (void)replaceController:(UIViewController *)oldController
           withController:(UIViewController *)newController;

@end
