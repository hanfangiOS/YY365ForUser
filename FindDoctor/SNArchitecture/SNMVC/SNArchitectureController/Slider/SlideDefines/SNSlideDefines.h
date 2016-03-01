//
//  SNSlideDefines.h
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>

#define               kVelocityThreshold 1300.0f
#define                kXOffsetThreshold 50.0f
#define                kTriggerThreshold 0.5f         // dy/dx
#define                    kShadowRaidus 5.0f
#define                   kShadowOpacity 0.2f
#define          kSlideAnimationDuration 0.2f
#define      kSlideNaviAnimationDuration 0.25f
#define         kBounceAnimationDuration 0.1f
#define    kOutOfScreenAnimationDuration 0.1f
#define                  kBounceDistance 10.0f
#define            kAlwaysBounceDistance 50.0f        // MUST <= kXOffsetThreshold
#define   kAlwaysBounceCenterCoefficient (kAlwaysBounceDistance/320.0)
#define     kAlwaysBounceSideCoefficient (kAlwaysBounceDistance/kXOffsetThreshold)
#define               kLeftReservedWidth 64.0f        // 左浮层保留宽度
#define              kRightReservedWidth 88.0f       // 右浮层保留宽度
#define         kPanRecognizeExpandWidth 15.0f
#define             kTransformStartValue 0.98
#define               kTransformEndValue 1.0
#define                 kAlphaStartValue 0.5
#define                   kAlphaEndValue 0.0
#define        kSlideTransformStartValue 0.98

#define     kUseTransformEffect

#define     kDefaultNavigationBarHeight  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?64:44)
#define     kDefaultNavigationDelY       (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?10:0)
#define     kDefaultStatusBarHeight      20
#define     kDefaultToolbarHeight        44

#define kNavigationItemAlignment_HL_VC 10001
#define kNavigationItemAlignment_HR_VC 10002
#define kNavigationItemAlignment_HC_VC 10003

#define kNavigationBarShadowColor      @"0xd3d3d3"

typedef enum
{
    SNSlideStatusCenter = 0,
    SNSlideStatusLeft = 1,
    SNSlideStatusRight = 2,
    
    SNSlideStatusLeftOutOfScreen = 3,
    SNSlideStatusRightOutOfScreen = 4,
} SNSlideStatus;

struct SNSlideAttribute
{
    BOOL slideToLeftEnable;
    BOOL slideToRightEnable;
    
    BOOL alwaysBounceLeft;
    BOOL alwaysBounceRight;   
};
typedef struct SNSlideAttribute SNSlideAttribute;

@class SNViewController;

typedef void(^SNSlideControllerBlock)(const SNViewController *controller);
typedef SNViewController *(^SNSlideTopControllerBlock)(void);
typedef SNSlideAttribute(^SNSlideAttributeBlock)(SNSlideAttribute attr);

typedef void(^SNSlideCompletionBlock)(void);


