//
//  DiseaseSubject.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/11.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "DiseaseSubject.h"

@implementation DiseaseSubject

+ (NSArray *)contentsWithName:(NSString *)name{
    NSArray *array = @[@"全部"];
    if([name isEqualToString:@"内科"]){
        array = [array arrayByAddingObjectsFromArray:[self neike]];
    }
    if([name isEqualToString:@"妇科"]){
        array = [array arrayByAddingObjectsFromArray:[self fuke]];
    }
    if([name isEqualToString:@"儿科"]){
        array = [array arrayByAddingObjectsFromArray:[self erke]];
    }
    if([name isEqualToString:@"皮肤科"]){
        array = [array arrayByAddingObjectsFromArray:[self pifuke]];
    }
    if([name isEqualToString:@"五官科"]){
        array = [array arrayByAddingObjectsFromArray:[self wuguanke]];
    }
    if([name isEqualToString:@"骨科"]){
        array = [array arrayByAddingObjectsFromArray:[self guke]];
    }
    if([name isEqualToString:@"男科"]){
        array = [array arrayByAddingObjectsFromArray:[self nanke]];
    }
    if([name isEqualToString:@"针灸科"]){
        array = [array arrayByAddingObjectsFromArray:[self zhenjiuke]];
    }
    if([name isEqualToString:@"全科"]){
        array = [array arrayByAddingObjectsFromArray:[self quanke]];
    }
    return array;
}

+ (NSArray *)neike{
    NSArray *array = @[@"脾胃肾病",@"心脑血管病",@"消化系统疾病",@"呼吸系统疾病",@"内分泌疾病",@"神经系统疾病",@"高血压、糖尿病",@"其他内科疾病"];
    return array;
}

+ (NSArray *)fuke{
    NSArray *array = @[@"乳腺疾病",@"月经病",@"妊娠疾病",@"其他妇科疾病"];
    return array;
}

+ (NSArray *)erke{
    NSArray *array = @[@"感冒、咳嗽、发烧",@"腹泻、腹胀、厌食",@"遗尿、盗汗、睡眠惊醒",@"其它儿科疾病"];
    return array;
}

+ (NSArray *)pifuke{
    NSArray *array = @[@"湿疹、皮肤瘙痒",@"痤疮、牛皮癣、白癜风",@"酒糟鼻、灰指甲",@"其他皮肤科疾病"];
    return array;
}

+ (NSArray *)wuguanke{
    NSArray *array = @[@"眼科",@"耳鼻喉科",@"口腔科"];
    return array;
}

+ (NSArray *)guke{
    NSArray *array = @[@"骨折骨裂",@"跌打损伤",@"其他骨科疾病"];
    return array;
}

+ (NSArray *)nanke{
    NSArray *array = @[@"性功能障碍",@"泌尿系统感染",@"男性不育",@"其他男性疾病"];
    return array;
}

+ (NSArray *)zhenjiuke{
    NSArray *array = @[@"针灸",@"推拿",@"其它针灸疾病"];
    return array;
}

+ (NSArray *)quanke{
    NSArray *array = @[];
    return array;
}


@end
