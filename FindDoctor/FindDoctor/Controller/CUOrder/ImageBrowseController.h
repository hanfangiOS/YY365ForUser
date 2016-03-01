//
//  ImageBrowseController.h
//  CommentTest
//
//  Created by zhouzhenhua on 14-9-7.
//  Copyright (c) 2014年 zhouzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNViewController.h"

@protocol ImageBrowseControllerDelegate;

@interface ImageBrowseController : SNViewController

@property (nonatomic, weak) id<ImageBrowseControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic) int startIndex;

@end

@protocol ImageBrowseControllerDelegate <NSObject>

- (void)didClickToDeleteImageAtIndex:(int)index;

@end
