//
//  HomeSubViewController_Search.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "HomeViewController.h"

@interface HomeSubViewController_Search : CUViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic)HomeViewController * homeViewController;

- (void)searchClickWithString:(NSString *)searchStr;

@end
