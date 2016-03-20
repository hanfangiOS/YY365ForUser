//
//  DoctorFameListController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorFameListController.h"
#import "DoctorFameCell.h"
#import "Comment.h"
#import "UIImageView+AFNetworking.h"
#import "BlueDotLabelInDoctorHeaderView.h"
#import "TipHandler+HUD.h"
#import "FlagViewInCommentList.h"
#import "SNListEmptyView.h"

@interface DoctorFameListController ()<SNListEmptyViewDelegate>{
    NSInteger                       _cellHeight;
    UIView                          * _headerView;
    
    BlueDotLabelInDoctorHeaderView  * _view1_label1;
    BlueDotLabelInDoctorHeaderView  * _view1_label2;
    BlueDotLabelInDoctorHeaderView  * _view1_label3;
    BlueDotLabelInDoctorHeaderView  * _view1_label4;
    
//    FlagViewInCommentList           * _view2_flagView;
    
    NSInteger                        _lastID;
}
@property (nonatomic,strong)    DoctorFameListModel  * listModel;


@end

@implementation DoctorFameListController

- (id)initWithPageName:(NSString *)pageName listModel:(DoctorFameListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    if (self) {
        self.listModel = listModel;
        _cellHeight = 0;
    }
    return self;
}

- (void)viewDidLoad {
    self.hasFreshControl = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@ 教授口碑",self.listModel.doctor.name];
    
}

- (void)loadContentView{
    
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat heightForHeader = 0.4 * kScreenHeight;
    
    self.contentTableView.frame = CGRectMake(0
                                             , heightForHeader, self.contentTableView.frame.size.width, self.contentView.frameHeight - heightForHeader);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader)];
    
    [self.contentView addSubview:_headerView];
    
    /*
     * 白色背景View
     */
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader * 0.33)];
    view1.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:view1];
    //头像
    UIImageView * view1_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30,view1.centerY - 24 , 48, 48)];
    [view1_imageView1 setImageWithURL:[NSURL URLWithString:self.listModel.doctor.avatar] placeholderImage:nil];
    view1_imageView1.layer.cornerRadius = 48/2;
    view1_imageView1.clipsToBounds = YES;
    view1_imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [view1 addSubview:view1_imageView1];
    
    //XX人关注
    _view1_label1 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, view1.frameHeight * 0.2, 110, 12) title:@"" contents:@"0" unit:@"人关注" hasDot:YES ];
    //    view1_label1.backgroundColor = [UIColor greenColor];
    [view1 addSubview:_view1_label1];
    
    //诊疗XX次
    _view1_label2 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30, view1.frameHeight * 0.2, 110, 12) title:@"诊疗" contents:@"0" unit:@"次" hasDot:YES ];
    //    view1_label2.backgroundColor = [UIColor greenColor];
    
    [view1 addSubview:_view1_label2];
    
    //服务XX星
    _view1_label3 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, view1.frameHeight - view1.frameHeight * 0.2 - 12, 110, 12) title:@"服务" contents:@"0" unit:@"星" hasDot:YES ];
    //    view1_label3.backgroundColor = [UIColor greenColor];
    
    [view1 addSubview:_view1_label3];
    //积分XXX
    _view1_label4 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30 , view1.frameHeight - view1.frameHeight * 0.2 - 12, 110, 12) title:@"积分" contents:@"0" unit:@"" hasDot:YES ];
    
    [view1 addSubview:_view1_label4];
    /*
     * 自然背景View
     */
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.maxY, kScreenWidth, heightForHeader * 0.65)];
    view2.backgroundColor = [UIColor grayColor];
    [_headerView addSubview:view2];
    //锦旗
    UILabel * view2_label1 = [[UILabel alloc] initWithFrame:CGRectMake(view2.centerX - 20, 10, 40, 20)];
    view2_label1.textColor = [UIColor blueColor];
    view2_label1.text = @"锦旗";
    view2_label1.font = [UIFont systemFontOfSize:16];
    [view2 addSubview:view2_label1];
    
    //一堆旗
//    _view2_flagView = [[FlagViewInCommentList alloc] initWithFrame:CGRectMake(0,10, kScreenWidth, 20)];
    //    [view2 addSubview:_view2_flagView];
    
    
}

- (void)resetData{
    
    if (self.listModel.doctor){
        [_view1_label1 resetTitle:@"" contents:[NSString stringWithFormat:@"%d",self.listModel.doctor.numConcern] unit:@"人关注"];
        
        [_view1_label2 resetTitle:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.numDiag] unit:@"次"];
        
        [_view1_label3 resetTitle:@"服务" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.rate] unit:@"星"];
        
        [_view1_label4 resetTitle:@"积分" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.score] unit:@""];
        
//        _view2_flagView.data = _comment;
    }
    
}

- (UIView *)listEmptyView
{
//    SNListEmptyView * view = [[SNListEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    SNListEmptyView * view = [[SNListEmptyView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.delegate = self;
    return view;
}

- (void)emptyViewClicked
{
    [self triggerRefresh];
}

- (void)triggerRefresh
{
    [self.freshControl beginRefreshing];
    [self.loadMoreControl endLoading];
    self.listModel.isLoading = YES;
    __block __weak DoctorFameListController * blockSelf = self;
    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        blockSelf.listModel = result.parsedModelObject;
        [blockSelf resetData];
        blockSelf.listModel.isLoading = NO;
        [blockSelf.freshControl endRefreshing];
        
        if (!result.hasError)
        {
            // height
            [self.heightDictOfCells removeAllObjects];
            
            [self.freshControl refreshLastUpdatedTime:[NSDate date]];
            [blockSelf.contentTableView reloadData];
            
            // footer
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {            blockSelf.emptyView.hidden = YES;
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

        }
        
    }];
}

//- (void)triggerLoadMore
//{
//    [self.freshControl endRefreshing];
//    self.listModel.isLoading = YES;
//    [self.loadMoreControl beginLoading];
//    __block __weak DoctorFameListController * blockSelf = self;
//    self.listModel.commentFilter.lastID = _lastID;
//    self.listModel.commentFilter.doctorID = self.doctor.doctorId;
//    [self.listModel gotoNextPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        blockSelf.listModel.isLoading = NO;
//        [blockSelf.loadMoreControl endLoading];
//        if (!result.hasError)
//        {
//            [blockSelf.contentTableView reloadData];
//            if ([blockSelf.listModel hasNext])
//            {
//                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
//            }
//            else
//            {
//                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//                ;
//            }
//        }
//        else
//        {
//            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
//            
//        }
//    }];
//}



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
    NSString * CellID = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    DoctorFameCell * cell = [[DoctorFameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
    self.listModel.filter.lastID = cell.data.time;
    _cellHeight = [cell CellHeight];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
