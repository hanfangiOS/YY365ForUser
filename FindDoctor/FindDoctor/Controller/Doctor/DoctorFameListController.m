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
#import "FlagView.h"
#import "SNListEmptyView.h"
#import "TitleView.h"

@interface DoctorFameListController ()<SNListEmptyViewDelegate>{
    NSInteger                       _cellHeight;
    UIView                          * _headerView;
    
    BlueDotLabelInDoctorHeaderView  * _view1_label1;
    BlueDotLabelInDoctorHeaderView  * _view1_label2;
    BlueDotLabelInDoctorHeaderView  * _view1_label3;
    BlueDotLabelInDoctorHeaderView  * _view1_label4;
    
    UIView                          * _view2;
    FlagView                        * _view2_flagView;

    NSInteger                        _lastID;
    
    UILabel                         * _emptyLabel;
    UILabel                         * _emptyLabelForList;
}



@end

@implementation DoctorFameListController
@dynamic listModel;

- (id)initWithPageName:(NSString *)pageName listModel:(DoctorFameListModel *)listModel
{
    self = [super initWithPageName:pageName listModel:listModel];
    if (self) {
        self.listModel = listModel;
        return self;
    }
    return nil;
}

- (void)setShouldFreshControl{
    self.hasFreshControl = NO;
}

- (void)viewDidLoad {
    self.title = [NSString stringWithFormat:@"%@ 教授口碑",self.listModel.doctor.name];

    [super viewDidLoad];
    _cellHeight = 0;
}

- (void)loadContentView{
    
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGFloat heightForHeader = 0.4 * 640;
    
    //评论
    TitleView * commentTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, heightForHeader, kScreenWidth, 14) title:@"评论"];
    self.contentTableView.tableHeaderView = commentTitle;
    
    self.contentTableView.frame = CGRectMake(0, heightForHeader, self.contentTableView.frame.size.width, self.contentView.frameHeight - heightForHeader);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader)];
    
    [self.contentView addSubview:_headerView];
    
    /*
     * 白色背景View
     */
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader * 0.3)];
    view1.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:view1];
    //头像
    UIImageView * view1_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30,view1.centerY - 24 , 48, 48)];
    [view1_imageView1 setImageWithURL:[NSURL URLWithString:self.listModel.doctor.avatar] placeholderImage:[UIImage imageNamed:@"temp_icon_doctor"]];
    view1_imageView1.layer.cornerRadius = 48/2;
    view1_imageView1.clipsToBounds = YES;
    view1_imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [view1 addSubview:view1_imageView1];
    
    //XX人关注
    _view1_label1 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, view1.frameHeight * 0.2 + 5, 110, 12) title:@"关注" contents:@"0" unit:@"人" hasDot:YES ];
    [view1 addSubview:_view1_label1];
    
    //诊疗XX次
    _view1_label2 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30, view1.frameHeight * 0.2 + 5, 110, 12) title:@"诊疗" contents:@"0" unit:@"次" hasDot:YES ];
    [view1 addSubview:_view1_label2];
    
    //服务XX星
    _view1_label3 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, view1.frameHeight - view1.frameHeight * 0.2 - 12 -5, 110, 12) title:@"服务" contents:@"0" unit:@"星" hasDot:YES ];
    [view1 addSubview:_view1_label3];
    //积分XXX
    _view1_label4 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30 , view1.frameHeight - view1.frameHeight * 0.2 - 12 -5, 110, 12) title:@"积分" contents:@"0" unit:@"" hasDot:YES ];
    [view1 addSubview:_view1_label4];
    /*
     * 自然背景View
     */
     _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.maxY, kScreenWidth, heightForHeader * 0.65)];
//    view2.backgroundColor = [UIColor grayColor];
    [_headerView addSubview:_view2];
    //锦旗
    TitleView * flagTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 14) title:@"锦旗"];
    [_view2 addSubview:flagTitle];
    
    //一堆旗
    _view2_flagView = [[FlagView alloc] initWithFrame:CGRectMake(0,flagTitle.maxY, kScreenWidth, 20)];
    [_view2 addSubview:_view2_flagView];
    
//    暂无锦旗
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_view2.frameHeight - 24)/2 , kScreenWidth, _view2.frameHeight * 0.35)];
    _emptyLabel.text = @"暂无锦旗";
    _emptyLabel.font = [UIFont systemFontOfSize:12];
    _emptyLabel.textColor = UIColorFromHex(0x999999);
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.hidden = YES;
    [_view2 addSubview:_emptyLabel];
    
    self.emptyView.textLabel.text = @"暂无评论";
    self.emptyView.textLabel.frameY = self.contentTableView.frameHeight*0.5 + self.contentTableView.frameY;
    self.emptyView.userInteractionEnabled = NO;
    
}

- (void)resetData{
    if (self.listModel.doctor){
        [_view1_label1 setTitle:@"关注" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.numConcern] unit:@"人"];
        
        [_view1_label2 setTitle:@"诊疗" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.numDiag] unit:@"次"];
        
        [_view1_label3 setTitle:@"服务" contents:[NSString stringWithFormat:@"%.1lf",self.listModel.doctor.rate] unit:@"星"];
        
        [_view1_label4 setTitle:@"积分" contents:[NSString stringWithFormat:@"%ld",(long)self.listModel.doctor.score] unit:@""];
        
        if (self.listModel.doctor.flagList.count > 0) {
            _view2_flagView.data = self.listModel.doctor;
            [_view2_flagView setMark];
        }else{
            _view2.frameHeight = 80;
         
            _headerView.frameHeight = 0.4 * 640 * 0.3 + _view2.frameHeight;
            
            CGRect rect1 = _emptyLabel.frame;
            _emptyLabel.frame = CGRectMake(0,(_view2.frameHeight - rect1.size.height)/2 + 12, rect1.size.width, rect1.size.height);
            _emptyLabel.hidden = NO;
//
            
            CGRect rect2 = self.contentTableView.frame;
            self.contentTableView.frame = CGRectMake(rect2.origin.x, _headerView.maxY, rect2.size.width, kScreenHeight - _headerView.frameHeight);
        }
        
        if (!self.listModel.doctor.remarkList.count) {
           [self.contentTableView addSubview:_emptyLabelForList];

        }
    }
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
    self.listModel.filter.lastID = 0;
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
            {
                blockSelf.emptyView.hidden = YES;
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

- (void)triggerLoadMore
{
    [self.freshControl endRefreshing];
    self.listModel.isLoading = YES;
    [self.loadMoreControl beginLoading];
    __block __weak DoctorFameListController * blockSelf = self;
    
    for (int  i = 0; i < self.listModel.items.count; i++) {
        RemarkListInfo *item = [self.listModel.items objectAtIndex:i];
        if (item.time > _lastID) {
            _lastID = item.time;
        }
    }
    
    self.listModel.filter.lastID = _lastID;
//    self.listModel.filter.doctor.doctorId = self.doctor.doctorId;
    [self.listModel gotoNextPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        blockSelf.listModel.isLoading = NO;
        [blockSelf.loadMoreControl endLoading];
        if (!result.hasError)
        {
            [blockSelf.contentTableView reloadData];
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                ;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
            
        }
    }];
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
    NSString * CellID = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    DoctorFameCell * cell = [[DoctorFameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];

//    self.listModel.filter.lastID = cell.data.time;
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
