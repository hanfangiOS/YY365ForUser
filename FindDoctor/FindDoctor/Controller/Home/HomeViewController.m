//
//  HomeViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeSubViewController_Main.h"
#import "HomeSubViewController_Search.h"
#import "CityChooseButton.h"
#import "NewsListController.h"
#import "NewsListModel.h"
#import "AppDelegate.h"
#import "SearchResultListModel.h"
#import "SearchResultViewController.h"
#import "SelectCityVC.h"

@interface HomeViewController ()<UITextFieldDelegate,HomeSubViewController_SearchDelegate>{
    CityChooseButton    *_cityButton;
    UITextField *_searchTextField;
    UIButton    *_searchCancelButton;
    UIButton    *_messageButton;
}
@property (nonatomic, strong) HomeSubViewController_Main *homeSubViewController_Main;
@property (nonatomic, strong) HomeSubViewController_Search *homeSubViewController_Search;

@end

@implementation HomeViewController

- (id)initWithPageName:(NSString *)pageName{
    self = [super initWithPageName:pageName];
    if (self) {
        self.hasToolbar = NO;
        self.hasNavigationBar = NO;
    }
    return self;
}

//- (void)setShouldHaveTab {
//    self.hasTab = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadContentView{
    _homeSubViewController_Main = [[HomeSubViewController_Main alloc]initWithPageName:@"HomeSubViewController_Main"];
    _homeSubViewController_Main.homeViewController = self;
    
    _homeSubViewController_Search = [[HomeSubViewController_Search alloc]initWithPageName:@"HomeSubViewController_Search"];
    _homeSubViewController_Search.delegate = self;
    _homeSubViewController_Search.homeViewController = self;
    [self addChildViewController:_homeSubViewController_Search];
    [self addChildViewController:_homeSubViewController_Main];
    _homeSubViewController_Search.view.frame = CGRectMake(0, 60, kScreenWidth, self.contentView.frameHeight - 60);
    _homeSubViewController_Search.view.hidden = YES;
    _homeSubViewController_Main.view.frame = CGRectMake(0, 60, kScreenWidth, self.contentView.frameHeight - 60);
    [self.contentView addSubview:_homeSubViewController_Search.view];
    [self.contentView addSubview:_homeSubViewController_Main.view];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    headerView.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    [self.contentView addSubview:headerView];
    
    _cityButton = [[CityChooseButton alloc]initWithFrame:CGRectMake(10, 26.2, 46, 24)];
    _cityButton.cityLabel.text = @"成都";
    [_cityButton addTarget:self action:@selector(selectCityAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_cityButton];
    
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(68, 27, kScreenWidth - 120, 24)];
    _searchTextField.placeholder = @"搜索病症/医师/症状/诊所";
    [_searchTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    _searchTextField.font = [UIFont systemFontOfSize:13];
    _searchTextField.textColor = [UIColor whiteColor];
    _searchTextField.delegate = self;
    _searchTextField.layer.backgroundColor = UIColorFromHex(0x0068dd).CGColor;
    _searchTextField.layer.cornerRadius = 3.f;
    _searchTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, _searchTextField.frameHeight)];;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [headerView addSubview:_searchTextField];
    
    _searchCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 32 - 6, 26.2 ,36, 24)];
    [_searchCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _searchCancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _searchCancelButton.titleLabel.textColor = [UIColor whiteColor];
    _searchCancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _searchCancelButton.hidden = YES;
    [_searchCancelButton addTarget:self action:@selector(searchCancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_searchCancelButton];
    
    _messageButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 32 - 6, 26.2 ,36, 24)];
    [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
    _messageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _messageButton.titleLabel.textColor = [UIColor whiteColor];
    _messageButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _messageButton.hidden = NO;
    [_messageButton addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_messageButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _homeSubViewController_Main.slideNavigationController = self.slideNavigationController;
    _homeSubViewController_Search.slideNavigationController = self.slideNavigationController;
}

- (void)messageAction{
    NewsListModel * listMiodel = [[NewsListModel alloc] init];
    NewsListController * VC = [[NewsListController alloc] initWithPageName:@"NewsListController" listModel:listMiodel];
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (void)selectCityAction{
    SelectCityVC *VC = [[SelectCityVC alloc]initWithPageName:@"SelectCityVC"];
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (void)searchCancel{
    [self.view endEditing:YES];
    //关闭搜索
    float timeDuration = 0.25;
    //搜索激活状态
    CAKeyframeAnimation *popAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform2"];
    popAnimation2.duration = timeDuration;
    popAnimation2.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation2.keyTimes = @[@(timeDuration)];
    popAnimation2.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_homeSubViewController_Main.view.layer addAnimation:popAnimation2 forKey:nil];
    _homeSubViewController_Search.view.alpha = 1;
    _homeSubViewController_Main.view.alpha = 0;
    _searchCancelButton.hidden = NO;
    _searchCancelButton.alpha = 1;
    _messageButton.hidden = NO;
    _messageButton.alpha = 0;
    _cityButton.hidden = NO;
    _cityButton.alpha = 0;
    [UIView animateWithDuration:timeDuration delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _searchTextField.frame = CGRectMake(68, 27, kScreenWidth - 120, 24);
        _searchCancelButton.alpha = 0;
        _cityButton.alpha = 1;
        _messageButton.alpha = 1;
        _homeSubViewController_Search.view.alpha = 0;
        _homeSubViewController_Main.view.alpha = 1;
        AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.tabController.customTabBar.hidden = NO;
    } completion:^(BOOL finished) {
        _searchCancelButton.hidden = YES;
        _cityButton.hidden = NO;
        _messageButton.hidden = NO;
        _homeSubViewController_Search.view.hidden = YES;
        [self.view bringSubviewToFront:_homeSubViewController_Main.view];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_homeSubViewController_Search loadHistory];
    if(_homeSubViewController_Search.view.hidden == YES){
        _homeSubViewController_Search.view.hidden = NO;
        float timeDuration = 0.25f;
        //搜索激活状态
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = timeDuration;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@(timeDuration)];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_homeSubViewController_Search.view.layer addAnimation:popAnimation forKey:nil];
        _homeSubViewController_Search.view.alpha = 0.f;
        _homeSubViewController_Main.view.alpha = 1.f;
        _searchCancelButton.hidden = NO;
        _searchCancelButton.alpha = 0;
        _messageButton.hidden = NO;
        _messageButton.alpha = 1;
        _cityButton.hidden = NO;
        _cityButton.alpha = 1;
        
        __weak __block typeof(self)weakSelf = self;
        [UIView animateWithDuration:timeDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _searchTextField.frame = CGRectMake(8, 27, kScreenWidth - 60 , 24);
            _searchCancelButton.alpha = 1;
            _cityButton.alpha = 0;
            _messageButton.alpha = 0;
            _homeSubViewController_Search.view.alpha = 1.f;
            _homeSubViewController_Main.view.alpha = 0.f;
            AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.tabController.customTabBar.hidden = YES;
        } completion:^(BOOL finished) {
            _searchCancelButton.hidden = NO;
            _cityButton.hidden = YES;
            _messageButton.hidden = YES;
            [weakSelf.view bringSubviewToFront:_homeSubViewController_Search.view];
            
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    if (![textField.text isEmpty]) {
        [_homeSubViewController_Search searchClickWithString:textField.text];
    }
    return YES;
}

- (void)HomeSubViewController_SearchEndEdit{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
