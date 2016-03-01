//
//  ABELTableView.m
//  ABELTableViewDemo
//
//  Created by abel on 14-4-28.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import "BATableView.h"
//#import "SystemConstant.h"
#import "UIView+Extension.h"
#import "SNUISystemConstant.h"

@interface BATableView() <BATableViewIndexDelegate>

@property (nonatomic, strong) UILabel * flotageLabel;

@end

@implementation BATableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.tableView];
        
        self.tableViewIndex = [[BATableViewIndex alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 40, (kScreenHeight > 480) ? 33 : 18, 40, 0)];
        self.tableViewIndex.tableViewIndexDelegate = self;
        [self addSubview:self.tableViewIndex];
        
        self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 64 ) / 2,(self.bounds.size.height - 64) / 2,64,64}];
        self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
        self.flotageLabel.hidden = YES;
        self.flotageLabel.textAlignment = NSTextAlignmentCenter;
        self.flotageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.flotageLabel];
    }
    return self;
}

- (void)setDelegate:(id<BATableViewDelegate>)delegate
{
    _delegate = delegate;
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    
    [self reloadView];
}

- (void)reloadData
{
    [self.tableView reloadData];
    
    [self reloadView];
}

- (void)reloadView
{
    [self.tableViewIndex reloadData];
}

#pragma mark -
- (void)tableViewIndex:(BATableViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    NSUInteger selectIndex = [self.delegate tableView:self.tableView sectionForSectionIndexTitle:title atIndex:index];
    if (selectIndex == NSNotFound) {
        return;
    }
    
    //int sections = self.tableView.numberOfSections;
    //if (sections > selectIndex && selectIndex > -1)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.flotageLabel.text = title;
    }
}

- (void)tableViewIndexTouchesBegan:(BATableViewIndex *)tableViewIndex
{
    if (self.shouldShowFlotage) {
        self.flotageLabel.hidden = NO;
    }
}

- (void)tableViewIndexTouchesEnd:(BATableViewIndex *)tableViewIndex
{
    if (self.shouldShowFlotage) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [self.flotageLabel.layer addAnimation:animation forKey:nil];
        
        self.flotageLabel.hidden = YES;
    }
}

- (NSArray *)tableViewIndexTitle:(BATableViewIndex *)tableViewIndex
{
    return [self.delegate sectionIndexTitlesForABELTableView:self];
}
@end
