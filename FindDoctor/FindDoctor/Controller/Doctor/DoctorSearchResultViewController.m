//
//  DoctorSearchResultViewController.m
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/1.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorSearchResultViewController.h"
#import "Doctor.h"
#import "DoctorCell.h"
#import "Clinic.h"
#import "MyClinicCell.h"
#import "ClinicMainViewController.h"
#import "DoctorDetailController.h"
#import "CUDoctorManager.h"
#import "TipHandler+HUD.h"
#import "NSDate+SNExtension.h"
#import "DiseaseSubject.h"
#import "DoctorListModel.h"

@interface DoctorSearchResultViewController ()

@property (nonatomic,strong) DoctorListModel * listModel;

@end

@implementation DoctorSearchResultViewController

- (id)initWithPageName:(NSString *)pageName listModel:(DoctorListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    [super loadContentView];
    self.title = @"搜索结果";
    self.contentTableView.frame = self.contentView.bounds;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DoctorCell defaultHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.listModel.items objectAtIndexSafely:indexPath.row];
    if ([item isKindOfClass:[Doctor class]]){
        static NSString *cellIdentifier = @"DoctorCell";
        
        DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.cellContentView.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
        return cell;
    }
    if ([item isKindOfClass:[Clinic class]]) {
        static NSString *cellIdentifier = @"MyClinicCell";
        
        MyClinicCell *cell = (MyClinicCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell =  [[MyClinicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.cellContentView.data = self.listModel.items[indexPath.row];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id item = [self.listModel.items objectAtIndexSafely:indexPath.row];
    if ([item isKindOfClass:[Doctor class]]){
        DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
        detailVC.doctor = item;
        [[CUDoctorManager sharedInstance] updateDoctorInfo:detailVC.doctor date:[[[NSDate date] dateAtStartOfDay] timeIntervalSince1970] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
            if (!result.hasError) {
                [self.slideNavigationController pushViewController:detailVC animated:YES];
            }
            else {
                [TipHandler showTipOnlyTextWithNsstring:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey]];
            }
        }];
    }
    if ([item isKindOfClass:[Clinic class]]){
        ClinicMainViewController *detailVC = [[ClinicMainViewController alloc] initWithPageName:@"DoctorDetailController"];
        detailVC.clinic = [self.listModel.items objectAtIndexSafely:indexPath.row];
        [self.slideNavigationController pushViewController:detailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
