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
#import "DoctorListModel.h"
#import "DoctorListController.h"
#import "HomeSubViewMainTableCell.h"

#define sectionHeaderViewHeight 30

@implementation HomeModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.mainBannerList = [NSMutableArray new];
        self.adverBannerList = [NSMutableArray new];
        self.goodDoctorList = [NSMutableArray new];
        self.goodClinicList = [NSMutableArray new];
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
@property (strong, nonatomic) HFBannerView                  * adverBannerView;
@property (strong, nonatomic) GoodClinicViewController      * goodClinicVC;
@property (strong, nonatomic) UICollectionView              * goodclinicCollectionView;

@end

@implementation HomeSubViewController_Main

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    
    if (self) {
        _hasNavigationBar = NO;
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
    [self postRequestHomeInfo];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    _subjectArray = [NSMutableArray new];
    NSMutableArray * subjectTieleArray = [[NSMutableArray alloc] initWithArray:@[@"内科",@"妇科",@"儿科",@"皮肤科",@"外科",@"骨科",@"药剂科",@"更多"]];
    NSMutableArray * subjectImageArray = [[NSMutableArray alloc] initWithArray:@[@"neikeICON",@"fukeICON",@"erkeICON",@"pifukeICON",@"waikeICON",@"gukeICON",@"yaojikeICON",@"gengduoICON"]];
    for (int i = 0; i < subjectTieleArray.count; i++) {
        SubObject * subject = [[SubObject alloc] init];
        subject.name = [subjectTieleArray objectAtIndex:i];
        subject.localImageName = [subjectImageArray objectAtIndex:i];
        [_subjectArray addObject:subject];
    }
}

- (void)loadContentView{

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //名医馆
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frameHeight - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.tableView];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    //主轮播图
    self.mainBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    self.mainBannerView.delegate = self;
    self.mainBannerView.dataSource = self;
    self.mainBannerView.backgroundColor = [UIColor blueColor];
    [self.headerView addSubview:self.mainBannerView];
    
    //科室
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.subjectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.mainBannerView.maxY, kScreenWidth, (kScreenWidth - 5)/4 * 2 + 3) collectionViewLayout:layout];
    self.subjectCollectionView.dataSource = self;
    self.subjectCollectionView.delegate = self;
    self.subjectCollectionView.scrollEnabled = NO;
    self.subjectCollectionView.backgroundColor = [UIColor blackColor];

    [self.subjectCollectionView registerClass:[SubObjectCell class] forCellWithReuseIdentifier:@"SubObjectCell"];
    [self.headerView addSubview:self.subjectCollectionView];
    

    UICollectionViewFlowLayout * doctorLayout = [[UICollectionViewFlowLayout alloc] init];
    [doctorLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.goodDoctorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.subjectCollectionView.maxY + 10, kScreenWidth, 200) collectionViewLayout:doctorLayout];
    self.goodDoctorCollectionView.backgroundColor = [UIColor yellowColor];
    [self.headerView addSubview: self.goodDoctorCollectionView];
    
    self.goodDoctorVC = [[GoodDoctorViewController alloc] initWithCollectionView:self.goodDoctorCollectionView];
    self.goodDoctorCollectionView.delegate = self.goodDoctorVC;
    self.goodDoctorCollectionView.dataSource = self.goodDoctorVC;

    //广告轮播图
    self.adverBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, self.self.goodDoctorCollectionView.maxY + 10 * VFixRatio6, kScreenWidth, 85)];
    self.adverBannerView.delegate = self;
    self.adverBannerView.dataSource = self;
    self.adverBannerView.backgroundColor = [UIColor greenColor];
    [self.headerView addSubview:self.adverBannerView];
    
    //好评诊所
    UICollectionViewFlowLayout * clinicLayout = [[UICollectionViewFlowLayout alloc] init];
    [clinicLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.goodclinicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.adverBannerView.maxY + 10 * VFixRatio6, kScreenWidth, 283) collectionViewLayout:clinicLayout];
    self.goodclinicCollectionView.backgroundColor = [UIColor purpleColor];
        [self.headerView addSubview:self.goodclinicCollectionView];
    
    self.goodClinicVC = [[GoodClinicViewController alloc] initWithCollectionView:self.goodclinicCollectionView];
    self.goodclinicCollectionView.delegate = self.goodClinicVC;
    self.goodclinicCollectionView.dataSource = self.goodClinicVC;
    
    //透明空白View
    UIView * paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.goodclinicCollectionView.maxY,kScreenWidth, 10)];
    paddingView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:paddingView];
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, paddingView.maxY);
    [self.tableView setTableHeaderView:self.headerView];
}

