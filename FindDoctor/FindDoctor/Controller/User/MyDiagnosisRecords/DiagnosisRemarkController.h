//
//  DiagnosisRemarkController.h
//  uyi365ForPatient
//
//  Created by ZhuHaoRan on 16/3/16.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "Comment.h"
#import "Doctor.h"

@interface DiagnosisRemarkController : CUViewController

@property (nonatomic, strong)  Doctor            * data;
@property (nonatomic, assign)  long long           diagnosisID;

@end
