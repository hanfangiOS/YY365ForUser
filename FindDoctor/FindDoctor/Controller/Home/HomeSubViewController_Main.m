#import "HomeSubViewController_Main.h"
#import "UIConstants.h"
#import "CUUIContant.h"
#import "UIImage+Color.h"
#import "TipHandler+HUD.h"
#import "HFBannerView.h"
#import "HFTitleView.h"

#import "DoctorSearchController.h"
#import "DoctorSearchResultViewController.h"
#import "DoctorSearchResultListModel.h"
#import "HomeSearchView.h"
#import "GoodDoctorViewController.h"
#import "GoodClinicViewController.h"
#import "SubObject.h"
#import "SubObjectCell.h"
#import "HomeSubViewMainBannerCell.h"
#import "SearchResultListModel.h"
#import "SearchResultViewController.h"
#import "HomeSubViewMainTableCell.h"
#import "CommonManager.h"
#import "CUDoctorManager.h"
#import "CUClinicManager.h"
#import "DoctorDetailController.h"
#import "ClinicMainViewController.h"
#import "MJRefresh.h"

#define sectionHeaderViewHeight 30

@implementation HomeModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.mainBannerList = [NSMutableArray new];
        self.secondBannerList = [NSMutableArray new];
        self.goodDoctorList = [NSMutableArray new];
        self.goodClinicList = [NSMutableArray new];
        self.subjectList = [NSMutableArray new];
        self.famousDoctorList = [NSMutableArray new];
        return self;
    }
    return nil;
}

@end
//-------------------------------------------------------------------//
@interface HomeSubViewController_Main ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomeSearchViewDelegate,HFBannerViewDataSource,HFBannerViewDelegate>{
    
    NSMutableArray * _subjectArray;//科室数组
}

@property (strong, nonatomic) UITableView                   * tableView;
@property (strong, nonatomic) UIView                        * headerView;
@property (strong, nonatomic) HFBannerView                  * mainBannerView;
@property (strong, nonatomic) UICollectionView              * subjectCollectionView;
@property (strong, nonatomic) GoodDoctorViewController      * goodDoctorVC;
@property (strong, nonatomic) UICollectionView              * goodDoctorCollectionView;
@property (strong, nonatomic) HFBannerView                  * secondBannerView;
@property (strong, nonatomic) GoodClinicViewController      * goodClinicVC;
@property (strong, nonatomic) UICollectionView              * goodclinicCollectionView;
@property (strong, nonatomic) UIView                        * loadMoreContainerView;

@end

@implementation HomeSubViewController_Main

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    
    if (self) {
        _hasNavigationBar = NO;
        _hasToolbar = NO;
        
        [self postRequestFamousDoctorClinic];
    }
    return self;
}

- (void)setShouldHaveTab
{
    self.hasTab = YES;
}

- (void)viewDidLoad {
    [self initData];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self postRequestSubjectList];
    [self postRequestgoodRemarkDoctorList];
    [self postRequestGoodRemarkClinicList];
    [self postRequestActivityBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    _subjectArray = [NSMutableArray new];
    NSMutableArray * subjectTieleArray = [[NSMutableArray alloc] initWithArray:@[@"内科",@"妇科",@"儿科",@"皮肤科",@"外科",@"骨科",@"药剂科",@"更多"]];
    NSMutableArray * subjectImageArray = [[NSMutableArray alloc] initWithArray:@[@"main_icon_neike@3x",@"main_icon_fuke@3x",@"main_icon_erke@3x",@"main_icon_pifuke@3x",@"main_icon_waike@3x",@"main_icon_guke@3x",@"main_icon_yaojike@3x",@"main_icon_more@3x"]];
    for (int i = 0; i < subjectTieleArray.count; i++) {
        SubObject * subject = [[SubObject alloc] init];
        subject.name = [subjectTieleArray objectAtIndex:i];
        subject.localImageName = [subjectImageArray objectAtIndex:i];
        [_subjectArray addObject:subject];
    }
    
    self.homeModel = [[HomeModel alloc] init];
    [self.homeModel.subjectList addObjectsFromArray:_subjectArray];
}

