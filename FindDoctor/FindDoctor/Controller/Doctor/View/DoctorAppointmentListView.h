//
//  DoctorAppointmentListView.h
//  FindDoctor
//
//  Created by Guo on 15/11/26.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Doctor.h"

typedef void(^DoctorSectionActionTag)(SelectOrderTime *selectOrderTime);


@interface DoctorAppointmentListView : UIView<UITableViewDelegate,UITableViewDataSource>

- (id)initWithFrame:(CGRect)frame data:(DoctorAppointmentListItem *)data;

@property (nonatomic, strong) DoctorAppointmentListItem *data;
@property (nonatomic, copy) DoctorSectionActionTag clickBlock;

@property (nonatomic, strong) UITableView *tableView;

+ (CGFloat)cellHeight;

@end
