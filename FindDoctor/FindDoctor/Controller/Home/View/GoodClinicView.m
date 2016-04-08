//
//  GoodClinicView.m
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/4.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "GoodClinicView.h"
#import "Clinic.h"

@implementation GoodClinicView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _data = [NSMutableArray new];
        return self;
    }
    return nil;
}

@end
