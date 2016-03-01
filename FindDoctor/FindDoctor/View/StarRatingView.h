//
//  StarRatingView.h
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//
//

#import <UIKit/UIKit.h>

#define kImageCount     5

#define kImageSpace_B         4.0

#define kImageWidth_B         20.0
#define kImageHeight_B        20.0

#define kStarImageBlank_B     @"praise_grade_normal"
#define kStarImageFull_B      @"praise_grade_highlighted"
#define kStarImageHalf_B      @"comment_star_yellow_half_big"

#define kImageSpace_S         3.0

#define kImageWidth_S         12.0
#define kImageHeight_S        12.0

#define kStarImageBlank_S     @"comment_star_gray"
#define kStarImageFull_S      @"comment_star_yellow"
#define kStarImageHalf_S      @"comment_star_yellow_half"

typedef enum : NSUInteger {
    StarTypeSmall,
    StarTypeLarge,
} StarType;

@class StarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate;

@end

@interface StarRatingView : UIView

- (id)initWithFrame:(CGRect)frame type:(StarType)type;

- (id)initWithFrame:(CGRect)frame type:(StarType)type starSpace:(CGFloat)space;

+ (float)defaultWidth;

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@property (nonatomic) float rate;
@property (nonatomic) BOOL editable;            // default is YES

@end
