//
//  MyAppointmentController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyAppointmentController.h"
#import "MyAppointmentCell.h"
#import "MyAppointmentForTreatCell.h"
#import "MyAppointMentHeaderView.h"
#import "AppointmentDetailsController.h"
#import "TipHandler+HUD.h"
#import "CUOrder.h"
#import "CUOrderManager.h"
#import "OrderConfirmController.h"

typedef NS_ENUM(NSInteger,ListType){
    ListTypeForPay = 0,//待支付
    ListTypeForTreat = 1,//约诊
};

@interface MyAppointmentController ()

@property (strong,nonatomic)MyAppointMentHeaderView * headerView;

@property (nonatomic,strong)MyAppointmentListModel  * listModel;

@property (nonatomic,assign)ListType  listType;

@end

@implementation MyAppointmentController


- (id)initWithPageName:(NSString *)pageName listModel:(MyAppointmentListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    if (self) {
    }
    return self;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listType = ListTypeForPay;
    self.title = @"我的约诊";

}

- (void)loadContentView{
    self.headerView = [[MyAppointMentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headerView];
    
    [self.headerView.leftBtn addTarget:self action:@selector(forPayMentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.leftBtn setTitle:@"待付款" forState:UIControlStateNormal];
    self.headerView.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.headerView.leftBtn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [self.headerView.leftBtn sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    [self.headerView.rightBtn addTarget:self action:@selector(forTreatMentAction) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.headerView.rightBtn setTitle:@"待就诊" forState:UIControlStateNormal];
        [self.headerView.rightBtn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    
    UIView * headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frameHeight - 0.75, kScreenWidth, 0.75)];
    headerViewBottomLine.backgroundColor = kLightLineColor;
    [self.headerView addSubview:headerViewBottomLine];
    
    
    self.contentTableView.frame = CGRectMake(0, self.headerView.maxY, kScreenWidth, self.contentView.frameHeight - self.headerView.frameHeight);
    self.contentTableView.backgroundColor = kCommonBackgroundColor;
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == ListTypeForPay) {
        return [MyAppointmentCell defaultHeight];
    }
    if (self.listType == ListTypeForTreat) {
       return [MyAppointmentForTreatCell defaultHeight];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listModel.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //待付款
    if (self.listType == ListTypeForPay) {
        MyAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppointmentCell"];
        if (!cell) {
            cell = [[MyAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAppointmentCell"];
        }
        cell.data = [self.listModel.items objectAtIndexSafely:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickPayBtn = ^{
            OrderConfirmController * vc = [[OrderConfirmController alloc] initWithPageName:@"OrderConfirmController"];
            vc.order = [self.listModel.items objectAtIndexSafely:indexPath.section];
            [self.slideNavigationController pushViewController:vc animated:YES];
        };
        return cell;
    //待就诊
    }else{
        MyAppointmentForTreatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppointmentForTreatCell"];
        if (!cell) {
            cell = [[MyAppointmentForTreatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAppointmentForTreatCell"];
        }
        cell.data = [self.listModel.items objectAtIndexSafely:indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CUOrder * order = [self.listModel.items objectAtIndexSafely:indexPath.section];
    //注意这里带回来的order没有传递orderStatus参数,进入详情页时手动添加orderStatus参数
    if (self.listType == ListTypeForPay) {
         [self postRequestGetOrderNotPayDetailWithOrder:order];
    }else if (self.listType == ListTypeForTreat){
        [self postRequestGetOrderHasPayNotMeetDetailWithOrder:order];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark postRequest

//未付款详情
- (void)postRequestGetOrderNotPayDetailWithOrder:(CUOrder *)order{
    OrderFilter * filter = [[OrderFilter alloc] init];
    filter.diagnosisID = order.diagnosisID;
    
    [[CUOrderManager sharedInstance] getOrderNotPayDetailWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                CUOrder * order1 = [[CUOrder alloc] init];
                order1 = result.parsedModelObject;
                order1.orderStatus = ORDERSTATUS_UNPAID;
                AppointmentDetailsController * VC = [[AppointmentDetailsController alloc] initWithPageName:@"AppointmentDetailsController"];
                VC.order = order1;
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
        }
        
    } pageName:@"MyAppointmentController"];
}

//已付款未看病详情
- (void)postRequestGetOrderHasPayNotMeetDetailWithOrder:(CUOrder *)order{
    OrderFilter * filter = [[OrderFilter alloc] init];
    filter.diagnosisID = order.diagnosisID;
    
    [[CUOrderManager sharedInstance] getOrderHasPayNotMeetDetailWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                CUOrder * order1 = [[CUOrder alloc] init];
                order1 = result.parsedModelObject;
                order1.orderStatus = ORDERSTATUS_PAID;
                AppointmentDetailsController * VC = [[AppointmentDetailsController alloc] initWithPageName:@"AppointmentDetailsController"];
                VC.order = order1;
                [self.slideNavigationController pushViewController:VC animated:YES];

            }
        }
        
    } pageName:@"MyAppointmentController"];
}

#pragma mark Action

- (void)forPayMentAction{

    self.listType = ListTypeForPay;
    
    [self.headerView.leftBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.headerView.leftBottomLine.hidden = NO;
    [self.headerView.rightBtn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    self.headerView.rightBottomLine.hidden = YES;
    
    self.listModel.filter.orderStatus = ORDERSTATUS_UNPAID;
    self.listModel.filter.total = self.listModel.items.count;
    self.listModel.filter.rows = 10;
    [self.listModel.items removeAllObjects];
    
    [self.contentTableView reloadData];
    [self triggerRefresh];
    
    

}

- (void)forTreatMentAction{
    self.listType = ListTypeForTreat;
    
    [self.headerView.rightBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.headerView.rightBottomLine.hidden = NO;
    [self.headerView.leftBtn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    self.headerView.leftBottomLine.hidden = YES;
    
    self.listModel.filter.orderStatus = ORDERSTATUS_PAID;
    self.listModel.filter.total = self.listModel.items.count;
    self.listModel.filter.rows = 10;
    [self.listModel.items removeAllObjects];
    
    [self.contentTableView reloadData];
    [self triggerRefresh];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
