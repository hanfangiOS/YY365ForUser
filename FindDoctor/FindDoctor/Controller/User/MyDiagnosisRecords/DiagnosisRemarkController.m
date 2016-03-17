//
//  DiagnosisRemarkController.m
//  uyi365ForPatient
//
//  Created by ZhuHaoRan on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DiagnosisRemarkController.h"
#import "FlagViewInCommentList.h"
#import "StarRatingView.h"
#import "DiagnosisRemarkTitleView.h"
#import "Comment.h"
#import "CUCommentManager.h"

#define commitViewHeight 50

@interface DiagnosisRemarkController ()<StarRatingViewDelegate>{
    
    UIScrollView                * _contentScrollView;
    
    UIView                      * _view1;//第一块view
    UIImageView                 * _view1_imageView1;//头像
    UILabel                     * _view1_label1;//郭晓炜
    UILabel                     * _view1_label2;//主任医师
    UILabel                     * _view1_label3;//地址：
    UILabel                     * _view1_label4;//三仙堂XXX
    UILabel                     * _view1_label5;//2016-XXXX
    
    UIView                      * _view2;//第二块view
    DiagnosisRemarkTitleView    * _view2_titleView;//就诊评分
    StarRatingView              * _view2_starView;//星星
    
    UIView                      * _view3;//第三块view
    DiagnosisRemarkTitleView    * _view3_titleView;//赠送锦旗
    FlagViewInCommentList       * _view3_flagView;//一堆旗
    UIImageView                 * _view3_selectedView;//那朵花
    
    UIView                      * _view4;//第二块view
    DiagnosisRemarkTitleView    * _view4_titleView;//点评内容
    UITextView                  * _view4_textField;//XXX(须五字以上)

    DiagnosisCommentFilter      * _diagnosisCommentFilter;
    CommitCommentFilter         * _commitCommentFilter;
}

@end

@implementation DiagnosisRemarkController

//11901点评按钮接口
- (void)postRequestComment{
   [[CUCommentManager sharedInstance] getDiagnosisComment:_diagnosisCommentFilter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
       ;
   } pageName:@"DiagnosisRemarkController"];
    
}

//11902用户提交点评
- (void)postRequestCommit{
    [[CUCommentManager sharedInstance] getCommitComment:_commitCommentFilter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        ;
    } pageName:@"DiagnosisRemarkController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContentScrollView];
    [self loadContent];
}

- (void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[self contentView] frameWidth], [self.contentView frameHeight] - commitViewHeight)];
    [self.contentView addSubview:_contentScrollView];
    
    
}

- (void)loadContent{
    
    [self loadCommitView];
    //第一块view
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, kScreenWidth, 120)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view1];
    //头像
    _view1_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20 ,_view1.frameHeight - 32, 64, 64)];
    _view1_imageView1.layer.cornerRadius = 64/2;
    _view1_imageView1.clipsToBounds = YES;
    _view1_imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [_view1 addSubview:_view1_imageView1];
    
    //郭晓炜
    _view1_label1 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, 20, 100, 20)];
    _view1_label1.font = [UIFont systemFontOfSize:16];
    [_view1 addSubview:_view1_label1];
    
    //主任医师
    _view1_label2 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_label1.maxX + 5, 25, 110, 15)];
    _view1_label2.font = [UIFont systemFontOfSize:12];
    [_view1 addSubview:_view1_label2];
    
    //地址：
    _view1_label3 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, 2, 40, 20)];
    _view1_label3.text = @"地址：";
    _view1_label3.font = [UIFont systemFontOfSize:12];
    _view1_label3.textColor = [UIColor blueColor];
    [_view1 addSubview:_view1_label3];
    
    //三仙堂XXX
    _view1_label4 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_label3.maxX, 2, kScreenWidth - _view1_label3.maxX, 20)];
    _view1_label4.font = [UIFont systemFontOfSize:12];
    [_view1 addSubview:_view1_label4];
    
    //2016-XXXX
    _view1_label5 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, 2, kScreenWidth - (_view1_imageView1.maxX + 25), 10)];
    _view1_label5.font = [UIFont systemFontOfSize:10];
    _view1_label5.textColor = [UIColor grayColor];
    [_view1 addSubview:_view1_label5];
    
    //第二块view
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _view1.maxY + 23, kScreenWidth, 120)];
    _view2.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view2];
    
    //就诊评分
    _view2_titleView = [[DiagnosisRemarkTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"就诊评分" Style:TitleViewDefaultStyle];
    _view2_titleView.backgroundColor = [UIColor clearColor];
    [_view2 addSubview:_view2_titleView];
    
    //星星
    _view2_starView = [[StarRatingView alloc] initWithFrame:CGRectMake(0,_view2_titleView.maxY , kScreenWidth, _view2.frameHeight - _view2_titleView.frameHeight) type:StarTypeLarge starSpace:5];
    _view2_starView.delegate = self;
    [_view2 addSubview:_view2_starView];
    
    //第三块view
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, _view2.maxY + 23, kScreenWidth, 200)];
    _view3.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view3];
    //赠送锦旗
    _view3_titleView = [[DiagnosisRemarkTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"赠送锦旗" Style:TitleViewDefaultStyle];
    _view3_titleView.backgroundColor = [UIColor clearColor];
    [_view3 addSubview:_view3_titleView];
    //一堆旗
//    _view3_flagView = [[FlagViewInCommentList alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    //那朵花
}
UIView                      * _view3;//第三块view
DiagnosisRemarkTitleView    * _view3_titleView;//赠送锦旗
FlagViewInCommentList       * _view3_flagView;//一堆旗
UIImageView                 * _view3_selectedView;//那朵花

- (void)loadCommitView{
    UIView *commitView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentScrollView.frame), kScreenWidth, commitViewHeight)];
    commitView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:commitView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.layer.backgroundColor = UIColorFromHex(0xc4c4c4).CGColor;
    [commitView addSubview:lineView];
    
    int commitButtonHeight = 35;
    UIButton *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, (commitViewHeight - commitButtonHeight)/2, kScreenWidth - 30, commitButtonHeight)];
    commitButton.layer.cornerRadius = commitButtonHeight/2.f;
    [commitButton setTitle:@"确 定" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    commitButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    [commitView addSubview:commitButton];
}

#pragma mark StarRatingViewDelegate
- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate{
    
}

#pragma mark Action

- (void)commitButtonAction{
    [self postRequestCommit];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
