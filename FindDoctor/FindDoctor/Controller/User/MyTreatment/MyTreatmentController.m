//
//  MyTreatmentController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyTreatmentController.h"
#import "MyTreatmentCell.h"
#import "TreatmentDetailsController.h"
#import "DiagnosisRemarkController.h"
#import "CUOrderManager.h"

@interface MyTreatmentController ()

@property (nonatomic,strong)MyTreatmentListModel  * listModel;

@end

@implementation MyTreatmentController


- (id)initWithPageName:(NSString *)pageName listModel:(MyTreatmentListModel *)listModel
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
    self.title = @"就诊记录";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self triggerRefresh];
}

- (void)loadContentView{
    self.contentTableView.backgroundColor = kCommonBackgroundColor;
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CUOrder * order = [self.listModel.items objectAtIndexSafely:indexPath.section];
    if(order.orderStatus == ORDERSTATUS_FINISHED){
        return [MyTreatmentCell kDefaultHeight];
    }else if (order.orderStatus == ORDERSTATUS_COMMENT){
        return [MyTreatmentCell kDefaultHasRemarckHeight];
    }
    return [MyTreatmentCell kDefaultHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listModel.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTreatmentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppointmentCell"];
    if (!cell) {
        cell = [[MyTreatmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAppointmentCell"];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //点击评价
    cell.clickCommentBtn = ^{
        DiagnosisRemarkController * vc = [[DiagnosisRemarkController alloc] initWithPageName:@"DiagnosisRemarkController"];
        
        CUOrder * order = [self.listModel.items objectAtIndexSafely:indexPath.section];
        vc.order = order;
        [self.slideNavigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CUOrder * order = [self.listModel.items objectAtIndexSafely:indexPath.section];
    //注意这里带回来的order没有传递orderStatus参数,进入详情页时手动添加orderStatus参数
    [self postRequestGetOrderHasPayHasMeetDetailWithOrder:order];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    return view;
}

#pragma mark scrollViewDelegate
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

#pragma mark postRequest

//已付款已看病详情
- (void)postRequestGetOrderHasPayHasMeetDetailWithOrder:(CUOrder *)order{
    OrderFilter * filter = [[OrderFilter alloc] init];
    filter.diagnosisID = order.diagnosisID;
    
    [[CUOrderManager sharedInstance] getOrderHasPayHasMeetDetailWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                CUOrder * order1 = [[CUOrder alloc] init];
                order1 = result.parsedModelObject;
                order1.orderStatus = ORDERSTATUS_FINISHED;
                TreatmentDetailsController * vc = [[TreatmentDetailsController alloc] initWithPageName:@"TreatmentDetailsController"];
                vc.order = order1;
                [self.slideNavigationController pushViewController:vc animated:YES];

            }
        }
        
    } pageName:@"TreatmentDetailsController"];
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
