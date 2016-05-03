//
//  GoodDoctorViewController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubViewController_Main.h"

@interface GoodDoctorViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic)NSMutableArray * data;//数组内包含Doctor模型
@property (strong,nonatomic)HomeSubViewController_Main * fatherVC;//数组内包含Doctor模型

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;//一定要使用本方法进行初始化

@end
