//
//  DoctorFameListController.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/15.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DoctorFameListController.h"
#import "DoctorFameListModel.h"
#import "DoctorFameCell.h"
#import "Comment.h"

@interface DoctorFameListController (){
    NSInteger             _cellHeight;
    UIView              * _headerView;
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
        self.listModel.filter.doctorID = self.doctor.doctorId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@ 教授口碑",self.doctor];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)loadContentView{
    
    CGFloat heightForHeader = 0.5 * kScreenHeight;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader)];
    
    [self.contentView addSubview:_headerView];
    
    /*
     * 白色背景View
     */
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightForHeader * 0.3)];
    [_headerView addSubview:view1];
    //头像
    UIImageView * view1_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(40,view1.centerY - 40 , 70, 70)];
    [view1 addSubview:view1_imageView1];
    
    NSString * pointName = @"";
    
    //XX人关注
    UIImageView * view1_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 80, 20, 5, 20)];
    view1_imageView2.image = [UIImage imageNamed:pointName];
    UILabel * view1_label1 = [[UILabel alloc] initWithFrame:CGRectMake(view1_imageView2.maxX, 20, 80, 20)];
    [view1 addSubview:view1_imageView2];
    [view1 addSubview:view1_label1];
    //诊疗XX次
    UIImageView * view1_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 80 - 5 , 20, 5, 20)];
    view1_imageView3.image = [UIImage imageNamed:pointName];
    UILabel * view1_label2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 80, 20, 80, 20)];
    [view1 addSubview:view1_imageView3];
    [view1 addSubview:view1_label2];
    //服务XX星
    UIImageView * view1_imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(view1_imageView1.maxX + 80, heightForHeader * 0.3 - 20 - 20 , 5, 20)];
    view1_imageView4.image = [UIImage imageNamed:pointName];
    UILabel * view1_label3 = [[UILabel alloc] initWithFrame:CGRectMake(view1_imageView4.maxX, heightForHeader * 0.3 - 20 - 20, 80, 20)];
    [view1 addSubview:view1_imageView4];
    [view1 addSubview:view1_label3];
    //积分XXX
    UIImageView * view1_imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 80 - 5, heightForHeader * 0.3 - 20 - 20, 5, 20)];
    view1_imageView5.image = [UIImage imageNamed:pointName];
    UILabel * view1_label4 = [[UILabel alloc] initWithFrame:CGRectMake(view1_imageView5.maxX, heightForHeader * 0.3 - 20 - 20, 80, 20)];
    [view1 addSubview:view1_imageView5];
    [view1 addSubview:view1_label4];
    /*
     * 自然背景View
     */
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.maxY, kScreenWidth, heightForHeader * 0.7)];
     [_headerView addSubview:view2];
    //锦旗
    UILabel * view2_label1 = [[UILabel alloc] initWithFrame:CGRectMake(view2.centerX - 20, 5, 40, 20)];
    [view2 addSubview:view2_label1];
    
    CGFloat flagWidth = 80;
    CGFloat flagHeight = 160;
    CGFloat spacing = (kScreenWidth - flagWidth * 3)/4;
    //第一面旗
    UIImageView * view2_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing,view2_label1.maxY + 25, flagWidth, flagHeight)];
    view2_imageView1.image = [UIImage imageNamed:@"good.png"];
    
    UILabel * view2_label2 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10, - 10, 20, 20)];
    view2_label2.backgroundColor = [UIColor orangeColor];
    view2_label2.text = @"12";
    view2_label2.textColor = [UIColor whiteColor];
    view2_label2.font = [UIFont systemFontOfSize:11];
    view2_label2.layer.cornerRadius = view2_label2.frame.size.width/2;
    view2_label2.clipsToBounds = YES;
    [view2_imageView1 addSubview:view2_label2];
    
    [view2 addSubview:view2_imageView1];
    //第二面旗
    UIImageView * view2_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing,view2_label1.maxY + 25, flagWidth, flagHeight)];
    view2_imageView2.image = [UIImage imageNamed:@"nice.png"];
    
    UILabel * view2_label3 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10, - 10, 20, 20)];
    view2_label3.backgroundColor = [UIColor orangeColor];
    view2_label3.text = @"12";
    view2_label3.textColor = [UIColor whiteColor];
    view2_label3.font = [UIFont systemFontOfSize:11];
    view2_label3.layer.cornerRadius = view2_label2.frame.size.width/2;
    view2_label3.clipsToBounds = YES;
    [view2_imageView2 addSubview:view2_label3];
    
    [view2 addSubview:view2_imageView2];
    //第三面旗
    UIImageView * view2_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(spacing,view2_label1.maxY + 25, flagWidth, flagHeight)];
    view2_imageView1.image = [UIImage imageNamed:@"clever.png"];
    
    UILabel * view2_label4 = [[UILabel alloc] initWithFrame:CGRectMake(flagWidth - 10, - 10, 20, 20)];
    view2_label4.backgroundColor = [UIColor orangeColor];
    view2_label4.text = @"12";
    view2_label4.textColor = [UIColor whiteColor];
    view2_label4.font = [UIFont systemFontOfSize:11];
    view2_label4.layer.cornerRadius = view2_label2.frame.size.width/2;
    view2_label4.clipsToBounds = YES;
    [view2_imageView3 addSubview:view2_label4];
    
    [view2 addSubview:view2_imageView3];
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
    if (self.listModel.items) {
        Comment * c = [self.listModel.items objectAtIndexSafely:indexPath.row];
        cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
        _cellHeight = [cell CellHeight];
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
