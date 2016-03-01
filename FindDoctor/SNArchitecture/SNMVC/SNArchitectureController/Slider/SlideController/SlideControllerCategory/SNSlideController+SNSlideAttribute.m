//
//  SNSlideController+SNSlideAttribute.m
//  SNSlideController
//
//  Created by Nova on 13-4-1.
//  Copyright (c) 2013年. All rights reserved.
//

#import "SNSlideController+SNSlideAttribute.h"

@implementation SNSlideController (SNSlideAttribute)

- (void)initAttributes
{
    SNSlideAttribute attr;
    
    attr = [self defaultAttributeForTopController];
    if (self.leftController) {
        attr.slideToRightEnable = YES;
    }
    if (self.rightController) {
        attr.slideToLeftEnable = YES;
    }
    if (self.topController)
    {
        [self setAttribute:attr forController:self.topController];
    }
    
    
    attr = [self defaultAttributeForLeftController];
    if (self.leftController) {
        [self setAttribute:attr forController:self.leftController];
    }
    
    
    attr = [self defaultAttributeForRightController];
    if (self.rightController) {
        [self setAttribute:attr forController:self.rightController];
    }
    
}

- (SNSlideAttribute)defaultAttribute
{
    SNSlideAttribute attr;
    attr.slideToLeftEnable = NO;
    attr.slideToRightEnable = NO;
    attr.alwaysBounceLeft = NO;
    attr.alwaysBounceRight = NO;
    
    return attr;
}

- (SNSlideAttribute)defaultAttributeForTopController
{
    SNSlideAttribute attr = [self defaultAttribute];
    attr.slideToLeftEnable = YES;
    attr.slideToRightEnable = YES;
    attr.alwaysBounceLeft = YES;
    attr.alwaysBounceRight = YES;
    
    return attr;
}

- (SNSlideAttribute)defaultAttributeForLeftController
{
    SNSlideAttribute attr = [self defaultAttribute];
    attr.slideToLeftEnable = NO;
    attr.slideToRightEnable = NO;
    
    return attr;
}

- (SNSlideAttribute)defaultAttributeForRightController
{
    SNSlideAttribute attr = [self defaultAttribute];
    attr.slideToLeftEnable = NO;
    attr.slideToRightEnable = NO;
    
    return attr;
}

- (void)setAttribute:(SNSlideAttribute)attribute forController:(SNViewController *)controller
{
    NSValue *value = [NSValue value:&attribute withObjCType:@encode(SNSlideAttribute)];
    [self.attributesDict setObject:value forKey:controller.identifier];
}

- (void)removeAttributeForController:(SNViewController *)controller
{
    [self.attributesDict removeObjectForKey:controller.identifier];
}

- (SNSlideAttribute)attributeForController:(SNViewController *)controller
{
    SNSlideAttribute attr;
    NSValue *value = [self.attributesDict objectForKey:controller.identifier];
    [value getValue:&attr];
    
    return attr;
}

@end
