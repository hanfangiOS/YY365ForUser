//
//  MiscFiveStarsState.m
//  FindDoctor
//
//  Created by Tom Zhang on 15/8/11.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#import "MiscFiveStarsState.h"

@interface MiscFiveStarsState()

//@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) CGRect frame;

@end

@implementation MiscFiveStarsState

//@synthesize score;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        
        self.center = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        
        _image = [UIImage imageNamed:@"stars"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height*5, frame.size.height)];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frameX+frame.size.height*5, _imageView.frameY, frame.size.width-frame.size.height*5, frame.size.height)];
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_label];
    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _progressView = [[UIProgressView alloc] initWithFrame:frame];
//        [_progressView sizeThatFits:frame.size];
//        _progressView.progressTintColor =[UIColor colorWithRed:1.000 green:0.863 blue:0.000 alpha:1.000];
//        _progressView.trackTintColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000];
//        [self insertSubview:_progressView atIndex:0];
//        UIImage *tmpImage = [UIImage imageNamed:@"MiscStar@2x"];
//        CGFloat starWidth = frame.size.height;
//        CGFloat starHeight = frame.size.height;
//        for (NSInteger i = 0; i < 5; ++i) {
//            UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:tmpImage];
////            UIImageView *tmpImageView = [UIImageView alloc] initWithFrame:
//            tmpImageView.frame = CGRectMake(i*starWidth, 0, starWidth, starHeight);
//            [self addSubview:tmpImageView];
//        }
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame Score:(float)score {
    self = [self initWithFrame:frame];
    if (self) {
        [self setScore:score];
    }
    return self;
}

- (void)setScore:(float)score {
    if (score > 5) {
        score = 5;
    } else if (score < 0) {
        score = 0;
    }
    CGRect cropRect = CGRectMake(0, 0, _image.size.height*score, _image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([_image CGImage], cropRect);
    _imageView.image = [UIImage imageWithCGImage:imageRef];
    _imageView.frame = CGRectMake(_imageView.frameX, _imageView.frameY, _frame.size.height*score, _imageView.frameHeight);
    CGImageRelease(imageRef);
    _label.text = [[NSString alloc] initWithFormat:@"%1.1f星", score];
//    _imageView.frame = CGRectMake(_frame.origin.x+_frame.size.width*0.5 , _frame.origin.y+_frame.size.height*0.5, _frame.size.width * score / 5.0, _frame.size.height);
}

//- (void)setScore:(float)score {
//        _progressView.progress = score/5.0;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
