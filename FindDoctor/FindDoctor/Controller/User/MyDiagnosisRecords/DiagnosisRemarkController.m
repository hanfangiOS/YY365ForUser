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
#import "CUCommentManager.h"
#import "TipHandler+HUD.h"
#import "UIImageView+AFNetworking.h"

#define commitViewHeight 50

@interface DiagnosisRemarkController ()<StarRatingViewDelegate,UITextViewDelegate>{
    
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
    UIView                      * _view2_starView_containerView;//星星的背景View
    StarRatingView              * _view2_starView;//星星
    float                         _numStar;//星级
    
    UIView                      * _view3;//第三块view
    DiagnosisRemarkTitleView    * _view3_titleView;//赠送锦旗
    FlagViewInCommentList       * _view3_flagView;//一堆旗
    NSInteger                     _flagID;//锦旗ID
    
    DiagnosisRemarkTitleView    * _view4_titleView;//点评内容
    UITextView                  * _view4_textView;//XXX(须五字以上)
    UILabel                     * _view4_textView_placeholderLabel;//不解释
    
    CommitCommentFilter         * _commitCommentFilter;

}

@end

@implementation DiagnosisRemarkController

#pragma mark - 导航栏

//返回事件
- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark - 加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
    _commitCommentFilter = [[CommitCommentFilter alloc] init];
    _numStar = 5;
    [self loadContentScrollView];
    [self loadContent];
    [self resetData];
    self.title = @"就诊点评";
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEidtor)];
    [self.view addGestureRecognizer:tap];
}

- (void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[self contentView] frameWidth], [self.contentView frameHeight] - commitViewHeight)];
    [self.contentView addSubview:_contentScrollView];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)loadContent{
    [self loadCommitView];
    //第一块view
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 100)];
    _view1.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view1];
    //头像
    _view1_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20 ,(_view1.frameHeight - 64)/2, 64, 64)];
    _view1_imageView1.layer.cornerRadius = 64/2;
    _view1_imageView1.clipsToBounds = YES;
    _view1_imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [_view1 addSubview:_view1_imageView1];
    
    //郭晓炜
    _view1_label1 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, 20, 70, 20)];
    _view1_label1.font = [UIFont systemFontOfSize:16];
    [_view1 addSubview:_view1_label1];
    
    //主任医师
    _view1_label2 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_label1.maxX, 24, 80, 15)];
    _view1_label2.font = [UIFont systemFontOfSize:12];
    [_view1 addSubview:_view1_label2];
    
    //地址：
    _view1_label3 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, _view1_label1.maxY + 5, 40, 20)];
    _view1_label3.text = @"地址：";
    _view1_label3.font = [UIFont systemFontOfSize:12];
    _view1_label3.textColor = [UIColor blueColor];
    [_view1 addSubview:_view1_label3];
    
    //三仙堂XXX
    _view1_label4 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_label3.maxX, _view1_label1.maxY + 5, kScreenWidth - _view1_label3.maxX -20, 20)];
    _view1_label4.font = [UIFont systemFontOfSize:12];
    [_view1 addSubview:_view1_label4];
    
    //2016-XXXX
    _view1_label5 = [[UILabel alloc] initWithFrame:CGRectMake(_view1_imageView1.maxX + 25, _view1_label3.maxY + 5, kScreenWidth - (_view1_imageView1.maxX + 25) - 20, 10)];
    _view1_label5.font = [UIFont systemFontOfSize:10];
    _view1_label5.textColor = [UIColor grayColor];
    [_view1 addSubview:_view1_label5];
    
    //第二块view
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _view1.maxY + 23, kScreenWidth, 100)];
    _view2.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view2];
    
    //就诊评分
    _view2_titleView = [[DiagnosisRemarkTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"就诊评分" Style:TitleViewDefaultStyle];
    _view2_titleView.backgroundColor = [UIColor clearColor];
    [_view2 addSubview:_view2_titleView];
    //星星背景View
    _view2_starView_containerView = [[UIView alloc] initWithFrame:CGRectMake(0,_view2_titleView.maxY , kScreenWidth, _view2.frameHeight - _view2_titleView.frameHeight)];
    [_view2 addSubview:_view2_starView_containerView];
    
    //星星
    CGFloat starPadding = 48;
    CGFloat starViewHeight = 40;
    CGFloat starSpace = (kScreenWidth - starPadding * 2 - starViewHeight * 5)/4;
    CGFloat starViewWidth = starViewHeight * 5 + starSpace * 4;
    
    _view2_starView = [[StarRatingView alloc] initWithFrame:CGRectMake(starPadding,(_view2_starView_containerView.frameHeight - starViewHeight)/2,starViewWidth,starViewHeight) type:StarTypeLarge starSpace:starSpace];
    _view2_starView.editable = YES;
    _view2_starView.delegate = self;
    _view2_starView.rate = _numStar;
    [_view2_starView_containerView addSubview:_view2_starView];
    
    //第三块view
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, _view2.maxY + 23, kScreenWidth, 150)];
    _view3.backgroundColor = [UIColor whiteColor];
    [_contentScrollView addSubview:_view3];
    //赠送锦旗
    _view3_titleView = [[DiagnosisRemarkTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"赠送锦旗" Style:TitleViewDefaultStyle];
    _view3_titleView.backgroundColor = [UIColor clearColor];
    [_view3 addSubview:_view3_titleView];
    //一堆旗
    _view3_flagView = [[FlagViewInCommentList alloc] initWithFrame:CGRectMake(0
, _view3_titleView.maxY + 10, kScreenWidth, _view3.frameHeight - _view3_titleView.frameHeight)];
    [_view3 addSubview:_view3_flagView];
    //第四块view
    //点评内容
    _view4_titleView = [[DiagnosisRemarkTitleView alloc] initWithFrame:CGRectMake(0, _view3.maxY, kScreenWidth, 30) title:@"点评内容" Style:TitleViewDefaultStyle];
    [_contentScrollView addSubview:_view4_titleView];
    //XXX(须五字以上)
    _view4_textView = [[UITextView alloc] initWithFrame:CGRectMake(5, _view4_titleView.maxY + 5, kScreenWidth - 5 - 5, 160)];
    _view4_textView.backgroundColor = [UIColor whiteColor];
    _view4_textView.font = [UIFont systemFontOfSize:14];
    _view4_textView.delegate = self;
    [_view4_textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    _view4_textView_placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 160, 20)];
     _view4_textView_placeholderLabel.text = @"好医生（需5个字以上）";
    _view4_textView_placeholderLabel.font = [UIFont systemFontOfSize:14];
    _view4_textView_placeholderLabel.enabled = NO;
    
    [_view4_textView addSubview:_view4_textView_placeholderLabel];
    [_contentScrollView addSubview:_view4_textView];
    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frameWidth, _view4_textView.maxY + 23);
}

