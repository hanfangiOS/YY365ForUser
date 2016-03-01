//
//  ConsultationListController.m
//  FindDoctor
//
//  Created by chai on 15/9/7.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ConsultationListController.h"
#import "ConsultationCell.h"
#import "ConsultationReplyController.h"

#define kFooterHeight 44.f

@interface ConsultationListController ()
{
    NSMutableArray *contentCelLFrames;
}

@end

@implementation ConsultationListController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadContentView
{
    [super loadContentView];
    [self loadTableView];
    [self loadButton];
    self.title = @"咨询记录";
    contentCelLFrames = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        ConsultationCellFrame *cellFrame = [[ConsultationCellFrame alloc] init];
        cellFrame.consultationEntity = nil;
        [contentCelLFrames addObject:cellFrame];
    }
    [self.contentTableView reloadData];
}

- (void)loadTableView
{
    CGRect tableFrame = self.contentView.bounds;
    tableFrame.size.height -= kFooterHeight;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = tableFrame;
    tableView.backgroundColor = UIColorFromHex(Color_Hex_ContentViewBackground);;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = UIColorFromHex(Color_Hex_Tableview_Separator);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.contentView addSubview:tableView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contentTableView = tableView;
}

- (void)loadButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, CGRectGetMaxY(self.contentTableView.frame)+5, kScreenWidth-10*2, kFooterHeight-10);
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.backgroundColor = kGreenColor;
    [button setTitle:@"我要咨询" forState:UIControlStateNormal];
    [self.contentView addSubview:button];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contentCelLFrames count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [contentCelLFrames[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *consultationCell = @"consultationCell";
    ConsultationCell *cell = (ConsultationCell *)[tableView dequeueReusableCellWithIdentifier:consultationCell];
    if (cell == nil) {
        cell = [[ConsultationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:consultationCell];
    }
    cell.cellFrame = contentCelLFrames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultationReplyController *consultationreplyVC = [[ConsultationReplyController alloc] init];
    [self.slideNavigationController pushViewController:consultationreplyVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
