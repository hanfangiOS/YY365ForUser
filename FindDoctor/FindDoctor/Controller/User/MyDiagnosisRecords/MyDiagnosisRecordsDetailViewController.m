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
#import "CUOrderManager.h"
#import "OrderResultButtonView.h"
#import "OrderConfirmController.h"
#import "PhotosShowView.h"

#import "DiagnosisRemarkController.h"
#import "Comment.h"
#import "CUCommentManager.h"

#define commitViewHeight 50

@interface MyDiagnosisRecordsDetailViewController ()<UIAlertViewDelegate>{
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
    YYZhenDanLineView *view12;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MyDiagnosisRecordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
    self.title = [NSString stringWithFormat:@"订单详情"];


    [self loadContentScrollView];
    [self loadContent];

//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(50,50, 50, 50)];
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(temp) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}

//- (void)temp{
//    [self postRequestComment];
//
//}

//11901点评按钮接口
- (void)postRequestComment{
    CommentFilter * filter = [[CommentFilter alloc] init];
    filter.order = self.data;
    [[CUCommentManager sharedInstance] getDiagnosisComment:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            NSInteger errorCode = [[result.responseObject valueForKey:@"errorCode"] integerValue];
            if(errorCode == 0){
                DiagnosisRemarkController * vc = [[DiagnosisRemarkController alloc] init];
                vc.order = result.parsedModelObject;
                vc.order.diagnosisID = self.data.diagnosisID;
                [self.slideNavigationController pushViewController:vc animated:YES];
            }
        }
    } pageName:@"DiagnosisRemarkController"];
    
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
    [view2 setContentText:_data.submitTimeString];
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
    [view6 setContentText:_data.diagnosisTime];
    view6.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view5.frame), kScreenWidth - paadingLeft*2, [view6 getframeHeight]);

    view7 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view7 setTitle:@"就诊地点:"];
    [view7 setContentText:[NSString stringWithFormat:@"%@",_data.service.doctor.address]];
    view7.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view6.frame), kScreenWidth - paadingLeft*2, [view7 getframeHeight]);
    
    view8 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view8 setTitle:@"病症描述:"];
    [view8 setContentText:[NSString stringWithFormat:@"%@",_data.service.disease.desc]];
    if ([_data.service.disease.desc isEmpty]) {
        [view8 setContentText:@"暂无"];
    }
    view8.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view7.frame), kScreenWidth - paadingLeft*2, [view8 getframeHeight]);
    
    view9 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view9 setTitle:@"病症图片:"];
    [view9 setContentText:@"暂无"];
    view9.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view8.frame), kScreenWidth - paadingLeft*2, [view9 getframeHeight]);
    if (_data.service.disease.imageURLArray.count){
        [view9 setContentText:@""];
        PhotosShowView *photosShowView = [[PhotosShowView alloc]initWithFrame:CGRectMake(paadingLeft, CGRectGetMaxY(view9.frame), kScreenWidth - paadingLeft*2, 0)];
        __weak __block PhotosShowView *blockPhotosShowView = photosShowView;
        photosShowView.imageURLArray = _data.service.disease.imageURLArray;
        photosShowView.photosShowBlock = ^(NSInteger inex){
            YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:blockPhotosShowView.imageArray numberOfClickedPhoto:inex];
            [[self.view superview] addSubview:view];
        };
        [_contentScrollView  addSubview:photosShowView];
        NSString *str = [_data.service.disease.imageURLArray objectAtIndex:0];
        if ([str isEmpty]) {
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + 10);
        }
        else{
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + photosShowView.frameHeight + 10);
        }

    }
    else{
        _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + 10);
    }

    
    
    if (_data.state == 4 || _data.state == 5) {  // 诊疗完成待评价或者已经评价都要显示完整信息
        view10 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
        [view10 setTitle:@"诊断信息:"];
        [view10 setContentText:@"暂无"];
        view10.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10, kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
        if(![_data.service.diagnosis.diagnosisText isEmpty]){
            [view10 setContentText:_data.service.diagnosis.diagnosisText];
            view10.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10, kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
        }

        
        if (![_data.service.diagnosis.herbPic isEmpty]) {
            view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view11 setTitle:@"药       方:"];
            [view11 setContentText:[NSString stringWithFormat:@"图片"]];
            view11.frame = CGRectMake(paadingLeft,CGRectGetMaxY(view10.frame), kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
            [view11 setContentText:[NSString stringWithFormat:@""]];

            PhotosShowView *photosShowView = [[PhotosShowView alloc]initWithFrame:CGRectMake(paadingLeft, CGRectGetMaxY(view11.frame), kScreenWidth - paadingLeft*2, 0)];
            __weak __block PhotosShowView *blockPhotosShowView = photosShowView;
            photosShowView.imageURLArray = [NSArray arrayWithObject:[NSURL URLWithString:_data.service.diagnosis.herbPic]];
            photosShowView.photosShowBlock = ^(NSInteger inex){
                YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:blockPhotosShowView.imageArray numberOfClickedPhoto:inex];
                [[self.view superview] addSubview:view];
            };
            [_contentScrollView  addSubview:photosShowView];
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view11.frame) + photosShowView.frameHeight + 10);
            
            view12 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view12 setTitle:@"付       数:"];
            [view12 setContentText:[NSString stringWithFormat:@"%ld",_data.service.diagnosis.recipeNum]];
            view12.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10 , kScreenWidth - paadingLeft*2, [view12 getframeHeight]);
            [self.contentScrollView addSubview:view12];
            
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view12.frame)+10);
        }
        else{
            view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view11 setTitle:@"药       方:"];
            NSString *string = [[NSString alloc]init];
            for (int i = 0 ; i < _data.service.diagnosis.herbArray.count; i++) {
                CUHerb *herb = [_data.service.diagnosis.herbArray objectAtIndex:i];
                if (i) {
                    if(i%2 == 1){
                        string = [string stringByAppendingFormat:@"      %@ %D %@",[herb name],[herb weight],[herb unit]];
                    }
                    else{
                        string = [string stringByAppendingFormat:@"\n%@ %D %@",[herb name],[herb weight],[herb unit]];
                    }
                }
                else{
                    string = [string stringByAppendingFormat:@"%@ %D %@",[herb name],[herb weight],[herb unit]];
                }
                
            }
            [view11 setContentText:string];
            view11.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view10.frame), kScreenWidth - paadingLeft*2, [view11 getframeHeight]);
            
            view12 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view12 setTitle:@"付       数:"];
            [view12 setContentText:[NSString stringWithFormat:@"%ld",_data.service.diagnosis.recipeNum]];
            view12.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view11.frame), kScreenWidth - paadingLeft*2, [view12 getframeHeight]);
            
            [self.contentScrollView addSubview:view12];
            
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view12.frame) + 10);
        }

    }

    if (_data.state == 1){
        self.contentScrollView.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height - [OrderResultButtonView defaultHeight]);
        
        OrderResultButtonView *buttonView = [[OrderResultButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - [OrderResultButtonView defaultHeight], kScreenWidth, [OrderResultButtonView defaultHeight])];
        [self.contentView addSubview:buttonView];
        [buttonView.leftButton setTitle:@"去支付" forState:UIControlStateNormal];
        [buttonView.rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        buttonView.leftAction = ^{
            [weakSelf payAction];
        };
        
        buttonView.rightAction = ^{
            [weakSelf cancelAction];
        };
    }
    
    if (_data.state == 4){
        
        self.contentScrollView.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height - [OrderResultButtonView defaultHeight]);
        
        UIView *commitView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentScrollView.frame), kScreenWidth, [OrderResultButtonView defaultHeight])];
        commitView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:commitView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.layer.backgroundColor = UIColorFromHex(0xc4c4c4).CGColor;
        [commitView addSubview:lineView];
        
        int commitButtonHeight = 35;
        UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (commitViewHeight - commitButtonHeight)/2, kScreenWidth - 30, commitButtonHeight)];
        commitButton.layer.cornerRadius = commitButtonHeight/2.f;
        [commitButton setTitle:@"评      价" forState:UIControlStateNormal];
        [commitButton addTarget:self action:@selector(postRequestComment) forControlEvents:UIControlEventTouchUpInside];
        commitButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
        
        [commitView addSubview:commitButton];
    }
    

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
    [self.contentScrollView addSubview:view11];
    [self.contentScrollView addSubview:view12];
}

- (void)payAction{
    OrderConfirmController *detailVC = [[OrderConfirmController alloc]initWithPageName:@"MyDiagnosisRecordsDetailViewController"];
    detailVC.order = self.data;
    [self.slideNavigationController pushViewController:detailVC animated:YES];
}

- (void)cancelAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您确认要取消订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //取消订单
        [[CUOrderManager sharedInstance] CancelOrderWithDiagnosisID:_data.diagnosisID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError) {
//                _cancelOrderBlock();
                [self.slideNavigationController popViewControllerAnimated:YES];
            }
        } pageName:@"MyDiagnosisRecordsDetailViewController"];
    }
}


- (void)YYPhotoViewAction{
    YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:[NSMutableArray arrayWithObject:_imageView.image] numberOfClickedPhoto:0];
    [[self.view superview] addSubview:view];
}

- (void)setData:(CUOrder *)data{
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
