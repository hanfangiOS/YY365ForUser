//
//  DoctorListController.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SearchResultViewController.h"
#import "DoctorCell.h"
#import "DOPDropDownMenu.h"
#import "DoctorDetailController.h"
#import "CUDoctorManager.h"
#import "TipHandler+HUD.h"
#import "NSDate+SNExtension.h"
#import "NSDateFormatter+SNExtension.h"
#import "DiseaseSubject.h"

#import "SearchResultListModel.h"
#import "CommonManager.h"
#import "OptionList.h"

@interface SearchResultViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (nonatomic,strong) DOPDropDownMenu *dropdownMenu;

@property (nonatomic,strong) SearchResultListModel *listModel;

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *diseaseArray;
@property (nonatomic,strong) NSArray *regionArray;
@property (nonatomic,strong) NSArray *timeArray;

//@property NSInteger classNumber;

@end

@implementation SearchResultViewController

- (id)initWithPageName:(NSString *)pageName listModel:(SearchResultListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    if (self) {
        self.titleArray = @[@"病症", @"地区", @"时间"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找医生";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetDropDownMenuData];
}

- (void)resetDropDownMenuData{
    __weak __block SearchResultViewController *blockSelf = self;
    [[CommonManager sharedInstance] getOptionListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if(!result.hasError){
            NSDictionary *dic = result.parsedModelObject;
            blockSelf.diseaseArray = [dic objectForKey:@"symptomOption"];
            blockSelf.regionArray = [dic objectForKey:@"regionOption"];
            blockSelf.timeArray = [dic objectForKey:@"dateOption"];
            [blockSelf.dropdownMenu reloadData];
        }
        else{
            
        }
    } pageName:self.pageName];
}

- (void)loadContentView
{
    [super loadContentView];
    
    self.dropdownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40*Width_AdaptedFactor];
    self.dropdownMenu.dataSource = self;
    self.dropdownMenu.delegate = self;
    [self.contentView addSubview:self.dropdownMenu];
    
    self.contentTableView.frame = CGRectMake(0, self.dropdownMenu.frameHeight, self.contentTableView.frameWidth, self.contentTableView.frameHeight-self.dropdownMenu.frameHeight);
}

- (void)loadNavigationBar
{
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
    
    DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:self.pageName];
    detailVC.doctor = [self.listModel.items objectAtIndexSafely:indexPath.row];
#if !LOCAL
    [[CUDoctorManager sharedInstance] updateDoctorInfo:detailVC.doctor date:[[[NSDate date] dateAtStartOfDay] timeIntervalSince1970] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            [self.slideNavigationController pushViewController:detailVC animated:YES];
        }
//        else {
//            [TipHandler showTipOnlyTextWithNsstring:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey]];
//        }
    }];
#else
    [self.slideNavigationController pushViewController:detailVC animated:YES];
#endif
}

#pragma mark ------------------ dropdown menu -------------------------
// dropdown menu

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return [self.titleArray count];
}

- (NSString *)menu:(DOPDropDownMenu *)menu initMenuTitleInColum:(NSInteger)column
{
    return self.titleArray[column];
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    NSInteger rows = 0;
    switch (column)
    {
        case 0: rows = [self.diseaseArray count];
            break;
        case 1: rows = [self.regionArray count];
            break;
        case 2: rows = [self.timeArray count];
            break;
        default:
            break;
    }
    return rows;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSString * title = nil;
    switch (indexPath.column)
    {
        case 0:
        {
            SymptomOption *item = [self.diseaseArray objectAtIndexSafely:indexPath.row];
            title = [item name];
        }
            break;
        case 1:
        {
            RegionOption *item = [self.regionArray objectAtIndexSafely:indexPath.row];
            title = [item name];
        }
            break;
        case 2:
        {
            DateOption *item = [self.timeArray objectAtIndexSafely:indexPath.row];
            title = [item date];
        }
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    if (column == 0) {
        SymptomOption *item = [self.diseaseArray objectAtIndexSafely:row];
        return item.symptomSubOptionArray.count == 0 ? -1:item.symptomSubOptionArray.count;
    }
    else{
        return 0;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        SymptomOption *item = [self.diseaseArray objectAtIndexSafely:indexPath.row];
        SymptomSubOption *SubItem = [item.symptomSubOptionArray objectAtIndex:indexPath.item];
        return SubItem.name;
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
        if (indexPath.row == 0)
        {
//            [self.dropdownMenu updateMenuTitle:self.titleArray[indexPath.column] inColumn:indexPath.column];
            [self.dropdownMenu reloadData];
        }
    //    switch (indexPath.column) {
    //        case 0:{
    //            self.listModel.filter.subTypeId = indexPath.row;
    //        }
    //            break;
    //        case 1:{
    //        }
    //            break;
    //        case 2:{
    //            self.listModel.filter.orderDate = [self.timeArray objectAtIndex:indexPath.row];
    //            if (indexPath.row == 0) {
    //                self.listModel.filter.orderDate = @"0";
    //            }
    //        }
    //            break;
    //        default:
    //            break;
    //    }
    //
    // TODO:filter设置
    [self triggerRefresh];
}
- (void)menu:(DOPDropDownMenu *)menu didTappedColumn:(NSInteger)column
{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
