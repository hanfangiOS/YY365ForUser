//
//  DoctorPraiseController.m
//  FindDoctor
//
//  Created by chai on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorPraiseController.h"
#import "DoctorPraiseHeaderView.h"
#import "DoctorPraiseCell.h"
#import "DoctorEvaluateController.h"

@interface DoctorPraiseController () <UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, weak) UITableView *contentTable;

@end

@implementation DoctorPraiseController

- (void)viewdidload
{
    [super viewDidLoad];
}


#pragma mark - load content view
- (void)loadContentView
{
    self.title = [NSString stringWithFormat:@"%@医生 口碑",self.doctor.name];
    [self loadContentTableView];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentTableView
{
    CGRect tableFrame = self.view.bounds;
    tableFrame.origin.y += kNavigationHeight;
    tableFrame.size.height -= kNavigationHeight;
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.frame = tableFrame;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    if ([tableview respondsToSelector:@selector(separatorInset)]) {
        tableview.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    if ([tableview respondsToSelector:@selector(layoutMargins)]) {
        tableview.layoutMargins = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor clearColor];
    tableview.tableFooterView = baseView;
    
    self.contentTable = tableview;
    
    [self loadTableHeaderView];
}

- (void)loadTableHeaderView
{
    DoctorPraiseHeaderView *headerView = [[DoctorPraiseHeaderView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,330}];
    self.doctor.rate = 3.5;
    headerView.doctor = self.doctor;
    self.contentTable.tableHeaderView = headerView;
}

#pragma mark - uitableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PraiseCell";
    DoctorPraiseCell *praisecell = (DoctorPraiseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (praisecell == nil) {
        praisecell = [[DoctorPraiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return praisecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.slideNavigationController pushViewController:[DoctorEvaluateController new] animated:YES];
}

@end
