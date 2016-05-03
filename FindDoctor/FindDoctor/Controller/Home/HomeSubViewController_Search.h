//
//  HomeSubViewController_Search.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/5.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"

@protocol HomeSubViewController_SearchDelegate <NSObject>
@required
- (void)HomeSubViewController_SearchEndEdit;
@end

@interface HomeSubViewController_Search : CUViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) id <HomeSubViewController_SearchDelegate> delegate;
- (void)searchClickWithString:(NSString *)searchStr;
- (void)loadHistory;

@end
