//
//  AccountSecurityViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AccountSecurityViewController.h"
#import "CUUserManager.h"
#import "ChangePhoneViewController1.h"
#import "ChangePasswordViewController.h"

@interface AccountSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号安全";
}

- (void)loadContentView {
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.contentView.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.tableView];

}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = [CUUserManager sharedInstance].user.cellPhone;
            break;
        case 1:
            cell.textLabel.text = @"修改密码";
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ChangePhoneViewController1 *VC = [[ChangePhoneViewController1 alloc]initWithPageName:@"ChangePhoneViewController1"];
            [self.slideNavigationController pushViewController:VC  animated:YES];
        }
            break;
        case 1:
        {
            ChangePasswordViewController *VC = [[ChangePasswordViewController alloc]initWithPageName:@"ChangePasswordViewController"];
            [self.slideNavigationController pushViewController:VC  animated:YES];
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