//底部View
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

//刷新数据
- (void)resetData{
    [_view1_imageView1 setImageWithURL:[NSURL URLWithString:self.data.doctorIcon]];
    _view1_label1.text = self.data.doctorName;
    _view1_label2.text = self.data.doctorTitle;
    _view1_label4.text = self.data.clinicAddress;
    _view1_label5.text = [[NSDate dateWithTimeIntervalSince1970:self.data.diagnosisTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"];
    _view3_flagView.data = self.data;
}

#pragma mark - 网络请求
//11902用户提交点评
- (void)postRequestCommit{
    [self showProgressView];
    _commitCommentFilter.dataID = self.diagnosisID;
    _commitCommentFilter.numStar =  _numStar;
    
    //temp
    _flagID = 1;
    
    _commitCommentFilter.flagID =  _flagID;
    
    [[CUCommentManager sharedInstance] getCommitComment:_commitCommentFilter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [self hideProgressView];
        if (!result.hasError) {
            NSInteger errorCode = [[result.responseObject valueForKey:@"errorCode"] integerValue];
            if(errorCode == 0){
                [TipHandler showHUDText:[result.responseObject valueForKey:@"提交成功"] inView:self.view];
                [self.slideNavigationController popToRootViewControllerAnimated:YES];
            }
        }
    } pageName:@"DiagnosisRemarkController"];
}

#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _view4_textView_placeholderLabel.hidden = NO;
    }else{
        _view4_textView_placeholderLabel.hidden = YES;
    }
    
    _commitCommentFilter.content = textView.text;
}

#pragma mark StarRatingViewDelegate

- (void)starRatingView:(StarRatingView *)view rateDidChange:(float)rate{
    _numStar = rate;
}

#pragma mark 各种Action

- (void)commitButtonAction{
    [self commitCheck];
}

#pragma mark - 辅助方法
//提交评价按钮检查
- (void)commitCheck{
    NSString *  str = [_commitCommentFilter.content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str length] < 5) {
        [TipHandler showHUDText:@"评价需5字以上" inView:self.view];
        return;
    }
    [self postRequestCommit];
}

//收起键盘
- (void)endEidtor{
    [self.view endEditing:YES];
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
