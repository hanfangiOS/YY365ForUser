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
#import "CUUserManager.h"
#import "TipHandler+HUD.h"
#import "AppDelegate.h"
#import "SelectCityVC.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
//    UIView *_logoutView;
    UISwitch *_messageNotificationSwitch;
}

@property (nonatomic, strong) UITableView       * tableView;

@property (nonatomic, strong) UITableViewCell   * cacheCell;//清除缓存那个cell

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self initSubViews];
}

- (void)initSubViews{
//    _logoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 44)];
//    button.center = _logoutView.center;
//    [button addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"退出登录" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor redColor];
//    [_logoutView addSubview:button];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new]; 
    self.tableView.backgroundColor = kCommonBackgroundColor;
    self.tableView.separatorColor = kblueLineColor;
    [self.contentView addSubview:self.tableView];
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
    //    [self addRightButtonItemWithImage:[UIImage imageNamed:@"myAccountBigButtonImage"] action:@selector(edit)];
}

- (void)loginOutAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alert.tag = 1000;
    [alert show];
}

#pragma mark alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            
        }
        else {
            [self postRequestExitAccount];
            [[CUUserManager sharedInstance] clear];
            [self.slideNavigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag == 2000) {
        
        [self clearCache];
        [self.tableView reloadData];
    }
}

- (void)updateSwitch:(UISwitch *)sender {
    if (sender == _messageNotificationSwitch) {
        if (sender.on) {
            NSLog(@"消息通知已经开启");
        }
        else{
            NSLog(@"消息通知已经关闭");
        }
    }
}
#pragma mark tableViewDelegata&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *cellIdentifier = @"MessageNotificationCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            _messageNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [_messageNotificationSwitch addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _messageNotificationSwitch;
            cell.imageView.image = [UIImage imageNamed:@"setting_icon_messageAlert"];
            cell.textLabel.text = @"消息通知";
            cell.detailTextLabel.text = nil;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        static NSString *cellIdentifier = @"LogoutCell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.frame = CGRectMake(0, cell.textLabel.frameY, cell.frameWidth, cell.textLabel.frameHeight);
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
    
    static NSString *cellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"setting_icon_SettingDefaultCity"];
                cell.textLabel.text = @"设置常用城市";
                cell.detailTextLabel.text = @"成都";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"setting_icon_AccountSafety"];
                cell.textLabel.text = @"账号安全";
                cell.detailTextLabel.text = nil;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                self.cacheCell = cell;
                cell.imageView.image = [UIImage imageNamed:@"setting_icon_removeLocalData"];
                cell.textLabel.text = @"清除本地缓存";
                cell.textLabel.textColor = UIColorFromHex(0X007AFF);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self sizeForCache]];
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            if (indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"setting_icon_aboutUyi"];
                cell.textLabel.text = @"关于优医";
                cell.detailTextLabel.text = nil;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                SelectCityVC *VC = [[SelectCityVC alloc]initWithPageName:@"SelectCityVC"];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
            if (indexPath.row == 1) {
                AccountSecurityViewController *VC = [[AccountSecurityViewController alloc]initWithPageName:@"AccountSecurityViewController"];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确认要清除缓存吗"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.delegate = self;
                alert.tag = 2000;
                [alert show];
            }
            
            if(indexPath.row == 1){
                AboutViewController *VC = [[AboutViewController alloc]initWithPageName:@"AboutViewController"];
                [self.slideNavigationController pushViewController:VC animated:YES];
            }
            break;
        case 3:{
            [self loginOutAction];
        }
            
        default:
            break;
    }
}

#pragma mark -------- 缓存相关 ---------
//计算文件大小
- (float)sizeForFilePath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024/1024;
    }
    return 0;
}
//缓存大小
- (float)sizeForCache{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    float folderSize;
    
    if ([fileManager fileExistsAtPath:path]) {
        NSArray * subFiles = [fileManager subpathsAtPath:path];
        for (NSString * fileNmae in subFiles) {
            NSString * fullPath = [path stringByAppendingPathComponent:fileNmae];
            folderSize += [self sizeForFilePath:fullPath];
        }
    }
    
    return folderSize;
}
//移除缓存
- (void)clearCache{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray * subFiles = [fileManager subpathsAtPath:path];
        for (NSString * fileName in subFiles) {
            NSString * fullPath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fullPath error:nil];
        }
    }
}



#pragma mark postRequest

- (void)postRequestExitAccount{

    [[CUUserManager sharedInstance] logoutWithUser:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        [self hideProgressView];
//        if (!result.hasError)
//        {
//            NSNumber * errorCode = [result.responseObject objectForKeySafely:@"errorcode"];
//            if (![errorCode integerValue]) {
//                
//                [[CUUserManager sharedInstance] clear];
//                [self.slideNavigationController popViewControllerAnimated:NO];
//            }else{
//                 [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"message"]];
//            }
//        }else{
//             [TipHandler showTipOnlyTextWithNsstring:@"网络连接失败"];
//        }
        
    } pageName:@"SettingViewController"];    
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
