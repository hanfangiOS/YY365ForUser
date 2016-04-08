//
//  HomeSubViewController2.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/11.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "HomeSubViewController2.h"
#import "SubObject.h"
#import "SubObjectCell.h"
#import "DoctorListModel.h"
#import "DoctorListController.h"

@interface HomeSubViewController2 ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *_itemArray;
}

@property (nonatomic, weak) UICollectionView *contentCollection;

@end

@implementation HomeSubViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择科室";
    [self setCollectionViewData];
    // Do any additional setup after loading the view.
}

- (void)setCollectionViewData{
    _itemArray  = [NSMutableArray new];
    for (int i = 0 ; i < 9 ;  i++ ) {
        SubObject *subobject = [[SubObject alloc]init];
        switch (i) {
            case 0:{
                subobject.name = @"内科";
                subobject.localImageName = @"neikeICON";
                subobject.type_id = 23;
                break;
            }
                
            case 1:{
                subobject.name = @"妇科";
                subobject.localImageName = @"fukeICON";
                subobject.type_id = 8;
                break;
            }
                
            case 2:{
                subobject.name = @"儿科";
                subobject.localImageName = @"erkeICON";
                subobject.type_id = 1;
                break;
            }
                
            case 3:{
                subobject.name = @"皮肤科";
                subobject.localImageName = @"pifukeICON";
                subobject.type_id = 65;
                break;
            }
                
            case 4:{
                subobject.name = @"五官科";
                subobject.localImageName = @"wuguankeICON";
                subobject.type_id = 66;
                break;
            }
                
            case 5:{
                subobject.name = @"骨科";
                subobject.localImageName = @"gukeICON";
                subobject.type_id = 16;
                break;
            }
                
            case 6:{
                subobject.name = @"男科";
                subobject.localImageName = @"nankeICON";
                subobject.type_id = 60;
                break;
            }
                
            case 7:{
                subobject.name = @"针灸科";
                subobject.localImageName = @"zhenjiuICON";
                subobject.type_id = 61;
                break;
            }
                
            case 8:{
                subobject.name = @"全科";
                subobject.localImageName = @"quankeICON";
                subobject.type_id = 64;
                break;
            }
                
            default:
                break;
        }
        [_itemArray addObject:subobject];
    }
    
}

- (void)loadContentView{
    float item_interval_x = 15*kScreenRatio;
    float margin = 30*kScreenRatio;
    float item_interval_y = 12*kScreenRatio;
    
    int line_number = 3;
    float item_width = (kScreenWidth-margin*2-item_interval_x*(line_number-1))/line_number;
    float item_height = 100*kScreenRatio;
    
    float header_height = 55.f;
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(item_width, item_height);
    collectionLayout.minimumInteritemSpacing = item_interval_x;
    collectionLayout.minimumLineSpacing = item_interval_y;
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    collectionLayout.headerReferenceSize = CGSizeMake(kScreenWidth, header_height);
    
    CGRect collectionFrame = self.contentView.bounds;
    
    UICollectionView *collectionview = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:collectionLayout];
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self.contentView addSubview:collectionview];
    
    self.contentCollection = collectionview;
    
    NSString *collectionCellName = NSStringFromClass([SubObjectCell class]);
    [self.contentCollection registerClass:[SubObjectCell class] forCellWithReuseIdentifier:collectionCellName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *collectionCellName = NSStringFromClass([SubObjectCell class]);
    SubObjectCell *collectionCell = (SubObjectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellName forIndexPath:indexPath];
    collectionCell.subobject = [_itemArray objectAtIndexSafely:indexPath.row];
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorListModel *listModel = [[DoctorListModel alloc] initWithSortType:DoctorSortTypeNone];
    SubObject *subobject = (SubObject *)[_itemArray objectAtIndex:indexPath.row];
    listModel.filter.typeId = subobject.type_id;
//#if !LOCAL
//    listModel.filter.typeId = indexPath.section;
//    listModel.filter.subTypeId = [[[[_showObjectList.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] type_id] integerValue];
//    listModel.filter.keyword = [[[_showObjectList.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] name];
//#else
//    listModel.filter.typeId = [[[_showObjectList.items objectAtIndex:indexPath.row] type_id] integerValue];
//#endif
    DoctorListController *listVC = [[DoctorListController alloc] initWithPageName:@"DoctorListController" listModel:listModel];
    [self.slideNavigationController pushViewController:listVC animated:YES];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

@end
