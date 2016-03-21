//
//  MyAccountMainViewController.m
//  FindDoctor
//
//  Created by Guo on 15/11/1.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "MyAccountMainViewController.h"
#import "TotalMoneyView.h"
#import "ListMoneyView.h"
#import "CUOrderManager.h"

@interface MyAccountMainViewController ()
{
    UITableView *contentTableView;
    TotalMoneyView *incomeView;
    TotalMoneyView *costView;
    
    ListMoneyView *listMoneyView;
}

@end

@implementation MyAccountMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProgressView];
    __weak __block MyAccountMainViewController *blockSelf = self;
    [[CUOrderManager sharedInstance]getMyAccountWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError) {
            blockSelf.data = result.parsedModelObject;
            costView.fee = [NSString stringWithFormat:@"%.2lf",blockSelf.data.totalCost];
            incomeView.fee = [NSString stringWithFormat:@"%.2lf",blockSelf.data.totalIncome];
            listMoneyView.data = blockSelf.data;
            [listMoneyView.incomeTableView reloadData];
            [listMoneyView.costTableView reloadData];
            [incomeView show];
            [costView show];
        }
    } pageName:@"MyAccountMainViewController"];
}

- (void)viewDidLoad {
    self.title = @"我的账户";
    [self loadContentView];
    [super viewDidLoad];
}

- (void)loadContentView{
    [self initTotalIncomeCostView];
    [self initListMoneyView];
    
//    [self loadContentTableView];
}

- (void)initTotalIncomeCostView{
    int diamater = 100;
    costView = [[TotalMoneyView alloc]initWithFrame:CGRectMake((kScreenWidth - 2*diamater)/3, 15, diamater, diamater) title:@"现金支出(元)" color:UIColorFromHex(Color_Hex_Text_Highlighted)];
    costView.userInteractionEnabled = YES;
    UITapGestureRecognizer *costViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(costViewAction)];
    costViewTap.numberOfTapsRequired = 1;
    [costView addGestureRecognizer:costViewTap];
    [self.contentView addSubview:costView];
    
    incomeView = [[TotalMoneyView alloc]initWithFrame:CGRectMake(2*(kScreenWidth - 2*diamater)/3 + diamater, 15, diamater, diamater) title:@"诊金券支出(元)" color:UIColorFromHex(Color_Hex_NavBackground)];
    UITapGestureRecognizer *incomeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incomeViewAction)];
    incomeViewTap.numberOfTapsRequired = 1;
    [incomeView addGestureRecognizer:incomeViewTap];
    [self.contentView addSubview:incomeView];

}

- (void)initListMoneyView{
    listMoneyView = [[ListMoneyView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(incomeView.frame) + 15, kScreenWidth - 30, self.contentView.frameHeight - CGRectGetMaxY(incomeView.frame) - 15)];
    listMoneyView.data = self.data;
    [self.contentView addSubview:listMoneyView];
}

- (void)setData:(MyAccount *)data{
    _data = data;
}

- (void)costViewAction{
    [listMoneyView costButtonAction];
    [costView show];
}

- (void)incomeViewAction{
    [listMoneyView incomeButtonAction];
    [incomeView show];
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
