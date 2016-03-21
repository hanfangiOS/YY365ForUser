//
//  FlagViewInCommentList.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "FlagView.h"
#import "UIImageView+WebCache.h"
#import "TitleView.h"
@interface FlagView(){
    NSMutableArray *imageArray;
    NSMutableArray *imageViewArray;
    NSMutableArray *markViewArray;
    UIImageView    *selectImageView;
    BOOL           mark;
}

@end

@implementation FlagView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        imageArray  = [NSMutableArray new];
        imageViewArray   = [NSMutableArray new];
        markViewArray = [NSMutableArray new];
        selectImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flag_selected"]];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    //    TitleView *zhenduanTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"诊断"];
    //    [self addSubview:zhenduanTitle];
}

- (void)setData:(Doctor *)data{
    if (!mark) {
        _data = data;
        imageArray  = [NSMutableArray new];
        imageViewArray   = [NSMutableArray new];
        if (_data.flagList.count) {
            CGFloat freamWidth;
            if(_data.flagList.count >= 3){
                freamWidth = self.frameWidth*0.6/_data.flagList.count ;
            }
            else{
                freamWidth = 131/2.f ;
            }
            CGFloat intervalWidth = (self.frameWidth-freamWidth*_data.flagList.count) /(_data.flagList.count+1);
            __weak __block  NSMutableArray *blockImageArray = imageArray;
            __weak __block  NSMutableArray *blockFlagArray = _data.flagList;
            __weak __block  FlagView *blockSelf = self;
            for (int i = 0; i < blockFlagArray.count; i++ ) {
                UIImageView *imageView = [[UIImageView alloc]init];
                __weak __block UIImageView *blockImageView = imageView;
                imageView.frame = CGRectMake(intervalWidth + i*(freamWidth+intervalWidth), 20, freamWidth, 199/131.f*freamWidth);
                imageView.tag = i;
                imageView.clipsToBounds = NO;
                imageView.contentMode = 2;
                imageView.userInteractionEnabled = YES;
                FlagListInfo *item = (FlagListInfo *)[blockFlagArray objectAtIndex:i];
                [imageView setImageWithURL:[NSURL URLWithString:item.icon] success:^(UIImage *image, BOOL cached) {
                    blockImageView.image = image;
                    blockImageView.frameHeight = image.size.height/image.size.width*freamWidth;
                    blockImageView.userInteractionEnabled = YES;
                    if (blockSelf.editable) {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer  alloc]initWithTarget:blockSelf action:@selector(tapAction:)];
                        tap.view.tag = blockImageView.tag;
                        tap.numberOfTapsRequired = 1;
                        tap.numberOfTouchesRequired = 1;
                        [blockImageView addGestureRecognizer:tap];
                    }
                    [blockImageArray addObject:image];
                } failure:^(NSError *error) {
                    UIImage *image = [UIImage imageNamed:@"flagMSHC@2x"];
                    blockImageView.image = image;
                    blockImageView.frameHeight = image.size.height/image.size.width*freamWidth;
                    [blockImageArray addObject:image];
                }];
                [imageViewArray addObject:imageView];
                [self addSubview:imageView];
            }
            CGRect frame = self.frame;
            frame.size.height = 199/131.f*freamWidth +20;
            self.frame = frame;
        }
        [self setMianView];
    }
    mark = YES;
}

- (void)setMianView{
    int diameter = 19;
    for (int i = 0 ; i < markViewArray.count; i++ ) {
        UIButton *button = [markViewArray objectAtIndex:i];
        [button removeFromSuperview];
    }
    [markViewArray removeAllObjects];
    if (_data.flagList.count) {
        for (int i = 0; i < imageViewArray.count; i++) {
            UIImageView *imageView = [imageViewArray objectAtIndex:i];
            UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frameWidth - diameter*0.5, -diameter*0.5, diameter, diameter)];
            view.layer.backgroundColor = UIColorFromHex(0xfdbd06).CGColor;
            view.layer.cornerRadius = diameter/2.f;
            [view setTitle:@"免" forState:UIControlStateNormal];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            view.titleLabel.font = [UIFont systemFontOfSize:diameter/2.f];
            [imageView addSubview:view];
            [markViewArray addObject:view];
        }
    }
}

- (void)setMark{
    for (int i = 0 ; i < markViewArray.count; i++ ) {
        UIButton *button = [markViewArray objectAtIndex:i];
        FlagListInfo *item = (FlagListInfo *)[_data.flagList objectAtIndex:i];
        [button setTitle:[NSString stringWithFormat:@"%d",item.num] forState:UIControlStateNormal];
    }
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

//- (void)setEditable:(BOOL)editable
//{
//    self.userInteractionEnabled = editable;
//}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    if (_selectedFlag == nil) {
        UIImageView *imageView = [imageViewArray objectAtIndex:sender.view.tag];
        selectImageView.frame = CGRectMake((imageView.frameWidth-selectImageView.frameWidth)/2, imageView.frameHeight-selectImageView.frameHeight, selectImageView.frameWidth, selectImageView.frameHeight);
        [imageView addSubview:selectImageView];
        _selectedFlag = [_data.flagList objectAtIndex:sender.view.tag];
    }
    else{
        if (_selectedFlag == [_data.flagList objectAtIndex:sender.view.tag]) {
            [selectImageView removeFromSuperview];
            _selectedFlag = nil;
        }
        else {
            [selectImageView removeFromSuperview];
            UIImageView *imageView = [imageViewArray objectAtIndex:sender.view.tag];
            selectImageView.frame = CGRectMake((imageView.frameWidth-selectImageView.frameWidth)/2, imageView.frameHeight-selectImageView.frameHeight, selectImageView.frameWidth, selectImageView.frameHeight);
            [imageView addSubview:selectImageView];
            _selectedFlag = [_data.flagList objectAtIndex:sender.view.tag];
        }
    }
}

@end
