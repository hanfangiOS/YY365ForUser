//
//  CUPlatFormManager.m
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUPlatFormManager.h"
#import "AppCore.h"

#define Platform_PlistName  @"platform.plist"

@implementation CUPlatFormManager

SINGLETON_IMPLENTATION(CUPlatFormManager);

#pragma mark ============= 类便利方法 =============
//获取info.plist里面的版本号
+ (NSString*)currentAppVersion // d.d.d
{
    NSString *curVersionString = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    return curVersionString;
}

+ (NSInteger)changeVersionFromStringToInt:(NSString *)version
{
    NSString * newVersion = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    // 防止两位数出现.如3.3,这样就会出错.
    if ([newVersion length] == 2) {
        newVersion = [newVersion stringByAppendingFormat:@"0"];
    }
    return [newVersion intValue];
}

//版本（2.7.0）转化为数字 270
//版本号必需为3位数.不能是3.3或者3.3.3.1,这样就会出现比较错误.
+ (NSInteger)appVersionNumInBundle   //  000
{
    NSString *curVersionString = [self currentAppVersion];
    return [self changeVersionFromStringToInt:curVersionString];
}

- (id)init
{
    if (self = [super init])
    {
        _isNewInstall = NO;
        _isCoverInstall = NO;
    }
    return self;
}

#pragma mark --------- 加载存储 ---------

- (void)sychronizeVersion
{
    self.platform.oldVersion = [CUPlatFormManager appVersionNumInBundle];
}

- (void)clearPlatformPreVersionData // 升级安装的时候 ,有些数据要初始化.
{
    [self.platform setDefaultValue];
}

- (void)appInstallStatistics
{
    // 本地版本号
    int versionCache = self.platform.oldVersion;
    
    // runtime的版本号
    int versionCurrent = [CUPlatFormManager appVersionNumInBundle];
    
    if (versionCurrent == versionCache)
    {
        return;
    }
    else
    {
        // TODO 去掉
        if (versionCache == 0)
        {
            //全新安装
            [self clearPlatformPreVersionData];
            
            self.platform.oldVersion = versionCurrent;
            
            _isNewInstall = YES;
        }
        else
        {
            if (versionCurrent > versionCache)
            {
                _isCoverInstall = YES;
                
                [self clearPlatformPreVersionData];
            }
        }
    }
}

- (void)load
{
    if ( self.platform == nil )
    {

        self.platform = [[AppCore sharedInstance].fileAccessManager loadObjectForKey:Platform_PlistName error:nil];
        if ( self.platform == nil )
        {
            Platform *plat = [[Platform alloc] init];
            self.platform = plat;
        }
        
        int versionCurrent = [CUPlatFormManager appVersionNumInBundle];
        if (versionCurrent > self.platform.oldVersion)
        {
            [self appInstallStatistics];
        }
    }
}

- (void)save
{
    [[AppCore sharedInstance].fileAccessManager saveObject:self.platform forKey:Platform_PlistName error:nil];
}

@end
