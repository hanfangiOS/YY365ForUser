//
//  MyDiagnosisRecordsDetailViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "MyDiagnosisRecordsDetailViewController.h"
#import "YYZhenDanLineView.h"
#import "NSDate+SNExtension.h"
#import "UIImageView+WebCache.h"
#import "YYPhotoView.h"

@interface MyDiagnosisRecordsDetailViewController (){
    YYZhenDanLineView *view0;
    YYZhenDanLineView *view1;
    YYZhenDanLineView *view2;
    YYZhenDanLineView *view3;
    YYZhenDanLineView *view4;
    YYZhenDanLineView *view5;
    YYZhenDanLineView *view6;
    YYZhenDanLineView *view7;
    YYZhenDanLineView *view8;
    YYZhenDanLineView *view9;
    YYZhenDanLineView *view10;
    YYZhenDanLineView *view11;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MyDiagnosisRecordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
//    self.title = [NSString stringWithFormat:@"%@ 就诊单",_data.UserName];


    [self loadContentScrollView];
    [self loadContent];

}

-(void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height)];
    _contentScrollView.scrollEnabled = YES;
    [self.contentView addSubview:_contentScrollView];
//    _contentScrollView.backgroundColor = [UIColor blackColor];
}

- (void)loadContent{
    int paadingLeft = 15;
    view0 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 10, kScreenWidth - paadingLeft*2, 0)];
    [view0 setTitle:@"单        号:"];
    [view0 setContentText:[NSString stringWithFormat:@"%lld",_data.diagnosisID]];
    view0.frame = CGRectMake([view0 frameX], [view0 frameY], kScreenWidth - paadingLeft*2, [view0 getframeHeight]);
    
    view1 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view1 setTitle:@"约  诊  人:"];
    [view1 setContentText:[NSString stringWithFormat:@"%@,%@,%ld岁\n手机号%@",_data.service.patience.name,(_data.service.patience.gender == 0 ? @"女":@"男"),_data.service.patience.age,_data.service.patience.cellPhone]];
    view1.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view0.frame), kScreenWidth - paadingLeft*2, [view1 getframeHeight]);
    
    view2 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view2 setTitle:@"下单时间:"];
    [view2 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    view2.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view1.frame), kScreenWidth - paadingLeft*2, [view2 getframeHeight]);
    
    view3 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view3 setTitle:@"预约医生:"];
    [view3 setContentText:[NSString stringWithFormat:@"%@ %@",_data.service.doctor.name,_data.service.doctor.levelDesc]];
    view3.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view2.frame), kScreenWidth - paadingLeft*2, [view3 getframeHeight]);
    
    view4 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view4 setTitle:@"诊       金:"];
    [view4 setContentText:[NSString stringWithFormat:@"￥%.2lf",_data.dealPrice/100.f]];
    view4.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view3.frame), kScreenWidth - paadingLeft*2, [view4 getframeHeight]);
    
    
    view5 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view5 setTitle:@"预  约  号:"];
    [view5 setContentText:[NSString stringWithFormat:@"第  %@  号",_data.orderNumber]];
    view5.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view4.frame), kScreenWidth - paadingLeft*2, [view5 getframeHeight]);
    

    view6 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view6 setTitle:@"就诊时间:"];
    [view6 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.createTimeStamp] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    view6.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view5.frame), kScreenWidth - paadingLeft*2, [view5 getframeHeight]);

    view7 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view7 setTitle:@"就诊地点:"];
    [view7 setContentText:[NSString stringWithFormat:@"%@",_data.service.doctor.address]];
    view7.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view6.frame), kScreenWidth - paadingLeft*2, [view6 getframeHeight]);
    
    view8 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view8 setTitle:@"病症描述:"];
    [view8 setContentText:[NSString stringWithFormat:@"%@",_data.service.disease.desc]];
    if ([_data.service.disease.desc isEmpty]) {
        [view8 setContentText:@"暂无"];
    }
    view8.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view7.frame), kScreenWidth - paadingLeft*2, [view7 getframeHeight]);
    
    if (_data.state == 1 || _data.state == 2 || _data.state == 3) { //状态1下单未支付，2下单支付，3开方未提交，4开方提交
        
    }
    if (_data.state == 4) {
        
    }
