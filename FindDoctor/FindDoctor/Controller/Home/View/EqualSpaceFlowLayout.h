//
//  EqualSpaceFlowLayout.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/4/8.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  EqualSpaceFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>

@end

@interface EqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<EqualSpaceFlowLayoutDelegate> delegate;

@end
