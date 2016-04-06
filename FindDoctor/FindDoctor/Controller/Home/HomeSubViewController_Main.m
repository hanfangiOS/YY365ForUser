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
#import "GoodDoctorView.h"
#import "GoodClinicView.h"
#import "SubObject.h"
#import "SubObjectCell.h"
#import "HomeSubViewMainBannerCell.h"
#import "DoctorListModel.h"
#import "DoctorListController.h"

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
@interface HomeSubViewController_Main ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HomeSearchViewDelegate,HFBannerViewDataSource,HFBannerViewDelegate>{
    
    NSMutableArray * _subjectArray;//科室数组
}

@property (strong, nonatomic) UITableView         * tableView;
@property (strong, nonatomic) UIView              * headerView;
@property (strong, nonatomic) HFBannerView        * mainBannerView;
@property (strong, nonatomic) UICollectionView    * collectionView;
@property (strong, nonatomic) GoodDoctorView      * goodDoctorView;
@property (strong, nonatomic) HFBannerView        * adverBannerView;
@property (strong, nonatomic) GoodClinicView      * goodClinicView;



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
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:self.tableView];

    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1015 * VFixRatio6)];
    self.tableView.tableHeaderView = self.headerView;
    
    //主轮播图
    self.mainBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    self.mainBannerView.delegate = self;
    self.mainBannerView.dataSource = self;
    self.mainBannerView.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:self.mainBannerView];
    
    //科室
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.mainBannerView.maxY, kScreenWidth, kScreenWidth/2) collectionViewLayout:layout];
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
//    self.collectionView.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:self.collectionView];
    
    //好评医生
    self.goodDoctorView = [[GoodDoctorView alloc] initWithFrame:CGRectMake(0, self.collectionView.maxY + 10, kScreenWidth, 200 * VFixRatio6)];
    [self.headerView addSubview:self.goodDoctorView];
    
    //广告轮播图
    self.adverBannerView = [[HFBannerView alloc] initWithFrame:CGRectMake(0, self.goodDoctorView.maxY + 10, kScreenWidth, 85 * VFixRatio6)];
    self.adverBannerView.delegate = self;
    self.adverBannerView.dataSource = self;
    [self.headerView addSubview:self.adverBannerView];
    
    //好评诊所
    self.goodClinicView = [[GoodClinicView alloc] initWithFrame:CGRectMake(0, self.adverBannerView.maxY, kScreenWidth, 284 * VFixRatio6)];
    [self.headerView addSubview:self.goodClinicView];
    
}

- (void)resetData{
    [self.collectionView reloadData];
    [self.goodDoctorView resetData];
    [self.goodClinicView resetData];
    [self.tableView reloadData];
}

#pragma mark - Post Request
//10001接口-主页-消息推送
- (void)postRequestHomeInfo{
    
}

#pragma mark - HFBannerViewDelegate
- (NSInteger)numberOfCellInView:(HFBannerView *)view{
    if (view == self.mainBannerView) {
        return  self.homeModel.mainBannerList.count;
    }
    if (view == self.adverBannerView) {
        return self.homeModel.adverBannerList.count;
    }
    return 0;
}

- (HFBannerViewCell *)HFBannerView:(HFBannerView *)view cellForIndex:(NSInteger)index{
    HomeSubViewMainBannerCell * cell = [[HomeSubViewMainBannerCell alloc] init];
    if (view == self.mainBannerView) {
        cell.data = [self.homeModel.mainBannerList objectAtIndexSafely:index];
    }
    if (view == self.adverBannerView) {
        cell.data = [self.homeModel.adverBannerList objectAtIndexSafely:index];
    }
    return cell;
}

- (void)HFBannerView:(HFBannerView *)view didSelectAtIndex:(NSInteger)index{
    if (view == self.mainBannerView) {
        
    }
    if (view == self.adverBannerView) {
        
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _subjectArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SubObjectCell * cell = [[SubObjectCell alloc] init];
    cell.subobject = [_subjectArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat side = (kScreenWidth - 4)/4;
    return CGSizeMake(side, side);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.5,0.5,0.5,0.5);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 15;
//}


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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end