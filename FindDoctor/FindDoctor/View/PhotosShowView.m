//
//  PhotosShowView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "PhotosShowView.h"
#import "YYPhotoView.h"


@implementation PhotosShowView{
    NSMutableArray *imageViewArray;
    YYPhotoView *photoView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
}

- (void)setImageURLArray:(NSMutableArray *)imageURLArray{
    _imageURLArray = imageURLArray;
    if (_imageURLArray.count) {
        int intervalX = 5;
        CGFloat freamWidth = (self.frameWidth - (_imageURLArray.count - 1)*intervalX)/_imageURLArray.count;
        
        _imageArray  = [NSMutableArray new];
        imageViewArray   = [NSMutableArray new];
        __weak __block  NSMutableArray *blockImageArray = _imageArray;
        __weak __block  NSMutableArray *_blockImageURLArray = _imageURLArray;
        __weak __block  PhotosShowView *blockSelf = self;
        for (int i = 0; i < _imageURLArray.count; i++ ) {
            UIImageView *imageView = [[UIImageView alloc]init];
            __weak __block UIImageView *blockImageView = imageView;
            imageView.frame = CGRectMake(i*(freamWidth+intervalX), 0, freamWidth, freamWidth);
            imageView.tag = i;
            imageView.clipsToBounds = YES;
            imageView.contentMode = 2;
            imageView.userInteractionEnabled = YES;
            [imageView setImageWithURL:[_imageURLArray objectAtIndex:i] success:^(UIImage *image, BOOL cached) {
                blockImageView.image = image;
                [blockImageArray addObject:image];
                if (blockImageArray.count == _blockImageURLArray.count) {
                    [blockSelf addTap];
                }
            } failure:^(NSError *error) {
                
            }];
            [imageViewArray addObject:imageView];
            [self addSubview:imageView];
        }
        CGRect frame = self.frame;
        frame.size.height = freamWidth;
        self.frame = frame;
        
    }
}

- (void)addTap{
    if (imageViewArray.count) {
        for (int i = 0; i < imageViewArray.count; i++) {
            UIImageView *imageView = [imageViewArray objectAtIndex:i];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(showPhoto:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            tap.view.tag = imageView.tag;
            [imageView addGestureRecognizer:tap];
        }
    }
}

- (void)showPhoto:(UITapGestureRecognizer *)sender{
    NSLog(@"点击图片 showPhoto");
    _photosShowBlock([sender.view tag]);
}
@end