- (void)loadContentView{
    
    self.contentView.backgroundColor = kCommonBackgroundColor;
    
    //名医馆
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frameHeight - 60) style:UITableViewStylePlain];
    self.tableView.backgroundColor = kCommonBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];

    //headerView 除优医馆之外的view都在里面
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.headerView.backgroundColor = kCommonBackgroundColor;
    //主轮播图
    self.mainBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 320 / 750.f)];
    self.mainBannerView.delegate = self;
    self.mainBannerView.dataSource = self;
    [self.headerView addSubview:self.mainBannerView];
    
    //科室
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.subjectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.mainBannerView.maxY, kScreenWidth, (kScreenWidth - 5)/4 * 2 + 3) collectionViewLayout:layout];
    self.subjectCollectionView.dataSource = self;
    self.subjectCollectionView.delegate = self;
    self.subjectCollectionView.scrollEnabled = NO;
    self.subjectCollectionView.backgroundColor = kblueLineColor;

    [self.subjectCollectionView registerClass:[SubObjectCell class] forCellWithReuseIdentifier:@"SubObjectCell"];
    [self.headerView addSubview:self.subjectCollectionView];
    
    //好评医生
    UICollectionViewFlowLayout * doctorLayout = [[UICollectionViewFlowLayout alloc] init];
    [doctorLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.goodDoctorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.subjectCollectionView.maxY + 10, kScreenWidth, 200) collectionViewLayout:doctorLayout];
    self.goodDoctorCollectionView.backgroundColor = [UIColor yellowColor];
    [self.headerView addSubview: self.goodDoctorCollectionView];
    
    self.goodDoctorVC = [[GoodDoctorViewController alloc] initWithCollectionView:self.goodDoctorCollectionView];
    self.goodDoctorVC.fatherVC = self;
    self.goodDoctorCollectionView.delegate = self.goodDoctorVC;
    self.goodDoctorCollectionView.dataSource = self.goodDoctorVC;

    //广告轮播图
    self.secondBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, self.self.goodDoctorCollectionView.maxY + 10 * VFixRatio6, kScreenWidth, 85)];
    self.secondBannerView.delegate = self;
    self.secondBannerView.dataSource = self;
    [self.headerView addSubview:self.secondBannerView];
    
    UIView * lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineTop.backgroundColor = kblueLineColor;
    [self.secondBannerView addSubview:lineTop];
    
    UIView * lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondBannerView.frameHeight - 1, kScreenWidth, 1)];
    lineBottom.backgroundColor = kblueLineColor;
    [self.secondBannerView addSubview:lineBottom];
    
    //好评诊所
    UICollectionViewFlowLayout * clinicLayout = [[UICollectionViewFlowLayout alloc] init];
    [clinicLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.goodclinicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.secondBannerView.maxY + 10 * VFixRatio6, kScreenWidth, 283) collectionViewLayout:clinicLayout];
    self.goodclinicCollectionView.backgroundColor = [UIColor whiteColor];
        [self.headerView addSubview:self.goodclinicCollectionView];
    
    self.goodClinicVC = [[GoodClinicViewController alloc] initWithCollectionView:self.goodclinicCollectionView];
    self.goodClinicVC.fatherVC = self;
    self.goodclinicCollectionView.delegate = self.goodClinicVC;
    self.goodclinicCollectionView.dataSource = self.goodClinicVC;
    
    UIView * downLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.goodclinicCollectionView.frameHeight - 1, kScreenWidth, 1)];
    downLine.backgroundColor = kblueLineColor;
    [self.goodclinicCollectionView addSubview:downLine];
    
    //好评诊所到名医馆之间的间隔View
    UIView * paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.goodclinicCollectionView.maxY,kScreenWidth, 10)];
    paddingView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:paddingView];
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, paddingView.maxY);
    [self.tableView setTableHeaderView:self.headerView];
    
    
    
    //查看更多按钮背景
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = kGrayTextColor;
    self.tableView.mj_footer = footer;
    //这是加载更多那个按钮 ，可能被弃用
