//
//  DoctorApoointmentForHourScrollView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/19.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "DoctorApoointmentForHourScrollView.h"
#import "TitleView.h"

@implementation DoctorApoointmentForHourScrollView{
    UIScrollView *contentScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame data:(Doctor *)data{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        [self loadContentScrollView];
        [self loadPageControl];
        [self initSubView];
    }
    return self;
}

- (void)loadContentScrollView{
    TitleView *titleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, [self frameWidth], 30) title:@"诊金"];
    [self addSubview:titleView];
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(titleView.frame),[self frameWidth], [self frameHeight] - 30)];
    contentScrollView.contentSize = CGSizeMake([self frameWidth] * _data.appointmentList.count, [self frameHeight]-30);
//    contentScrollView.backgroundColor = UIColorFromHex(0xeeeeee);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:contentScrollView];
}

- (void)loadPageControl{
    _pageControl = [[CUPageControl alloc]initWithFrame:CGRectMake(0,[self frameHeight] - 15, [self frameWidth], 15)];
    _pageControl.numberOfPages = _data.appointmentList.count;
    _pageControl.userInteractionEnabled = NO;
    [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}

- (void)initSubView{
    int paddingLeft = 20;
    int paddingY = 15;
    int intervalY = 15;
    int lableHight = 12;
    int fontSize = 12;
    for (int i = 0; i < _data.appointmentList.count;  i++ ) {
        DoctorAppointmentListItem *item = (DoctorAppointmentListItem *)[_data.appointmentList objectAtIndex:i];
        
        NSString *fee = [NSString stringWithFormat:@"%.2lf",item.fee/100.f];
        NSString *appointment = [NSString stringWithFormat:@"已预约：%ld /共 %ld 个",item.numOrder,item.numRelease];
        NSString *time = [NSString stringWithFormat:@"时间：%@",item.releaseTime];
        NSString *address = [NSString stringWithFormat:@"地点：%@ (%@)",item.clinicName,item.clinicAddr];
        
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(i * [self frameWidth], 0, [self frameWidth], [self frameHeight])];
        [contentScrollView addSubview:subView];
        
        UILabel *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLeft, paddingY, [subView frameWidth] - 2 * paddingLeft, lableHight)];
        feeLabel.font = [UIFont systemFontOfSize:fontSize];
        feeLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
        feeLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"诊疗费：%@ 元/次",fee]];
        [atrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(Color_Hex_Text_Highlighted) range:NSMakeRange(4, fee.length)];
        [atrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize+4] range:NSMakeRange(4, fee.length)];
        feeLabel.attributedText = atrStr;
        [subView addSubview:feeLabel];
        
        UILabel *appointmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLeft, CGRectGetMaxY(feeLabel.frame)+intervalY, [subView frameWidth] - 2 * paddingLeft, lableHight)];
        appointmentLabel.font = [UIFont systemFontOfSize:fontSize];
        appointmentLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
        appointmentLabel.textAlignment = NSTextAlignmentLeft;
        atrStr = [[NSMutableAttributedString alloc]initWithString:appointment];
        [atrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(Color_Hex_Text_Highlighted) range:NSMakeRange(4, atrStr.length - 4)];
        [atrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize+4] range:NSMakeRange(4, atrStr.length - 4)];
        appointmentLabel.attributedText = atrStr;
        [subView addSubview:appointmentLabel];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLeft, CGRectGetMaxY(appointmentLabel.frame)+intervalY, [subView frameWidth] - 2 * paddingLeft, lableHight)];
        timeLabel.font = [UIFont systemFontOfSize:fontSize];
        timeLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.text = time;
        [subView addSubview:timeLabel];
        
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingLeft, CGRectGetMaxY(timeLabel.frame)+intervalY, [subView frameWidth] - 2 * paddingLeft, lableHight)];
        addressLabel.font = [UIFont systemFontOfSize:fontSize];
        addressLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
        addressLabel.textAlignment = NSTextAlignmentLeft;
        addressLabel.text = address;
        [subView addSubview:addressLabel];
    }
}

- (void)pageChange:(UIPageControl *)sender{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = contentScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [contentScrollView scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == contentScrollView) {
        //设置PageControl页数
        NSLog(@"起始页 页数：%ld",_pageControl.currentPage );
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.frame;
        [_pageControl setCurrentPage:offset.x / bounds.size.width];
        NSLog(@"停止页 页数 ：%ld",_pageControl.currentPage);
    }
}


@end
