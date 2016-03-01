//
//  SNLogging.c
//  SinaNews
//
//  Created by Fan Lifei on 4/30/12.
//  Copyright (c) 2012 sina. All rights reserved.
//

#import "SNLogging.h"
#import <Foundation/Foundation.h>
#include <sys/time.h>

char *loggingFileName = "MyLog.txt";

static SNLogging *main;

@implementation SNLogging
@synthesize fileName;

- (SNLogging *)init
{
    if (self = [super init])
    {
        fileName = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        fileName = [[fileName stringByAppendingPathComponent:[NSString stringWithUTF8String:loggingFileName]] retain];
        file = fopen([fileName UTF8String], "w");
        if (file == NULL)
        {
            NSLog(@"create file failed,");
        }
        else
        {
            NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
            NSString *ident = [[NSBundle mainBundle] bundleIdentifier];
            NSString *ver = [bundle valueForKey:(NSString *)kCFBundleVersionKey];
            NSString *name = [bundle valueForKey:(NSString *)kCFBundleNameKey];
            NSString *shortVer = [bundle valueForKey:@"CFBundleShortVersionString"];
            NSString *dev = [NSString stringWithFormat:@"%@ : %@%@ %@, build time: %s %s\n",ident,name,ver, shortVer, __DATE__, __TIME__];
            fprintf(file,"%s",[dev UTF8String]);
        }
        return self;
    }
    return nil;
}

- (void)dealloc
{
    [fileName release];
    [self close];
    [super dealloc];
}

+ (SNLogging *)main
{
    @synchronized(main)
    {
        if (main == nil)
        {
            main = [[SNLogging alloc] init];
        }
    }
    return main;
}

- (void)logTimeStamp
{
    if (file)
    {
        struct tm t;
        struct timeval tv;
        gettimeofday(&tv,NULL);
        localtime_r(&tv.tv_sec, &t);
        
        fprintf(file, "%02d-%02d-%02d %02d:%02d:%02d.%03d  ",t.tm_year-100,t.tm_mon+1,t.tm_mday,t.tm_hour,t.tm_min,t.tm_sec,tv.tv_usec/1000);
    }
}

- (void)log:(NSString*)logs withTime:(BOOL)hasTime
{
    if (file && logs && [logs length] > 0)
    {
        if (hasTime)
            [self logTimeStamp];
        const char *cstr = [logs UTF8String];
        fprintf(file,"%s",cstr);
        fprintf(file, "\n");
        [self flush];
    }    
}

- (void)log:(NSString*)logs
{
    [self log:logs withTime: YES];
}

- (void)clear
{
    [self close];
    NSError *er = nil;
    [[NSFileManager defaultManager] removeItemAtPath:fileName error:&er];
    if (er)
    {
        NSLog(@"clear log error:%@",er);
    }
}
- (void)flush
{
    if (file)
    {
        fflush(file);
    }
}
- (void)close
{
    if (file)
    {
        [self flush];
        fclose(file);
        file = NULL;
    }
}


@end

// crash exception handler
void customExceptionHandler(NSException *cep)
{
    NSArray *adresses = [cep callStackSymbols];
    [[SNLogging main] log:[NSString stringWithFormat:@"----EXCEPTION!------\n%@\n",[cep reason]]];
    for (int i = 0; i < [adresses count]; i ++) {
        [[SNLogging main] log:[NSString stringWithFormat:@"%@",[adresses objectAtIndex:i]] withTime:NO];
    }
    [[SNLogging main] flush];
    [[SNLogging main] close];
}
