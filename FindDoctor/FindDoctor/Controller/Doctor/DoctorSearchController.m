//
//  SearchViewController.m
//
//
//  Created by yutao on 14-9-22.
//  Copyright (c) 2014年 li na. All rights reserved.
//

#import "DoctorSearchController.h"
#import "UIConstants.h"
#import "SearchTooBar.h"
#import "SearchHistoryHelper.h"

@interface DoctorSearchController ()<UITableViewDataSource,UITableViewDelegate,SearchTooBarDelegate>

@property (nonatomic, strong) SearchTooBar   *searchToolBar;
@property (nonatomic, strong) UITableView    *contentTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString       *currSearchStr;

@end

@implementation DoctorSearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (NSString *)currentCity
{
    return @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchToolBar = [[SearchTooBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.navigationBarHeight)];
    _searchToolBar.placeHolder = @"请输入诊所、医生";
    _searchToolBar.delegate = self;
    _searchToolBar.showCancelButton = YES;
    [self.navigationBar addSubview:_searchToolBar];
    
    [_searchToolBar becomeFirstResponder];
    
    [self initCollectionTableView];
    
    [self loadHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initCollectionTableView
{
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, CGRectGetWidth(self.view.frame), kScreenHeight - kNavigationHeight) style:UITableViewStylePlain];
    _contentTableView.backgroundColor = self.view.backgroundColor;;
    _contentTableView.separatorColor = UIColorFromHex(0xe1e3e6);
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [self.view addSubview:_contentTableView];
    
    _contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)cancelClick
{
    [self backAction];
}

- (void)backActionWithoutAnimation
{
    [self.slideNavigationController popViewControllerAnimated:NO];
}

#pragma mark - SearchBar Delegate

- (void)searchClickWithString:(NSString *)searchStr
{
    if (searchStr.length == 0) {
        return;
    }
    
    self.currSearchStr = searchStr;
    [SearchHistoryHelper saveSearchHistory:searchStr];
    
    if (self.action) {
        self.action(searchStr);
    }
    
    [self backActionWithoutAnimation];
}

- (void)searchStringDidChange:(NSString *)searchStr
{
    if (searchStr.length == 0) {
        [self loadHistory];
    }
    else {
        self.currSearchStr = searchStr;
    }
}

- (void)searchAddressWithCity:(NSString *)city keyword:(NSString *)keyword
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DoctorSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [_dataArray objectAtIndexSafely:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.action) {
        self.action([_dataArray objectAtIndexSafely:indexPath.row]);
    }
    
    [self backActionWithoutAnimation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchToolBar resignFirstResponder];
}

#pragma mark - Search History

- (void)loadHistory
{
    self.dataArray = [NSMutableArray arrayWithArray:[SearchHistoryHelper searchHistoryArray]];
    [_contentTableView reloadData];
}

@end
