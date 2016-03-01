//
//  SNSlideController.h
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSlideDefines.h"
#import "SNViewController.h"

@interface SNSlideController : SNViewController <UIGestureRecognizerDelegate>
{
    SNViewController *_topController;
    SNViewController *_leftController;
    SNViewController *_rightController;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    BOOL _tapValid;
    BOOL _panValid;
    BOOL _layouting;
    
    SNSlideStatus _topControllerStatus;
    SNSlideStatus _lastControllerStatus;
    
    NSMutableDictionary *_attributesDict;
    NSMutableDictionary *_observerDict;
    NSMutableArray      *_controllerStack;
    
    SNViewController *_currentController;
    SNViewController *_selectedController;
}

@property (nonatomic, retain) SNViewController *topController;
@property (nonatomic, retain) SNViewController *leftController;
@property (nonatomic, retain) SNViewController *rightController;

@property (nonatomic, readonly, retain) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, readonly, retain) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign, getter = isTapValid)  BOOL tapValid;
@property (nonatomic, assign, getter = isPanValid)  BOOL panValid;
@property (nonatomic, assign, getter = isLayouting) BOOL layouting;

@property (nonatomic, assign) SNSlideStatus topControllerStatus;
@property (nonatomic, assign) SNSlideStatus lastControllerStatus;

@property (nonatomic, retain) NSMutableDictionary *attributesDict;
@property (nonatomic, retain) NSMutableDictionary *observerDict;
@property (nonatomic, retain) NSMutableArray      *controllerStack;

@property (nonatomic, assign) SNViewController *currentController;
@property (nonatomic, retain) SNViewController *selectedController;

- (id)initWithTopController:(SNViewController *)topController;

- (id)initWithTopController:(SNViewController *)topController leftController:(SNViewController *)leftController;

- (id)initWithTopController:(SNViewController *)topController rightController:(SNViewController *)rightController;

- (id)initWithTopController:(SNViewController *)topController
             leftController:(SNViewController *)leftController
            rightController:(SNViewController *)rightController;

- (void)setSlideControllerForController:(SNViewController *)controller;
- (void)setSlideNavigationController:(SNSlideNavigationController *)naviController forController:(SNViewController *)controller;

// Slide currentController to left.
- (void)slideToLeftAnimated:(BOOL)animated;
- (void)slideToLeft:(SNSlideControllerBlock)belowControllerBlock
          attribute:(SNSlideAttributeBlock)attributeBlock
           animated:(BOOL)animated;

// Slide currentController to right.
- (void)slideToRightAnimated:(BOOL)animated;
- (void)slideToRight:(SNSlideControllerBlock)belowControllerBlock
           attribute:(SNSlideAttributeBlock)attributeBlock
            animated:(BOOL)animated;

// Slide previousController back to kStatusCenter.
- (void)slidePreviousBackAnimated:(BOOL)animated;
- (void)slidePreviousBack:(SNSlideControllerBlock)prevControllerBlock
                attribute:(SNSlideAttributeBlock)attributeBlock
                 animated:(BOOL)animated;

// Slide topController to kStatusCenter, all controllers will be reset.
- (void)slideToTopAnimated:(BOOL)animated;
- (void)slideToTop:(SNSlideControllerBlock)topControllerBlock
         attribute:(SNSlideAttributeBlock)attributeBlock
          animated:(BOOL)animated;

// Change topController.
- (void)changeTopWith:(SNSlideTopControllerBlock)controllerBlock
            attribute:(SNSlideAttributeBlock)attributeBlock
             animated:(BOOL)animated;

// CurrentController wants Full screen display
- (void)setCurrentWantsFullScreenLayout:(BOOL)fullScreenLayout;

@end
