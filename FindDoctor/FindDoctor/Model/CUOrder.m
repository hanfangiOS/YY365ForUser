//
//  CUOrder.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrder.h"
#import "NSDateFormatter+SNExtension.h"

@implementation CUOrder

- (instancetype)init
{
    if (self = [super init])
    {
        self.orderStatus = ORDERSTATUS_UNPAID;
        self.service = [[CUService alloc] init];
        self.payment = ORDERPAYMENT_ZhiFuBao;
    }
    return self;
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"orderId=%lu,orderNumber=%@,createTime=%@,finishedTime=%@,orderStatus=%d,contacters=%@,payment=%d,dealPrice=%f,service=%@,remark=%@,serviceCount=%lu",self.orderId,self.orderNumber,self.createTime,self.finishedTime,self.orderStatus,self.contacter,self.payment,self.dealPrice,self.service,self.remark,self.serviceCount];
//}

- (NSString *)orderStatusStr//:(OrderStatus)status
{
    NSString * statusStr = nil;
    switch (self.orderStatus)
    {
        case ORDERSTATUS_UNPAID:
            statusStr = @"未支付";
            break;
        case ORDERSTATUS_CANCELED:
            statusStr = @"已取消";
            break;
        case ORDERSTATUS_FINISHED:
            statusStr = @"已完成";
            break;
        case ORDERSTATUS_PAID:
            statusStr = @"待服务";
            break;
        case ORDERSTATUS_REFUNDED:
            statusStr = @"已退款";
            break;
        default:
            break;
    }
    return statusStr;
}

- (BOOL)shouldRequireDetail
{
    if (self.diagnosisID == 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasDiseaseImage
{
    if (self.service.disease.imageArray.count == 0 && self.service.disease.imageURLArray.count == 0) {
        return NO;
    }
    
    return YES;
}


- (BOOL)isEqual:(CUOrder *)object
{
    if ([object isKindOfClass:[CUOrder class]] && object.diagnosisID == self.diagnosisID) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%lld",self.diagnosisID].hash;
}

- (NSString *)userDesc
{
    NSString *desc = [NSString stringWithFormat:@"%@", self.service.patience.name];
    if ([self.service.patience genderDesc]) {
        desc = [NSString stringWithFormat:@"%@，%@", desc, [self.service.patience genderDesc]];
    }
    
    if (self.service.patience.age) {
        desc = [NSString stringWithFormat:@"%@，%@岁", desc, @(self.service.patience.age)];
    }
    
    if (self.service.patience.cellPhone.length) {
        desc = [NSString stringWithFormat:@"%@，%@", desc, self.service.patience.cellPhone];
    }
    
    return desc;
}

- (NSString *)doctorDesc
{
    NSString *desc = [NSString stringWithFormat:@"%@", self.service.doctor.name];
    if (self.service.doctor.levelDesc.length) {
        desc = [NSString stringWithFormat:@"%@，%@", desc, self.service.doctor.levelDesc];
    }
    
    return desc;
}

- (NSString *)queueNumberDesc
{
    NSString *desc = [NSString stringWithFormat:@"第%@号（共%@号）", @(self.service.queueNumber), @(self.service.queueCount)];
    
    return desc;
}

- (NSString *)dealPriceDesc
{
    return [NSString stringWithFormat:@"￥%.0f", self.dealPrice];
}

- (NSString *)createTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createTimeStamp];
    return [date stringWithDateFormat:[NSDateFormatter timestampWithoutSecondFormatString]];
}

- (NSString *)finishedTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.finishedTimeStamp];
    return [date stringWithDateFormat:[NSDateFormatter timestampWithoutSecondFormatString]];
}

@end

@implementation OrderFilter

@end
