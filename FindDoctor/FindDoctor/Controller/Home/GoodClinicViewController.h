//
//  GoodClinicViewController.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubViewController_Main.h"

@interface GoodClinicViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic)HomeModel * data;
@property (strong,nonatomic)HomeSubViewController_Main * fatherVC;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;//一定要使用本方法进行初始化

@end
