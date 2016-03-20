//
//  FlagViewInCommentList.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "FlagViewInCommentList.h"
#import "UIImageView+WebCache.h"
#import "TitleView.h"
@interface FlagViewInCommentList(){
    NSMutableArray *flagArray;
    NSMutableArray *imageArray;
    NSMutableArray *imageViewArray;
}

@end

@implementation FlagViewInCommentList

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
//    TitleView *zhenduanTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"诊断"];
//    [self addSubview:zhenduanTitle];
}

//- (void)setData:(Comment *)data{
//    _data = data;
//    if (_data.flagList.count) {
//        CGFloat freamWidth = self.frameWidth*0.6/_data.flagList.count ;
//        CGFloat intervalWidth = self.frameWidth*0.4/(_data.flagList.count+1);
//        imageArray  = [NSMutableArray new];
//        imageViewArray   = [NSMutableArray new];
//        __weak __block  NSMutableArray *blockImageArray = imageArray;
//        __weak __block  NSMutableArray *blockFlagArray = _data.flagList;
//        for (int i = 0; i < blockFlagArray.count; i++ ) {
//            UIImageView *imageView = [[UIImageView alloc]init];
//            __weak __block UIImageView *blockImageView = imageView;
//            imageView.frame = CGRectMake(intervalWidth + i*(freamWidth+intervalWidth), 0, freamWidth, freamWidth);
//            imageView.tag = i;
//            imageView.clipsToBounds = YES;
//            imageView.contentMode = 2;
//            imageView.userInteractionEnabled = YES;
//            FlagListInfo *item = (FlagListInfo *)[blockFlagArray objectAtIndex:i];
//            [imageView setImageWithURL:[NSURL URLWithString:item.icon] success:^(UIImage *image, BOOL cached) {
//                blockImageView.image = image;
//                blockImageView.frameHeight = image.size.height/image.size.width*freamWidth;
//                [blockImageArray addObject:image];
//            } failure:^(NSError *error) {
//                
//            }];
//            [imageViewArray addObject:imageView];
//            [self addSubview:imageView];
//        }
//        CGRect frame = self.frame;
//        frame.size.height = freamWidth;
//        self.frame = frame;
//    }
//    [self setMark];
//}

- (void)setMark{
//    int diameter = 10;
//    if (_data.flagList.count) {
//        for (int i = 0; i < imageViewArray.count; i++) {
//            UIImageView *imageView = [imageViewArray objectAtIndex:i];
//            
//            UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frameWidth - diameter*0.5, -diameter*0.5, diameter, diameter)];
//            view.layer.backgroundColor = UIColorFromHex(0xfdbd06).CGColor;
//            view.layer.cornerRadius = diameter/2.f;
//            [view setTitle:@"免" forState:UIControlStateNormal];
//            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////            view.titleLabel.font = [UIFont systemFontOfSize:12];
//            [imageView addSubview:view];
//        }
//    }
}

@end