//
//    view9 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//    [view9 setTitle:@"诊断信息:"];
//    [view9 setContentText:_data.diagnosisContent];
//    view9.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view8.frame), kScreenWidth - paadingLeft*2, [view8 getframeHeight]);
//    
//    
//    
//    if (![_data.recipePic isEmpty]) {
//        view10 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//        [view10 setTitle:@"药       方:"];
//        [view10 setContentText:[NSString stringWithFormat:@""]];
//        view10.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view9.frame), kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
//        
//        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view10.frameX + 100,view10.frameY + 8 , view10.frameWidth - 100, view10.frameWidth - 100)];
//        _imageView.userInteractionEnabled = YES;
//        __weak __block MyDiagnosisRecordsDetailViewController * blockSelf = self;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(YYPhotoViewAction)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [_imageView addGestureRecognizer:tap];
//        
//        [_imageView setImageWithURL:[NSURL URLWithString:_data.recipePic] placeholderImage:nil success:^(UIImage *image, BOOL cached) {
//
//        } failure:^(NSError *error) {
//            
//        }];
//        _imageView.contentMode = 0;
//        _imageView.clipsToBounds = YES;
//        [_contentScrollView addSubview:_imageView];
//        
//        view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//        [view11 setTitle:@"付       数:"];
//        [view11 setContentText:[NSString stringWithFormat:@"%ld",_data.recipeNum]];
//        view11.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view10.frame)+ _imageView.frameHeight, kScreenWidth - paadingLeft*2, [view11 getframeHeight]);
//        [self.contentScrollView addSubview:view11];
//        
//        _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view11.frame));
//    }
//    else{
//        view10 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//        [view10 setTitle:@"药       方:"];
//        NSString *string = [[NSString alloc]init];
//        for (int i = 0 ; i < _data.recipeData.count; i++) {
//            CUHerbSelect *herb = [_data.recipeData objectAtIndex:i];
//            if (i) {
//                if(i%2 == 1){
//                    string = [string stringByAppendingFormat:@"      %@ %D %@",[herb name],[herb weight],[herb unit]];
//                }
//                else{
//                    string = [string stringByAppendingFormat:@"\n%@ %D %@",[herb name],[herb weight],[herb unit]];
//                }
//            }
//            else{
//                string = [string stringByAppendingFormat:@"%@ %D %@",[herb name],[herb weight],[herb unit]];
//            }
//
//        }
//        [view10 setContentText:string];
//        view10.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view9.frame), kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
//        
//        view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//        [view11 setTitle:@"付       数:"];
//        [view11 setContentText:[NSString stringWithFormat:@"%ld",_data.recipeNum]];
//        view11.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view10.frame), kScreenWidth - paadingLeft*2, [view11 getframeHeight]);
//        
//        [self.contentScrollView addSubview:view11];
//        
//        _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view11.frame));
//    }

    

    NSLog(@"%@",_contentScrollView);
    
    [self.contentScrollView addSubview:view0];
    [self.contentScrollView addSubview:view1];
    [self.contentScrollView addSubview:view2];
    [self.contentScrollView addSubview:view3];
    [self.contentScrollView addSubview:view4];
    [self.contentScrollView addSubview:view5];
    [self.contentScrollView addSubview:view6];
    [self.contentScrollView addSubview:view7];
    [self.contentScrollView addSubview:view8];
    [self.contentScrollView addSubview:view9];
    [self.contentScrollView addSubview:view10];
}

- (void)YYPhotoViewAction{
//    YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:[NSMutableArray arrayWithObject:_imageView.image] numberOfClickedPhoto:0];
//    [[self.view superview] addSubview:view];
}

- (void)setData:(CUService *)data{
    _data = data;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

@end
