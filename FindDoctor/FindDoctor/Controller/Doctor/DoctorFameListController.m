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

@interface DoctorFameListController (){
    NSInteger                       _cellHeight;
    UIView                          * _headerView;
    Comment                         * _comment;
    
    BlueDotLabelInDoctorHeaderView  * _view1_label1;
    BlueDotLabelInDoctorHeaderView  * _view1_label2;
    BlueDotLabelInDoctorHeaderView  * _view1_label3;
    BlueDotLabelInDoctorHeaderView  * _view1_label4;
    
    UIImageView                     * _view2_imageView1;
    UILabel                         * _view2_label2;
    
    UIImageView                     * _view2_imageView2;
    UILabel                         * _view2_label3;
    
    UIImageView                     * _view2_imageView3;
    UILabel                         * _view2_label4;
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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _comment = [[Comment alloc] init];
    self.listModel.filter.doctorID = self.doctor.doctorId;
    
    self.title = [NSString stringWithFormat:@"%@ 教授口碑",self.doctor.name];

}

- (void)loadContentView{
    
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat heightForHeader = 0.4 * kScreenHeight;
    
    self.contentTableView.frameY = heightForHeader;
    
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
    [view1_imageView1 setImageWithURL:[NSURL URLWithString:self.doctor.avatar] placeholderImage:nil];
    view1_imageView1.layer.cornerRadius = 48/2;
    view1_imageView1.clipsToBounds = YES;
    view1_imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [view1 addSubview:view1_imageView1];
    
    //XX人关注
    _view1_label1 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, 20, 110, 12) title:@"" contents:@"0" unit:@"人关注" hasDot:YES ];
//    view1_label1.backgroundColor = [UIColor greenColor];
    [view1 addSubview:_view1_label1];
    
    //诊疗XX次
    _view1_label2 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30, 20, 110, 12) title:@"诊疗" contents:@"0" unit:@"次" hasDot:YES ];
//    view1_label2.backgroundColor = [UIColor greenColor];

    [view1 addSubview:_view1_label2];
    
    //服务XX星
    _view1_label3 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 40, heightForHeader * 0.3 - 20 - 12, 110, 12) title:@"服务" contents:@"0" unit:@"星" hasDot:YES ];
//    view1_label3.backgroundColor = [UIColor greenColor];

    [view1 addSubview:_view1_label3];
    //积分XXX
    _view1_label4 = [[BlueDotLabelInDoctorHeaderView alloc] initWithFrame:CGRectMake(kScreenWidth - 90 - 30 , heightForHeader * 0.3 - 20 - 12, 110, 12) title:@"积分" contents:@"0" unit:@"" hasDot:YES ];

//    view1_label4.backgroundColor = [UIColor greenColor];

    [view1 addSubview:_view1_label4];
    /*
     * 自然背景View
     */
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.maxY, kScreenWidth, heightForHeader * 0.7)];
    view2.backgroundColor = [UIColor grayColor];
     [_headerView addSubview:view2];
    //锦旗
    UILabel * view2_label1 = [[UILabel alloc] initWithFrame:CGRectMake(view2.centerX - 20, 10, 40, 20)];
    view2_label1.textColor = [UIColor blueColor];
    view2_label1.text = @"锦旗";
    view2_label1.font = [UIFont systemFontOfSize:16];
    [view2 addSubview:view2_label1];
    
    float WHRadio = (float) 131/199;
    CGFloat flagWidth = 80;
    CGFloat flagHeight = flagWidth/WHRadio;
    
    CGFloat spacing = (kScreenWidth - flagWidth * 3)/4;
    //第一面旗
    _view2_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing,view2_label1.maxY + 25, flagWidth, flagHeight)];
    _view2_imageView1.image = [UIImage imageNamed:@"good.png"];
    
    _view2_label2 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10 - 8, - 10, 20, 20)];
    _view2_label2.backgroundColor = [UIColor orangeColor];
    _view2_label2.textAlignment = NSTextAlignmentCenter;
    _view2_label2.text = @"0";
    _view2_label2.textColor = [UIColor whiteColor];
    _view2_label2.font = [UIFont systemFontOfSize:11];
    _view2_label2.layer.cornerRadius = _view2_label2.frame.size.width/2;
    _view2_label2.clipsToBounds = YES;
    [_view2_imageView1 addSubview:_view2_label2];
    
    [view2 addSubview:_view2_imageView1];
    //第二面旗
    _view2_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing *2 + flagWidth,view2_label1.maxY + 25, flagWidth, flagHeight)];
    _view2_imageView2.image = [UIImage imageNamed:@"clever.png"];

    _view2_label3 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10 - 8, - 10, 20, 20)];
    _view2_label3.backgroundColor = [UIColor orangeColor];
    _view2_label3.textAlignment = NSTextAlignmentCenter;
    _view2_label3.text = @"0";
    _view2_label3.textColor = [UIColor whiteColor];
    _view2_label3.font = [UIFont systemFontOfSize:11];
    _view2_label3.layer.cornerRadius = _view2_label3.frame.size.width/2;
    _view2_label3.clipsToBounds = YES;
    [_view2_imageView2 addSubview:_view2_label3];
    
    [view2 addSubview:_view2_imageView2];
    //第三面旗
    _view2_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing * 3 + flagWidth * 2,view2_label1.maxY + 25, flagWidth, flagHeight)];
    _view2_imageView3.image = [UIImage imageNamed:@"nice.png"];
    _view2_label4 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10 - 8, - 10, 20, 20)];
    _view2_label4.backgroundColor = [UIColor orangeColor];
    _view2_label4.textAlignment = NSTextAlignmentCenter;
    _view2_label4.text = @"0";
    _view2_label4.textColor = [UIColor whiteColor];
    _view2_label4.font = [UIFont systemFontOfSize:11];
    _view2_label4.layer.cornerRadius = _view2_label4.frame.size.width/2;
    _view2_label4.clipsToBounds = YES;
    [_view2_imageView3 addSubview:_view2_label4];
    
    [view2 addSubview:_view2_imageView3];
    
}