- (void)resetData{
    [self.mainBannerView reloadData];
    [self.subjectCollectionView reloadData];
    self.goodDoctorVC.data = self.homeModel.goodDoctorList;
    [self.adverBannerView reloadData];
    self.goodClinicVC.data = self.homeModel;
    [self.tableView reloadData];
}

#pragma mark - Post Request
//10001接口-主页-消息推送
- (void)postRequestHomeInfo{
    
}

#pragma mark - HFBannerViewDelegate
- (NSInteger)numberOfCellInView:(HFBannerView *)view{
//    if (view == self.mainBannerView) {
//        return  self.homeModel.mainBannerList.count;
//    }
//    if (view == self.adverBannerView) {
//        return self.homeModel.adverBannerList.count;
//    }
//    return 0;
    return 3;
}

- (HFBannerViewCell *)HFBannerView:(HFBannerView *)view cellForIndex:(NSInteger)index{
//    HomeSubViewMainBannerCell * cell = [[HomeSubViewMainBannerCell alloc] init];
//    if (view == self.mainBannerView) {
//        cell.data = [self.homeModel.mainBannerList objectAtIndexSafely:index];
//    }
//    if (view == self.adverBannerView) {
//        cell.data = [self.homeModel.adverBannerList objectAtIndexSafely:index];
//    }
//    return cell;
    HFBannerViewCell *cell = [[HFBannerViewCell alloc]init];
    if (index == 0) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    if (index == 1) {
        cell.backgroundColor = [UIColor grayColor];
    }
    if (index == 2) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}

- (void)HFBannerView:(HFBannerView *)view didSelectAtIndex:(NSInteger)index{
//    if (view == self.mainBannerView) {
//        
//    }
//    if (view == self.adverBannerView) {
//        
//    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _subjectArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SubObjectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubObjectCell" forIndexPath:indexPath];
    cell.subobject = [_subjectArray objectAtIndex:indexPath.row];
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
    DoctorListModel * listModel = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeNone];
    SubObject *subobject = (SubObject *)[_subjectArray objectAtIndex:indexPath.row];
    listModel.filter.typeId = subobject.type_id;
    DoctorListController *listVC = [[DoctorListController alloc] initWithPageName:@"DoctorListController" listModel:listModel];
    [self.slideNavigationController pushViewController:listVC animated:YES];

}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.homeModel.goodDoctorList.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSubViewMainTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSubViewMainTableCell"];
    if (!cell) {
         cell = [[HomeSubViewMainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeSubViewMainTableCell"];
    }
    cell.data = [self.homeModel.goodDoctorList objectAtIndexSafely:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomeSubViewMainTableCell defaultHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,sectionHeaderViewHeight )];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    for (UIView * view in sectionHeaderView.subviews) {
        if (view.tag == 2000 || view.tag == 2001 || view.tag == 2002) {
            [view removeFromSuperview];
        }
    }
    
    HFTitleView * titleView = [[HFTitleView alloc] initWithFrame:sectionHeaderView.bounds titleText:@"名医馆" Style:HFTitleViewStyleLoadMore];
    titleView.loadMoreBtn.hidden = YES;
    titleView.pic.backgroundColor = [UIColor blueColor];
    [titleView resetData];
    titleView.tag = 2000;
    [sectionHeaderView addSubview:titleView];
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = [UIColor blackColor];
    topLine.tag = 2001;
    [sectionHeaderView addSubview:topLine];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, sectionHeaderViewHeight - 0.5, kScreenWidth - 10 * 2, 0.5)];
    bottomLine.backgroundColor = [UIColor blackColor];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = sectionHeaderViewHeight;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end