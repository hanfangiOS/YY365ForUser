//
//  MyCommentViewController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentCell.h"
#import "TotalMoneyView.h"
#import "MyCommentListModel.h"

@interface MyCommentViewController (){
    NSInteger             _cellHeight;
}
@property (nonatomic,strong)    MyCommentListModel  * listModel;

@end

@implementation MyCommentViewController

- (id)initWithPageName:(NSString *)pageName listModel:(MyCommentListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    self.listModel = listModel;
    _cellHeight = 0;
    self.listModel.filter.num = 50;
    if (self) {
  
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initSubViews];
    self.title = @"我的点评";
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - 返回事件
- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark - TableView代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.listModel.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_cellHeight) {
        return 1;
    }
    return _cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellID = [NSString stringWithFormat:@"Cell%ld",(NSInteger)indexPath.row];
    MyCommentCell * cell = [[MyCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Comment * c = [self.listModel.items objectAtIndexSafely:indexPath.row];
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    _cellHeight = [cell CellHeight];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