//    self.loadMoreContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
//    self.loadMoreContainerView.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableFooterView = self.loadMoreContainerView;
//    
//    UIButton * moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(36, 5, kScreenWidth - 36 * 2, 32 - 5 * 2)];
//    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
//    [moreBtn setTitleColor:kGrayTextColor forState:UIControlStateNormal];
//    [moreBtn addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
//    moreBtn.layer.borderColor = kLightGrayColor.CGColor;
//    moreBtn.layer.borderWidth = 0.5;
//    moreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    moreBtn.tag = 12345;
//    [self.loadMoreContainerView addSubview:moreBtn];
//    
//    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.loadMoreContainerView.frameWidth - 10)/2, (self.loadMoreContainerView.frameHeight - 10)/2, 10, 10)];
//    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    indicator.tag = 67890;
//    [indicator setHidesWhenStopped:YES];
//    [indicator stopAnimating];
//    [self.loadMoreContainerView addSubview:indicator];
//    
//    
//    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 32 - 1, kScreenWidth, 1)];
//    bottomLine.backgroundColor = kblueLineColor;
//    [self.loadMoreContainerView addSubview:bottomLine];

}

- (void)loadMoreAction{
    [self postRequestFamousDoctorClinic];
}

- (void)resetData{
    [self.mainBannerView reloadData];
    [self.subjectCollectionView reloadData];
    self.goodDoctorVC.data = self.homeModel.goodDoctorList;
    [self.secondBannerView reloadData];
    self.goodClinicVC.data = self.homeModel;
    [self.tableView reloadData];
}

#pragma mark - HFBannerViewDelegate
- (NSInteger)numberOfCellInView:(HFBannerView *)view{
    if (view == self.mainBannerView) {
        return  self.homeModel.mainBannerList.count;
    }
    if (view == self.secondBannerView) {
        return self.homeModel.secondBannerList.count;
    }
    return 0;
}

- (HFBannerViewCell *)HFBannerView:(HFBannerView *)view cellForIndex:(NSInteger)index{
    HomeSubViewMainBannerCell * cell = [[HomeSubViewMainBannerCell alloc] init];
    if (view == self.mainBannerView) {
        cell.frame = CGRectMake(0 , 0 , [UIScreen mainScreen].bounds.size.width, kScreenWidth * 320 / 750.f);
        cell.data = [self.homeModel.mainBannerList objectAtIndexSafely:index];
    }
    if (view == self.secondBannerView) {
        cell.frame = CGRectMake(0 , 0 , [UIScreen mainScreen].bounds.size.width, kScreenWidth * 164 / 750.f);
        cell.data = [self.homeModel.secondBannerList objectAtIndexSafely:index];
    }
    return cell;
}

- (void)HFBannerView:(HFBannerView *)view didSelectAtIndex:(NSInteger)index{
    if (view == self.mainBannerView) {
        
    }
    if (view == self.secondBannerView) {
        
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubObjectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubObjectCell" forIndexPath:indexPath];
    cell.subobject = [self.homeModel.subjectList objectAtIndexSafely:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat side = (kScreenWidth - 6)/4;
    return CGSizeMake(side  ,side);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(1,1,1,1);
    }
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultListModel * listModel = [[SearchResultListModel alloc] initWithSortType:SearchSortTypeNone];
    SubObject *subobject = (SubObject *)[self.homeModel.subjectList objectAtIndex:indexPath.row];
    listModel.filter.subjectID = subobject.type_id;
    SearchResultViewController *listVC = [[SearchResultViewController alloc] initWithPageName:self.pageName listModel:listModel];
    [self.slideNavigationController pushViewController:listVC animated:YES];

}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSubViewMainTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSubViewMainTableCell"];
    if (!cell) {
         cell = [[HomeSubViewMainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeSubViewMainTableCell"];
    }
    cell.data = [self.homeModel.famousDoctorList objectAtIndexSafely:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomeSubViewMainTableCell defaultHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,sectionHeaderViewHeight)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    for (UIView * view in sectionHeaderView.subviews) {
        if (view.tag == 2000 || view.tag == 2001 || view.tag == 2002) {
            [view removeFromSuperview];
        }
    }
    
    HFTitleView * titleView = [[HFTitleView alloc] initWithFrame:sectionHeaderView.bounds titleText:@"优医馆" Style:HFTitleViewStyleLoadMore];
    titleView.title.font = [UIFont systemFontOfSize:14];
    titleView.loadMoreBtn.hidden = YES;
    titleView.pic.backgroundColor = kBlueTextColor;
    [titleView resetData];
    titleView.tag = 2000;
    [sectionHeaderView addSubview:titleView];
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topLine.backgroundColor = kblueLineColor;
    topLine.tag = 2001;
    [sectionHeaderView addSubview:topLine];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderViewHeight - 1, kScreenWidth - 10 * 2, 1)];
    bottomLine.backgroundColor = kblueLineColor;
    bottomLine.tag = 2002;
    [sectionHeaderView addSubview:bottomLine];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeaderViewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转医生详情
    DoctorDetailController * vc = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    vc.doctor =  [self.homeModel.famousDoctorList objectAtIndex:indexPath.row];
    [self.slideNavigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = sectionHeaderViewHeight;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - Post Request
//14202获取科目列表
- (void)postRequestSubjectList{
    [[CommonManager sharedInstance]getSubjectListWithFilter:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [self.homeModel.subjectList removeAllObjects];
                [self.homeModel.subjectList addObjectsFromArray:result.parsedModelObject];
                [self.subjectCollectionView reloadData];
            }
        }
        
    } pageName:@"HomeSubViewController_Main"];
}

