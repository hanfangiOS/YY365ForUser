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

@interface DoctorSelectOrderTimeController (){
    DoctorAppointmentListView *listView;
}

@end

@implementation DoctorSelectOrderTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    listView = [[DoctorAppointmentListView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,self.contentView.frameHeight) data:_doctorAppointmentListItem];
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
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[result.responseObject valueForKey:@"data"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        } pageName:@"DoctorSelectOrderTimeController"];
    };
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
