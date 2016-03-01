//
//  LocationHelper.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-5-6.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

+ (BOOL)locationServicesEnabled
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways);
    }else {
        return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    }
}

@end
