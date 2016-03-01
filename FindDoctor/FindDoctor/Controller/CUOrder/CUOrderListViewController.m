//
//  CUOrderListViewController.m
//  CollegeUnion
//
//  Created by li na on 15/3/4.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderListViewController.h"
#import "CUOrderDetailViewController.h"
#import "OrderCell.h"
#import "UIConstants.h"
//#import "SendCommentController.h"
#import "CUOrder.h"
#import "TipHandler+HUD.h"
#import "CUOrderManager.h"
#import "CUUserManager.h"
#import "CUOrderListModel.h"
#import "CUBlankView.h"
#import "MobClickConstants.h"
#import "MobClick.h"

@interface CUOrderListViewController ()

@property (nonatomic,strong) CUOrderListModel * listModel;

@end

@implementation CUOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.listModel.isLoading && self.listModel.items.count == 0) {
        [CUBlankView hideAllBlankViewForView:self.contentView];
        [self initalizeLoading];
    }
}

- (void)loadContentView
{
    [super loadContentView];
    
    // in tab
    if (self.customTabBarItem) {
        self.contentView.frame = CGRectMake(0, self.navigationBarHeight + kTopTabBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight - kTopTabBarHeight);
        
        self.contentTableView.frame = self.contentView.bounds;
    }
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundSuccess:) name:kNotification_OrderRefundSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSuccess:) name:kNotification_OrderCancelSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:kNotification_OrderPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentSuccess:) name:kNotification_OrderCommentSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSubmmitOrder:) name:kNotification_OrderSubmitSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    
}

#pragma -mark ---------------UITableViewDataSource -------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellContentView.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    
    return cell;
}

#pragma -mark ---------------UITableViewDelegate -------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderCell defaultHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CUOrder *order = [self.listModel.items objectAtIndexSafely:indexPath.row];
    
    CUOrderDetailViewController *detailVC = [[CUOrderDetailViewController alloc] initWithPageName:@"CUOrderDetailViewController" order:order];
    [self.slideNavigationController pushViewController:detailVC animated:YES];
}

#pragma mark - OrderCell Delegate

- (void)didClickToPay:(id)order
{
    CUOrderDetailViewController *detailVC = [[CUOrderDetailViewController alloc] initWithPageName:@"CUOrderDetailViewController" order:order];
    [self.slideNavigationController pushViewController:detailVC animated:YES];
}

- (void)didClickToComment:(id)order
{
    // 评论
//    SendCommentController *sendVC = [[SendCommentController alloc] init];
//    sendVC.order = order;
//    [self.slideNavigationController pushViewController:sendVC animated:YES];
//    
//    __weak typeof(self) weakSelf = self;
//    sendVC.action = ^(CUOrder *order) {
//        [weakSelf.contentTableView reloadData];
//    };
}

#pragma mark - Private Action


#pragma mark - Notification Handle

- (void)refundSuccess:(NSNotification *)notice
{
    CUOrder *order = [notice object];
    NSInteger index = [self.listModel.items indexOfObject:order];
    if (index != NSNotFound) {
        CUOrder *currentOrder = [self.listModel.items objectAtIndexSafely:index];
        currentOrder.orderStatus = order.orderStatus;
        [self.contentTableView reloadData];
    }
}

- (void)cancelSuccess:(NSNotification *)notice
{
    CUOrder *order = [notice object];
    NSInteger index = [self.listModel.items indexOfObject:order];
    if (index != NSNotFound) {
        CUOrder *currentOrder = [self.listModel.items objectAtIndexSafely:index];
        currentOrder.orderStatus = order.orderStatus;
        
        [self.contentTableView reloadData];
    }
}

- (void)paySuccess:(NSNotification *)notice
{
    CUOrder *order = [notice object];
    NSInteger index = [self.listModel.items indexOfObject:order];
    if (index != NSNotFound) {
        CUOrder *currentOrder = [self.listModel.items objectAtIndexSafely:index];
        currentOrder.orderStatus = order.orderStatus;
        [self.contentTableView reloadData];
    }
}

- (void)commentSuccess:(NSNotification *)notice
{
    CUOrder *order = [notice object];
    NSInteger index = [self.listModel.items indexOfObject:order];
    if (index != NSNotFound) {
        CUOrder *currentOrder = [self.listModel.items objectAtIndexSafely:index];
        currentOrder.isComment = order.isComment;
        
        [self.contentTableView reloadData];
    }
}

- (void)didSubmmitOrder:(NSNotification *)notice
{
    CUOrder *order = [notice object];
    if ([order isKindOfClass:[CUOrder class]]) {
        [self.listModel.items insertObject:order atIndex:0];
        
        [self.contentTableView reloadData];
    }
}

@end
