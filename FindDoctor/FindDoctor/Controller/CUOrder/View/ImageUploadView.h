//
//  ImageUploadView.h
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageUploadViewDelegate;

@interface ImageUploadView : UIView

@property (nonatomic, weak) id<ImageUploadViewDelegate> delegate;

+ (float)defaultHeight;

- (void)reloadWithImages:(NSArray *)images;

@end

@protocol ImageUploadViewDelegate <NSObject>

- (void)didClickToAddImage;
- (void)didClickToBrowseImageAtIndex:(int)index;

@end
