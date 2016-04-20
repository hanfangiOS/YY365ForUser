//
//  SettingViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "AccountSecurityViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_logoutView;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 44)];
    button.center = _logoutView.center;
    [button addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [_logoutView addSubview:button];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = _logoutView;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.tableView];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
//    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myAccountBigButtonImage"] action:@selector(edit)];
}

- (void)loginOut{
    LoginViewController * VC = [[LoginViewController alloc] initWithPageName:@"LoginViewController"];
    [VC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.slideNavigationController presentViewController:VC animated:YES completion:nil];
    [self performSelector:@selector(backUserVC) withObject:nil afterDelay:1];
   
}

- (void)backUserVC{
     [self.slideNavigationController popViewControllerAnimated:NO];
}
#pragma mark tableViewDelegata&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.imageView.backgroundColor = [UIColor redColor];
                cell.textLabel.text = @"设置常用城市";
                cell.detailTextLabel.text = @"成都";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 1) {
                cell.imageView.backgroundColor = [UIColor redColor];
                cell.textLabel.text = @"账号安全";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.imageView.backgroundColor = [UIColor redColor];
                cell.textLabel.text = @"消息通知";
                cell.detailTextLabel.text = @"开";
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.imageView.backgroundColor = [UIColor redColor];
                cell.textLabel.text = @"清除本地缓存";
                cell.detailTextLabel.text = @"0.67MB";
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            if (indexPath.row == 1) {
                cell.imageView.backgroundColor = [UIColor redColor];
                cell.textLabel.text = @"关于优医";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        default:
            return 0;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 1) {
                AccountSecurityViewController *VC = [[AccountSecurityViewController alloc]initWithPageName:@"AccountSecurityViewController"];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
            break;
        case 2:
            if(indexPath.row == 1){
                AboutViewController *VC = [[AboutViewController alloc]initWithPageName:@"AboutViewController"];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
            break;
            
        default:
            break;
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
