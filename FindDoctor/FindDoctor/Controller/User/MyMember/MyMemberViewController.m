//
//  MyMemberViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyMemberViewController.h"
#import "MyMemberCell.h"
#import "ModifyMemberViewController.h"
#import "AddMemberViewController.h"
#import "CUUserManager.h"

@interface MyMemberViewController ()

@property (nonatomic,strong)    MyMemberListModel  * listModel;

@end

@implementation MyMemberViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyMemberListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    self.hasFreshControl = NO;
    if (self) {
        
    }
    
    return self;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    
    [self addRightButtonItemWithImage:[UIImage imageNamed:@"common_icon_trash@2x"] action:@selector(addMemberAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的成员";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self triggerRefresh];
}

- (void)loadContentView{
//    self.contentTableView.backgroundColor = kCommonBackgroundColor;
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentTableView.tableFooterView = [[UIView alloc]init];
}

- (void)addMemberAction{
    AddMemberViewController * VC = [[AddMemberViewController alloc] initWithPageName:@"AddMemberViewController"];
    __weak __block typeof(self)weakSelf = self;
    VC.backWithUserBlock = ^(CUUser * user){
        [weakSelf triggerRefresh];
    };
    [self.slideNavigationController pushViewController:VC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyMemberCell defaultCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyMemberCell"];
    if (!cell) {
        cell = [[MyMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyMemberCell"];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CUUser * user = [self.listModel.items objectAtIndexSafely:indexPath.row];
    ModifyMemberViewController * VC = [[ModifyMemberViewController alloc] initWithPageName:@"ModifyMemberViewController"];
    VC.user = user;
    [self.slideNavigationController pushViewController:VC animated:YES];
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
