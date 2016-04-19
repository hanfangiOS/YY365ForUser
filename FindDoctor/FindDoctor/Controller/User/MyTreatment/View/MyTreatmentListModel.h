//
//  MyTreatmentListModel.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/4/19.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "CUOrder.h"

@interface MyTreatmentListModel : SNBaseListModel

@property (strong,nonatomic)OrderFilter * filter;

- (instancetype)initWithFilter:(OrderFilter *)filter;

@end
