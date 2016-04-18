//
//  MyAppointmentController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/18.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyAppointmentController.h"
#import "MyAppointmentCell.h"
#import "MyAppointMentHeaderView.h"
#import "AppointmentDetailsController.h"

@interface MyAppointmentController ()

@property (strong,nonatomic)MyAppointMentHeaderView * headerView;

@property (nonatomic,strong)MyAppointmentListModel  * listModel;

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
    self.title = @"我的约诊";

}

- (void)loadContentView{
    self.headerView = [[MyAppointMentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    [self.contentView addSubview:self.headerView];
    
    [self.headerView.leftBtn addTarget:self action:@selector(forPayMentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.leftBtn setTitle:@"待付款" forState:UIControlStateNormal];
    [self.headerView.leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.headerView.leftBtn sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    [self.headerView.rightBtn addTarget:self action:@selector(forTreatMentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.rightBtn setTitle:@"待就诊" forState:UIControlStateNormal];
        [self.headerView.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.contentTableView.frame = CGRectMake(0, self.headerView.maxY, kScreenWidth, self.contentView.frameHeight - self.headerView.frameHeight);
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyAppointmentCell defaultHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.listModel.items.count;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAppointmentCell"];
    if (!cell) {
        cell = [[MyAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAppointmentCell"];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppointmentDetailsController * VC = [[AppointmentDetailsController alloc] initWithPageName:@"AppointmentDetailsController"];
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark Action

- (void)forPayMentAction{
    [self.headerView.leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.headerView.leftBottomLine.hidden = NO;
    [self.headerView.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.headerView.rightBottomLine.hidden = YES;
    
    //[self post];
}

- (void)forTreatMentAction{
    [self.headerView.rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.headerView.rightBottomLine.hidden = NO;
    [self.headerView.leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.headerView.leftBottomLine.hidden = YES;
//    [self post];
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
