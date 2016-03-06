//
//  PhotosShowView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
typedef void(^PhotosShowBlock)(NSInteger index);

@interface PhotosShowView : UIView <SDWebImageManagerDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSArray * imageURLArray;
@property (nonatomic, strong) NSMutableArray * imageArray;

@property (nonatomic, copy) PhotosShowBlock photosShowBlock;

@end
