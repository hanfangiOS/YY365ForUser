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

@property (strong, nonatomic) HomeSearchView      * homeSearchView;
@property (strong, nonatomic) HFBannerView        * mainBannerView;
@property (strong, nonatomic) UICollectionView    * collectionView;
@property (strong, nonatomic) GoodDoctorView      * goodDoctorView;
@property (strong, nonatomic) HFBannerView        * adverBannerView;
@property (strong, nonatomic) GoodClinicView      * goodClinicView;
@property (strong, nonatomic) UITableView         * tableView;


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
    [super viewDidLoad];
    [self initData];
    [self initSubviews];
}

- (void)loadContentView{
    self.contentView.backgroundColor = [UIColor purpleColor];
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
    NSMutableArray * subjectTieleArray = [[NSMutableArray alloc] initWithArray:@[@"内科",@"妇科",@"儿科",@"皮肤科",@"骨科",@"男科",@"针灸科",@"全科"]];
    NSMutableArray * subjectImageArray = [[NSMutableArray alloc] initWithArray:@[@"neikeICON",@"fukeICON",@"erkeICON",@"pifukeICON",@"gukeICON",@"nankeICON",@"zhenjiuICON",@"quankeICON"]];
    for (int i = 0; i < subjectTieleArray.count; i++) {
        SubObject * subject = [[SubObject alloc] init];
        subject.name = [subjectTieleArray objectAtIndex:i];
        subject.localImageName = [subjectImageArray objectAtIndex:i];
        [_subjectArray addObject:subject];
    }
}

- (void)initSubviews{
    
}

- (void)resetData{
    [self.homeSearchView resetData];
    [self.collectionView reloadData];
    [self.goodDoctorView resetData];
    [self.goodClinicView resetData];
    [self.tableView reloadData];
}

#pragma mark - Post Request
//10001接口-主页-消息推送
- (void)postRequestHomeInfo{
    
}

#pragma mark -
//临时创建搜索入口
- (void)initSearchEntrance
{
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){50,100,100,80};
    [searchbutton setTitle:@"搜索" forState:UIControlStateNormal];
    searchbutton.backgroundColor = [UIColor redColor];
    [searchbutton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
}

//临时创建我的收藏
//- (void)initCollectionButton
//{
//    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchbutton.frame = (CGRect){200,100,100,80};
//    [searchbutton setTitle:@"我的收藏" forState:UIControlStateNormal];
//    searchbutton.backgroundColor = [UIColor redColor];
//    [searchbutton addTarget:self action:@selector(showMyCollection) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:searchbutton];
//}

#pragma mark - Private Func

- (void)searchAction
{
    DoctorSearchController *searchVC = [[DoctorSearchController alloc] init];
    [self.slideNavigationController pushViewController:searchVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    searchVC.action = ^(NSString *keyword) {
        [weakSelf findDoctorWithKeyword:keyword];
    };
}

- (void)findDoctorWithKeyword:(NSString *)keyword
{
    SearchFilter * filter = [[SearchFilter alloc] init];
    filter.keyword = keyword;
    
    DoctorSearchResultListModel * listModel1 = [[DoctorSearchResultListModel alloc] initWithFilter:filter];
    DoctorSearchResultViewController * listVC = [[DoctorSearchResultViewController alloc] initWithPageName:@"DoctorSearchResultViewController" listModel:listModel1];
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