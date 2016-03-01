//
//  HomeViewController.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "HomeViewController.h"
#import "UIConstants.h"
#import "CUUIContant.h"
#import "UIImage+Color.h"

#import "DoctorListContainerController.h"
#import "HomeSubViewController2.h"
#import "CUOrderListContainerController.h"
#import "CUUserCollectionController.h"

#import "DoctorListModel.h"
#import "DoctorListController.h"
#import "HomeTipView.h"
#import "CUUserManager.h"
#import "CULoginViewController.h"
#import "CURegisterController.h"
#import "DoctorSearchController.h"
#import "CUOrderManager.h"

#import "TipMessageData.h"

#define HomeValue(x)   AdaptedValue(x)

#define kHomeHeaderViewHeight   HomeValue(200.0)

@interface HomeViewController (){
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UIButton *registerButton;
@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation HomeViewController
@synthesize tipTableView;

- (void)addNotifications
{}

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    
    if (self) {
        _hasNavigationBar = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[CUOrderManager sharedInstance] getHomeTipListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (dataArray == nil){
            dataArray = [NSMutableArray new];
        }
        if (!result.hasError) {
            dataArray = result.parsedModelObject;
            
            [tipTableView reloadData];
            //            [tipTableView setNeedsDisplay];
        }
        else{
            
        }
        
    } pageName:@"HomeViewController"];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShouldHaveTab
{
    self.hasTab = YES;
}

- (void)loadNavigationBar
{
    
}

- (void)loadContentView
{
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImageView.frame = self.contentView.frame;
    backgroundImageView.contentMode = 0;
    [self.contentView addSubview:backgroundImageView];
    [self initButton];
//    [self initSearchEntrance];
//    [self initCollectionButton];
}

- (void)initButton
{
    UIImage *findDoctor = [UIImage imageNamed:@"home_find_doctor_button"];
    
    float start_y = 40.f;
    float interval_y = 30.f;
    
    UIButton *findDoctorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    findDoctorButton.frame = (CGRect){(kScreenWidth-findDoctor.size.width)/2.f, start_y, findDoctor.size};
    [findDoctorButton setImage:findDoctor forState:UIControlStateNormal];
    [findDoctorButton setImage:findDoctor forState:UIControlStateHighlighted];
    [findDoctorButton addTarget:self action:@selector(findDoctorAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:findDoctorButton];
    
    UIImage *search = [UIImage imageNamed:@"home_search_button"];
    
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){(kScreenWidth-search.size.width)/2.f,CGRectGetMaxY(findDoctorButton.frame)+interval_y,search.size};
    [searchbutton setImage:search forState:UIControlStateNormal];
    [searchbutton setImage:search forState:UIControlStateHighlighted];
    [searchbutton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
    
    if (tipTableView == nil) {
        tipTableView = [[UITableView alloc]init];
    }
    tipTableView.frame = CGRectMake(kScreenWidth *0.05, CGRectGetMaxY(findDoctorButton.frame) + 80, kScreenWidth*0.9,  floor((([self.contentView frameHeight]-CGRectGetMaxY(findDoctorButton.frame) )/ 40))*40 - 80);
    tipTableView.backgroundColor = [UIColor clearColor];
    tipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tipTableView.scrollEnabled = NO;
    tipTableView.delegate = self;
    tipTableView.dataSource = self;
    [self.contentView addSubview:tipTableView];

//    NSArray *tips = @[@"手机注册即送20元代金券",@"张仲景医生12：30在中医药就诊",@"三伏天降暑三方"];
//
//    float tip_height = 40.f;
//    
//    UIImage *topLine = [UIImage imageNamed:@"home_tip_top_line"];
//    
//    UIImageView *lineView = [[UIImageView alloc] init];
//    lineView.frame = (CGRect){(kScreenWidth-topLine.size.width)/2.f,CGRectGetMaxY(searchbutton.frame)+interval_y-topLine.size.height,topLine.size};
//    lineView.image = topLine;
//    [self.view addSubview:lineView];
//    
//    for (int i=0; i<tips.count; i++) {
//        HomeTipView *hometipview = [[HomeTipView alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(searchbutton.frame)+interval_y+i*tip_height,kScreenWidth,tip_height}];
//        [hometipview setContentTitle:tips[i]];
//        if (i==0) {
//            [hometipview hiddenLine];
//        }
////        [self.view addSubview:hometipview];
//    }
//    
//    lineView = nil;
//    lineView = [[UIImageView alloc] init];
//    lineView.frame = (CGRect){(kScreenWidth-topLine.size.width)/2.f,CGRectGetMaxY(searchbutton.frame)+interval_y+tips.count*tip_height,topLine.size};
//    lineView.image = topLine;
//    [self.view addSubview:lineView];
    
    float margin_left = 30.f;
    float margin_bottom = 20.f;
    
    UIImage *registerImage = [UIImage imageNamed:@"home_register_button"];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = (CGRect){margin_left, self.contentView.frame.size.height-margin_bottom-registerImage.size.height, registerImage.size};
    [_registerButton setImage:registerImage forState:UIControlStateNormal];
    [_registerButton setImage:registerImage forState:UIControlStateHighlighted];
    [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_registerButton];
    
    UIImage *loginImage = [UIImage imageNamed:@"home_login_button"];
    
    float repair_x = 5;

    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = (CGRect){kScreenWidth-loginImage.size.width-margin_left, self.contentView.frame.size.height-margin_bottom-loginImage.size.height, loginImage.size};
    [_loginButton setImage:loginImage forState:UIControlStateNormal];
    [_loginButton setImage:loginImage forState:UIControlStateHighlighted];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_loginButton];
    
    // KVO监听token值
    [[CUUserManager sharedInstance].user addObserver:self forKeyPath:@"token" options:NSKeyValueObservingOptionNew context:NULL];
    
//    testBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    testBtn.frame = (CGRect){50, 220, 80, 50};
//    [testBtn setTitle:@"我的记录" forState:UIControlStateNormal];
//    [testBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [testBtn addTarget:self action:@selector(enterMyRecord) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:testBtn];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"token"]) {
        // token值改变时显示/隐藏注册和登录按钮
        _registerButton.hidden = _loginButton.hidden = [[CUUserManager sharedInstance] isLogin];
    }
}

