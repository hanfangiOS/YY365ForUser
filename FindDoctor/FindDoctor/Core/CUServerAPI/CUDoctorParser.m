//
//  CUDoctorParser.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUDoctorParser.h"
#import "Doctor.h"
#import "SubObject.h"

@implementation CUDoctorParser

- (id)parseDoctorListWithDict:(NSDictionary *)dict
{
    SNBaseListModel * lists = nil;
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        lists = [[SNBaseListModel alloc] init];
        lists.pageInfo = [self parsePageInfoWithDict:data];
        [[data objectForKeySafely:@"list"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            
            [lists.items addObjectSafely:[self doctorWithDict:obj]];
            
        }];
    }
    return lists;
}

- (id)parseDoctorDetailWithDict:(NSDictionary *)dict
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if (!self.hasError)
    {
        return [self doctorWithDict:data];
    }
    
    return nil;
}

- (id)parseSubObjectListWithDict:(NSDictionary *)dict;
{
    SNBaseListModel *lists = nil;
    NSDictionary *data = [self parseBaseDataWithDict:dict];
    if (!self.hasError) {
        lists = [[SNBaseListModel alloc] init];
        lists.pageInfo = [self parsePageInfoWithDict:data];
        [[data objectForKeySafely:@"list"] enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            
            [lists.items addObjectSafely:[self doctorWithDict:obj]];
            
        }];
    }
    return lists;
}

- (Doctor *)doctorWithDict:(NSDictionary *)dict
{
    Doctor *doctor = [[Doctor alloc] init];
    doctor.doctorId = [dict valueForKeySafely:@"doctor_id"];
    doctor.name = [dict valueForKeySafely:@"name"];
    doctor.phoneNumber = [dict valueForKeySafely:@"phone_number"];
    doctor.subject = [dict valueForKeySafely:@"subject"];
    doctor.address = [dict valueForKeySafely:@"address"];

    return doctor;
}

- (SubObject *)subobjectWithDict:(NSDictionary *)dict
{
    SubObject *subobject = [[SubObject alloc] init];
    subobject.imageURL = [dict valueForKeyPathSafely:@"imageURL"];
    subobject.type_id = [dict valueForKeyPathSafely:@"type_id"];
    subobject.name = [dict valueForKeyPathSafely:@"name"];
    NSArray *sub_types = [dict valueForKeyPathSafely:@"sub_types"];
    NSMutableArray *tempSubTypes = [NSMutableArray new];
    [sub_types enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [tempSubTypes addObjectSafely:[self subtypeObjectWithDict:obj]];
    }];
    subobject.sub_types = tempSubTypes;
    return subobject;
}

- (SubTypeObject *)subtypeObjectWithDict:(NSDictionary *)dict
{
    SubTypeObject *subtypeObject = [[SubTypeObject alloc] init];
    subtypeObject.subType_id = [dict objectForKeySafely:@"subType_id"];
    subtypeObject.imageURL = [dict objectForKeySafely:@"imageURL"];
    subtypeObject.name = [dict objectForKeySafely:@"name"];
    return subtypeObject;
}

@end