//好评医生
- (void)postRequestgoodRemarkDoctorList{
    [[CUDoctorManager sharedInstance] getGoodRemarkDoctorListWithFilter:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [self.homeModel.goodDoctorList removeAllObjects];
                [self.homeModel.goodDoctorList addObjectsFromArray:result.parsedModelObject];
                self.goodDoctorVC.data = self.homeModel.goodDoctorList;
            }
        }
        
    } pageName:@"HomeSubViewController_Main"];
}

//好评诊所
- (void)postRequestGoodRemarkClinicList{
    [[CUClinicManager sharedInstance] getGoodRemarkClinicListWithFilter:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [self.homeModel.goodClinicList removeAllObjects];
                [self.homeModel.goodClinicList addObjectsFromArray:result.parsedModelObject];
                self.goodClinicVC.data = self.homeModel;
            }
        }
        
    } pageName:@"HomeSubViewController_Main"];
}

//优医馆
- (void)postRequestFamousDoctorClinic{
    
//    UIButton * btn = [self.loadMoreContainerView viewWithTag:12345];
//    btn.hidden = YES;
    
//    UIActivityIndicatorView * indicator = [self.loadMoreContainerView viewWithTag:67890];
//    [indicator startAnimating];
    
    DoctorFilter * filter = [[DoctorFilter alloc] init];
    filter.rows = 3;
    filter.total = self.homeModel.famousDoctorList.count;
    [[CUDoctorManager sharedInstance] getFamousDoctorClinicWithFilter:filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
//        btn.hidden = NO;
//        [indicator stopAnimating];
        
        if (!result.hasError) {
            NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
            if (![errorCode integerValue]) {
                [self.homeModel.famousDoctorList addObjectsFromArray:result.parsedModelObject];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
    } pageName:@"HomeSubViewController_Main"];
    
}

//轮播图
- (void)postRequestActivityBanner{
   [[CommonManager sharedInstance] getActivityBannerWithFilter:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
       
       if (!result.hasError) {
           NSNumber * errorCode = [result.responseObject valueForKeySafely:@"errorCode"];
           if (![errorCode integerValue]) {
               [self.homeModel.mainBannerList removeAllObjects];
               [self.homeModel.mainBannerList addObjectsFromArray:[result.parsedModelObject arrayForKeySafely:@"main"]];
               [self.mainBannerView reloadData];
               
               [self.homeModel.secondBannerList removeAllObjects];
               [self.homeModel.secondBannerList addObjectsFromArray:[result.parsedModelObject arrayForKeySafely:@"second"]];
               [self.secondBannerView reloadData];
           }
       }
       
   } pageName:@"HomeSubViewController_Main"];
}


@end