- (void)dealloc
{
    // 解除KVO
    [[CUUserManager sharedInstance].user removeObserver:self forKeyPath:@"token"];
}

//临时创建搜索入口
- (void)initSearchEntrance
{
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){50,100,100,80};
    [searchbutton setTitle:@"搜索" forState:UIControlStateNormal];
    searchbutton.backgroundColor = [UIColor redColor];
    [searchbutton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
}

//临时创建我的收藏
- (void)initCollectionButton
{
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){200,100,100,80};
    [searchbutton setTitle:@"我的收藏" forState:UIControlStateNormal];
    searchbutton.backgroundColor = [UIColor redColor];
    [searchbutton addTarget:self action:@selector(showMyCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
}

#pragma mark - Private Func

- (void)searchAction
{
    DoctorSearchController *searchVC = [[DoctorSearchController alloc] init];
    [self.slideNavigationController pushViewController:searchVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    searchVC.action = ^(NSString *keyword) {
        [weakSelf findDoctorWithKeyword:keyword];
    };
}

- (void)findDoctorWithKeyword:(NSString *)keyword
{
    DoctorFilter *filter = [[DoctorFilter alloc] init];
    filter.keyword = keyword;
    
    DoctorListModel *listModel1 = [[DoctorListModel alloc] initWithFilter:filter];
    DoctorListController *listVC = [[DoctorListController alloc] initWithPageName:@"DoctorListController" listModel:listModel1];
    [self.slideNavigationController pushViewController:listVC animated:YES];
}

- (void)showMyCollection
{
    CUUserCollectionController *usercollectionVC = [[CUUserCollectionController alloc] initWithHeight:kTopTabBarHeight];
    [self.slideNavigationController pushViewController:usercollectionVC animated:YES];
}

- (void)findDoctorAction
{
    HomeSubViewController2 *homesubVC = [[HomeSubViewController2 alloc] init];
    [self.slideNavigationController pushViewController:homesubVC animated:YES];
}

- (void)enterMyRecord
{
    if (![[CUUserManager sharedInstance] isLogin]) {
        [self loginAction];
        return;
    }
    
    CUOrderListContainerController *orderListVC = [[CUOrderListContainerController alloc] initWithHeight:kTopTabBarHeight];
    [self.slideNavigationController pushViewController:orderListVC animated:YES];
}

- (void)loginAction
{
    CULoginViewController *loginVC = [[CULoginViewController alloc] init];
    loginVC.intervalY = 0;
    [self.slideNavigationController pushViewController:loginVC animated:YES];
}

- (void)registerAction
{
    CURegisterController *registerVC = [[CURegisterController alloc] init];
    [self.slideNavigationController pushViewController:registerVC animated:YES];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    //数据倒入
    TipMessageData *data = [dataArray objectAtIndex:indexPath.row];
    //画图
    [cell setFrameWidth:kScreenWidth*0.9];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundView0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 4)];
    backgroundView0.image = [UIImage imageNamed:@"tipTableViewCellBackground"];
    backgroundView0.contentMode = UIViewContentModeScaleToFill;
    backgroundView0.clipsToBounds = YES;
    [cell addSubview:backgroundView0];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 4)];
    backgroundView.image = [UIImage imageNamed:@"tipTableViewCellBackground"];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    backgroundView.clipsToBounds = YES;
    
    cell.selectedBackgroundView = backgroundView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, -2, [cell frameWidth]-60, [cell frameHeight])];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.lineBreakMode = 1;
    label.text = data.title;
    label.textColor = [UIColor whiteColor];
    [cell addSubview:label];
    
    UIImageView *separatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(30, [cell frameHeight]-5, [label frameWidth],2)];
    separatorLine.image = [UIImage imageNamed:@"HomeTipViewInterval"];
    separatorLine.contentMode = 0;
    [cell addSubview:separatorLine];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
}

- (void)deselect{
    [self.tipTableView deselectRowAtIndexPath:[self.tipTableView indexPathForSelectedRow] animated:YES];
}
@end
