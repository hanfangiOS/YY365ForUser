//
//  NewsListController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "NewsListController.h"
#import "NewsListModel.h"
#import "NewsListCell.h"
#import "TipMessageData.h"

@interface NewsListController (){
    NSInteger _cellHeight;
}

@property (nonatomic,strong)    NewsListModel  * listModel;

@end

@implementation NewsListController

- (id)initWithPageName:(NSString *)pageName listModel:(NewsListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    _cellHeight = 0;
    if (self) {
        
    }
    
    return self;
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息列表";
}

- (void)loadContentView{
    self.contentTableView.backgroundColor = kCommonBackgroundColor;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listModel.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TipMessageData * data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    NSString * str = data.title;
    CGSize size = [self sizeForString:str font:[UIFont systemFontOfSize:16] limitSize:CGSizeMake(kScreenWidth - (15 + 15 + 16 + 24), 0)];
    return (size.height + 15 + 15);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"NewsListCell";
    NewsListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8.5)];
    headerView.backgroundColor = kCommonBackgroundColor;
    return headerView;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 8.5;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize{
    
    CGFloat width = limitSize.width;
    CGFloat height = limitSize.height;
    if (!width) {
        width = CGFLOAT_MAX;
    }
    if (!height) {
        height = CGFLOAT_MAX;
    }
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
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
