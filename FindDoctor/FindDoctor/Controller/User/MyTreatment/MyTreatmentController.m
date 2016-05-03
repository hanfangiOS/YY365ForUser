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

@interface MyTreatmentController ()

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

- (void)loadContentView{
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.backgroundColor = kCommonBackgroundColor;
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyTreatmentCell defaultHeight];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TreatmentDetailsController * VC = [[TreatmentDetailsController alloc] initWithPageName:@"TreatmentDetailsController"];
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
