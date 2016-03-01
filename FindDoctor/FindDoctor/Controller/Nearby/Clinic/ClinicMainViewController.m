//
//  ClinicMainViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/24.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "ClinicMainViewController.h"
#import "CUClinicManager.h"
#import "ClinicMainHeaderView.h"
#import "SubjectOfClinicMainCollectionViewCell.h"
#import "DoctorDetailController.h"
#import "CUDoctorManager.h"
#import "TipHandler.h"
#import "NSDate+SNExtension.h"

@interface ClinicMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UIScrollView *_contentScrollView;
    ClinicMainHeaderView *headerView;
    UICollectionView *_collectionView;
}

@end

@implementation ClinicMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.clinic.name;
    [self loadContentScrollView];
    [self initSubView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self showProgressView];
    [[CUClinicManager sharedInstance] getClinicMainWithClinic:self.clinic resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            [self hideProgressView];
            [self resetData];
        }
    } pageName:@"ClinicMainViewController"];
    
}

- (void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:self.contentView.bounds];
    _contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self.contentView addSubview:_contentScrollView];
}

- (void)initSubView{
    headerView = [[ClinicMainHeaderView alloc]initWithFrame:CGRectMake(0, 7.6,kScreenWidth , 200)];
    [_contentScrollView addSubview:headerView];
    
    float item_interval_x = 15*kScreenRatio;
    float margin = 30*kScreenRatio;
    float item_interval_y = 12*kScreenRatio;
    
    int line_number = 3;
    float item_width = (kScreenWidth-margin*2-item_interval_x*(line_number-1))/line_number;
    float item_height = 100*kScreenRatio;
    
    float header_height = 10.f;
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(item_width, item_height);
    collectionLayout.minimumInteritemSpacing = item_interval_x;
    collectionLayout.minimumLineSpacing = item_interval_y;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    collectionLayout.headerReferenceSize = CGSizeMake(kScreenWidth, header_height);
    
    CGRect collectionFrame = CGRectMake(0, CGRectGetMaxY(headerView.frame)+7, kScreenWidth, self.contentView.frameHeight - CGRectGetMaxY(headerView.frame) - 7);
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:collectionLayout];
    collectionview.backgroundColor = [UIColor whiteColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.contentView addSubview:collectionview];
    
    _collectionView = collectionview;
    
    NSString *collectionCellName = NSStringFromClass([SubjectOfClinicMainCollectionViewCell class]);
    [_collectionView registerClass:[SubjectOfClinicMainCollectionViewCell class] forCellWithReuseIdentifier:collectionCellName];
}

- (void)resetData{
    headerView.data = self.clinic;
    NSInteger numberOfLine = (self.clinic.doctorsArray.count+2) / 3;
    [_collectionView reloadData];
    _collectionView.frame = CGRectMake(_collectionView.frameX, CGRectGetMaxY(headerView.frame)+7 , _collectionView.frameWidth, self.contentView.frameHeight - CGRectGetMaxY(headerView.frame) - 7);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar{
    [self addLeftBackButtonItemWithImage];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"医生一共有%d个",_clinic.doctorsArray.count);
    return _clinic.doctorsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *collectionCellName = NSStringFromClass([SubjectOfClinicMainCollectionViewCell  class]);
    SubjectOfClinicMainCollectionViewCell *collectionCell = (SubjectOfClinicMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    collectionCell.data = [_clinic.doctorsArray objectAtIndex:indexPath.row];
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    detailVC.doctor = [self.clinic.doctorsArray objectAtIndexSafely:indexPath.row];
    
//    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithFormat:[NSDateFormatter dateFormatString]];
    
    [[CUDoctorManager sharedInstance] updateDoctorInfo:detailVC.doctor date:[[[NSDate date] dateAtStartOfDay] timeIntervalSince1970] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        
        if (!result.hasError) {
            [self.slideNavigationController pushViewController:detailVC animated:YES];
        }
        else {
            [TipHandler showTipOnlyTextWithNsstring:[result.error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        }
    }];
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