- (void)resetData{
    
    if (self.listModel.items.count != 0) {
        _comment = [self.listModel.items objectAtIndexSafely:0];
    }
    
    [_view1_label1 resetTitle:@"" contents:[NSString stringWithFormat:@"%ld",_comment.totalConern] unit:@"人关注"];
    
    [_view1_label2 resetTitle:@"诊疗" contents:[NSString stringWithFormat:@"%ld",_comment.totalDiagnosis] unit:@"次"];
    
    [_view1_label3 resetTitle:@"服务" contents:[NSString stringWithFormat:@"%ld",_comment.averageStar] unit:@"星"];
    
    [_view1_label4 resetTitle:@"积分" contents:[NSString stringWithFormat:@"%ld",_comment.totalScore] unit:@""];
    
    NSString * url1 = @"";
    NSInteger x1 ;
    if (_comment.flagList.count > 0) {
        url1 = [[_comment.flagList objectAtIndexSafely:0] valueForKey:@"icon"];
        x1 =   [[[_comment.flagList objectAtIndexSafely:0] valueForKey:@"num"] integerValue];
        [_view2_imageView1 setImageWithURL:[NSURL URLWithString:url1]];
        _view2_label2.text = [NSString stringWithFormat:@"%ld",x1];
    }
    
    NSString * url2 = @"";
    NSInteger x2;
    if (_comment.flagList.count > 1) {
        url2 = [[_comment.flagList objectAtIndexSafely:1] valueForKey:@"icon"];
        x2 =   [[[_comment.flagList objectAtIndexSafely:1] valueForKey:@"num"] integerValue];
        [_view2_imageView2 setImageWithURL:[NSURL URLWithString:url2]];
        _view2_label3.text = [NSString stringWithFormat:@"%ld",x2];
    }
    
    NSString * url3 = @"";
    NSInteger x3;
    if (_comment.flagList.count > 2) {
        url3 = [[_comment.flagList objectAtIndexSafely:2] valueForKey:@"icon"];
        x3 =   [[[_comment.flagList objectAtIndexSafely:2] valueForKey:@"num"] integerValue];
        [_view2_imageView3 setImageWithURL:[NSURL URLWithString:url3]];
        _view2_label4.text = [NSString stringWithFormat:@"%ld",x3];
    }
}

- (void)triggerRefresh
{
    [self.freshControl beginRefreshing];
    [self.loadMoreControl endLoading];
    self.listModel.isLoading = YES;
    __block __weak CUListViewController * blockSelf = self;
    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [self resetData];
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
            blockSelf.emptyView.hidden = YES;
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
    NSString * CellID = [NSString stringWithFormat:@"Cell%ld",(NSInteger)indexPath.row];
    DoctorFameCell * cell = [[DoctorFameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.listModel.items > 0) {
        Comment * comment = [[Comment alloc] init];
        comment = [self.listModel.items objectAtIndexSafely:0];
        if (comment.remarkList.count > 0) {
            RemarkListInfo * remarkListInfo = [[RemarkListInfo alloc] init];
            remarkListInfo = [comment.remarkList objectAtIndexSafely:indexPath.row];
            cell.data = remarkListInfo;
            _cellHeight = [cell CellHeight];
        }
    }
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
