//
//  DoctorAppointmentListView.m
//  FindDoctor
//
//  Created by Guo on 15/11/26.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "DoctorAppointmentListView.h"
#import "NSDate+SNExtension.h"
#import "NSDateFormatter+SNExtension.h"

#define intervalLeft 15

@implementation DoctorAppointmentListView


+ (CGFloat) cellHeight{
    return 50;
}


- (id)initWithFrame:(CGRect)frame data:(DoctorAppointmentListItem *)data
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(246, 252, 245);
        _data = data;
        
        [self initSubviews];
    }
    
    return self;
}

- (void)setData:(DoctorAppointmentListItem *)data{
    _data = data;
    
    [_tableView reloadData];
}


- (void)initSubviews{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(intervalLeft, 0, kScreenWidth, 60)];
    titleLabel.backgroundColor = self.backgroundColor;
    titleLabel.text = @"请选择约诊时间段";
    titleLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentJustified;
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 - kDefaultLineHeight, kScreenWidth, kDefaultLineHeight)];
    lineView.backgroundColor = kLightLineColor;
    [self addSubview:lineView];

    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, [titleLabel frameHeight], kScreenWidth,self.frame.size.height - [titleLabel frameHeight] - [titleLabel frameY])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    [self addSubview:_tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.selectOrderTimeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DoctorAppointmentListView cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    SelectOrderTime *listData = (SelectOrderTime *)[_data.selectOrderTimeArray objectAtIndex:indexPath.row];
    
//    NSDateFormatter* formatter = [NSDateFormatter dateFormatterWithFormat:[NSDateFormatter timeWithoutSecondFormatString]];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(intervalLeft, (50-14)/2+1, kScreenWidth, 14)];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.text = listData.orderTime;
    [cell addSubview:lable1];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 95 - intervalLeft, 15, 95, 30)];
    button.layer.cornerRadius = 5;
    button.tag = indexPath.row;
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:12];

    if (listData.isOrdered == 0) {
        button.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
        [button setTitle:@"可预约" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        button.layer.backgroundColor = UIColorFromHex(0xe5e5e5).CGColor;
        [button setTitle:@"不可约诊" forState:UIControlStateNormal];
    }
    
    [cell addSubview:button];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}

- (void)btnPress:(UIButton *)sender{
    if(self.clickBlock){
        SelectOrderTime *listData = (SelectOrderTime *)[_data.selectOrderTimeArray objectAtIndex:sender.tag];
        self.clickBlock(listData);
    }
}


@end
