//
//  AboutViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "AboutViewController.h"
#import "JSONKit.h"
#import "TipHandler+HUD.h"
#import "CUPlatFormManager.h"
#import "UserProtocolController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIView *headerView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel     *versionLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
}

- (void)loadContentView {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 87)/2, 20, 101, 87)];
    imageView.image = [UIImage imageNamed:@"about_uyi365@2x"];
    imageView.contentMode = 1;
    
    _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.maxY, kScreenWidth, 18)];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.font = [UIFont systemFontOfSize:17];
    _versionLabel.textColor = kBlueTextColor;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@" V %@",ver];
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _versionLabel.maxY +20)];
    headerView.layer.contents = (id)[UIImage imageNamed:@"about_background"].CGImage;
    [headerView addSubview:imageView];
    [headerView addSubview:_versionLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCommonBackgroundColor;
    self.tableView.separatorColor = kblueLineColor;
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [UIView new];
    [self.contentView addSubview:self.tableView];
}

#pragma mark tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AboutCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"about_icon_checkUpdate"];
            cell.textLabel.text = @"检查更新";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"about_icon_userProtocol"];
            cell.textLabel.text = @"用户协议";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"about_icon_goodRemark"];
            cell.textLabel.text = @"为我的方便点赞";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self postRequestVersionCheck];
        }
            break;
        case 1:
        {
            UserProtocolController * VC = [[UserProtocolController alloc] initWithPageName:@"UserProtocolController"];
            [self.slideNavigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            NSString * str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1091982091"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
            
        default:
            break;
    }
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark --------- 检查更新 ---------
//版本检查
- (void)postRequestVersionCheck{
    
    NSURL* url = [NSURL URLWithString:@"http://www.uyi365.com/baseFrame/base/g_VersionCheck.jmm?from=APP_IOS_USER"];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    postRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [postRequest setHTTPMethod:@"GET"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    __block __weak typeof(self) weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary * dataDict = [dict dictionaryForKeySafely:@"data"];
                NSString * appVersion = [dataDict stringForKeySafely:@"name"];
                NSInteger forceupdate = [[dataDict objectForKeySafely:@"forceupdate"] integerValue];
                NSString * message = [dataDict stringForKeySafely:@"message"];
                //必要更新
                if (forceupdate == 1) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                    alert.delegate = self;
                    [alert show];
                    
                }
                //非必要更新
                else{
                    if([weakSelf checkIfNeedUpdateWithAppVersion:appVersion]){
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
                        alert.delegate = self;
                        [alert show];
                    }else{
                        [TipHandler showTipOnlyTextWithNsstring:@"已经是最新版本"];
                    }
                    
                }
            }else{
                return ;
            }
        });
    }];
}

//比较版本号，检查是否更新
- (BOOL)checkIfNeedUpdateWithAppVersion : (NSString *)appVersion{
    NSInteger oldVer =  [CUPlatFormManager appVersionNumInBundle];
    NSInteger newVer =  [CUPlatFormManager changeVersionFromStringToInt:appVersion];
    if (newVer > oldVer) {
        return YES;
    }
    return NO;
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
    }
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1091982091"]];
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
