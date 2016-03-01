//
//  DoctorSearchResultViewController.m
//  FindDoctor
//
//  Created by zhuhaoran on 16/3/1.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorSearchResultViewController.h"
#import "DoctorCell.h"
#import "DoctorDetailController.h"
#import "CUDoctorManager.h"
#import "TipHandler+HUD.h"
#import "NSDate+SNExtension.h"
#import "DiseaseSubject.h"
#import "DoctorListModel.h"

@interface DoctorSearchResultViewController ()

@property (nonatomic,strong) DoctorListModel *theListModel;

@end

@implementation DoctorSearchResultViewController

- (id)initWithPageName:(NSString *)pageName listModel:(DoctorListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    _theListModel = listModel;
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
    self.contentTableView.frame = CGRectMake(0, 40*Width_AdaptedFactor, self.contentTableView.frameHeight, self.contentTableView.frameWidth);
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
    static NSString *cellIdentifier = @"DoctorCell";
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellContentView.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    detailVC.doctor = [self.listModel.items objectAtIndexSafely:indexPath.row];
#if !LOCAL
    
    //    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithFormat:[NSDateFormatter dateFormatString]];
    
    [[CUDoctorManager sharedInstance] updateDoctorInfo:detailVC.doctor date:[[[NSDate date] dateAtStartOfDay] timeIntervalSince1970] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            [self.slideNavigationController pushViewController:detailVC animated:YES];
        }
        else {
            [TipHandler showTipOnlyTextWithNsstring:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        }
    }];
#else
    [self.slideNavigationController pushViewController:detailVC animated:YES];
#endif
}

- (void)triggerRefresh
{
    [self.freshControl beginRefreshing];
    [self.loadMoreControl endLoading];
    self.listModel.isLoading = YES;
    __block __weak DoctorSearchResultViewController * blockSelf = self;
    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        blockSelf.listModel.isLoading = NO;
        [blockSelf.freshControl endRefreshing];
        if (!result.hasError)
        {
            // height
            [blockSelf.heightDictOfCells removeAllObjects];
            
            [blockSelf.freshControl refreshLastUpdatedTime:[NSDate date]];
            [blockSelf.contentTableView reloadData];
            
//            if(!result.hasError){
//                if (blockSelf.theListModel.filter.classNumber == 0) {
//                    NSMutableArray *recvList = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"symptomOption"];
//                    NSMutableArray *listSubject = [[NSMutableArray alloc] init];
//                    [listSubject addObject:@"全部"];
//                    [recvList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
//                        NSString *string = [obj valueForKey:@"name"];
//                        [listSubject addObject:string];
//                    }];
//                    blockSelf.diseaseArray = listSubject;
//                    
//                    recvList = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"dateOption"];
//                    listSubject = [[NSMutableArray alloc] init];
//                    [listSubject addObject:@"全部"];
//                    [recvList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop){
//                        NSString *string = [obj valueForKey:@"date"];
//                        [listSubject addObject:string];
//                    }];
//                    blockSelf.timeArray = listSubject;
//                    [blockSelf.dropdownMenu resetMenu];
//                }
//            }
            
            
            // footer
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                ;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
            
        }
        
        // 添加空页面
        if ([blockSelf.listModel.items count] == 0)
        {
            blockSelf.emptyView.hidden = NO;
        }
        else // 隐藏空页面
        {
            blockSelf.emptyView.hidden = YES;
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
