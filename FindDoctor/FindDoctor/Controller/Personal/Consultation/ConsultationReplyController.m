//
//  ConsultationReplyController.m
//  FindDoctor
//
//  Created by chai on 15/9/10.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "ConsultationReplyController.h"
#import "ReplyHeader.h"
#import "ReplyCell.h"
#import "ReplySectionHeader.h"
#import "QuestionCell.h"

@interface ConsultationReplyController () <UITableViewDataSource,UITableViewDelegate>
{
    ReplyHeader *_replyHeader;
    NSMutableArray *_showReplies;
}

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ConsultationReplyController

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
    [self initData];
    self.title = @"咨询回复";
}

- (void)loadTableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.contentView addSubview:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([tableview respondsToSelector:@selector(layoutMargins)]) {
        tableview.layoutMargins = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    if ([tableview respondsToSelector:@selector(separatorInset)]) {
        tableview.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);;
    }
    
    self.tableView = tableview;
    [self loadTableHeader];
}

- (void)loadTableHeader
{
    _replyHeader = [[ReplyHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75*kScreenRatio)];
    [_replyHeader setAccount];
    self.tableView.tableHeaderView = _replyHeader;
}

- (void)initData
{
    _showReplies = [NSMutableArray new];
    
    for (int i=0; i<10; i++) {
        ReplyCellFrame *cellFrame = [[ReplyCellFrame alloc] init];
        cellFrame.replyEntity = nil;
        [_showReplies addObject:cellFrame];
    }
    [self.tableView reloadData];
}

#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _showReplies.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentifier = @"tableHeader";
    ReplySectionHeader *sectionHeader = (ReplySectionHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (sectionHeader == nil) {
        sectionHeader = [[ReplySectionHeader alloc] initWithReuseIdentifier:headerIdentifier];
    }
    [sectionHeader setTitle:@"咨询内容"];
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [QuestionCell contentHeight:@"最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧"];
    }
    return [_showReplies[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"replyCell";
    static NSString *questionIdentifier = @"questionCell";
    if (indexPath.section==0) {
        QuestionCell *questionCell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:questionIdentifier];
        if (questionCell == nil) {
            questionCell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:questionIdentifier];
        }
        [questionCell setQuestion:@"最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧最近有点不太舒服吧"];
        return questionCell;
    }else{
        ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.cellFrame = _showReplies[indexPath.row];
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
