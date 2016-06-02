//
//  DoctorSelectOrderTimeController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/17.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorSelectOrderTimeController.h"
#import "DoctorAppointmentListView.h"
#import "OrderCreateController.h"
#import "CUOrderManager.h"

@interface DoctorSelectOrderTimeController ()<UIAlertViewDelegate>{
    DoctorAppointmentListView *listView;
}

@end

@implementation DoctorSelectOrderTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择约诊时段";
    
    listView = [[DoctorAppointmentListView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,self.contentView.frameHeight) data:_doctorAppointmentListItem releaseID:self.releaseID];
    [self.contentView addSubview:listView];
    
    __weak __block DoctorSelectOrderTimeController *blockSelf = self;
    listView.clickBlock = ^ (SelectOrderTime *selectOrderTime){
        long long releaseID = blockSelf.doctorAppointmentListItem.releaseID;
        [[CUOrderManager sharedInstance] getMemberListWithDiagnosisID:blockSelf.diagnosisID releaseID:releaseID orderID:selectOrderTime.orderID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError) {
                if (![(NSNumber *)[result.responseObject valueForKey:@"errorCode"] integerValue]) {
                    OrderCreateController *createVC = [[OrderCreateController alloc] initWithPageName:@"DoctorSelectOrderTimeController"];
                    //                createVC.doctor = blockSelf.doctor;
                    createVC.memberArray = result.parsedModelObject;
                    CUOrder *order = [[CUOrder alloc]init];
                    order.diagnosisID = [(NSNumber *)[[result.responseObject valueForKey:@"data"] valueForKey:@"diagnosisID"] longLongValue];
                    order.service.doctor = blockSelf.doctor;
                    createVC.order = order;
                    [blockSelf.slideNavigationController pushViewController:createVC animated:YES];
                }
                else{
                    NSDictionary * data = [result.responseObject objectForKeySafely:@"data"];
                    NSString * message = [data objectForKeySafely:@"message"];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alert.delegate = blockSelf;
                    [alert show];
                }
            }
        } pageName:@"DoctorSelectOrderTimeController"];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [listView loadNewData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [listView loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
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
