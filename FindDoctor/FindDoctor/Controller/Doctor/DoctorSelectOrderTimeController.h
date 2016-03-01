//
//  DoctorSelectOrderTimeController.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/2/17.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "Doctor.h"

@interface DoctorSelectOrderTimeController : CUViewController

@property (nonatomic,strong)Doctor *doctor;
@property (nonatomic,strong)DoctorAppointmentListItem *doctorAppointmentListItem;
@property long long diagnosisID;

@end
