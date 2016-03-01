//
//  SNLogging.h
//  SinaNews
//
//  Created by Fan Lifei on 4/30/12.
//  Copyright (c) 2012 sina. All rights reserved.
//

#ifndef SinaNews_SNLogging_h
#define SinaNews_SNLogging_h

#include <stdio.h>
#import <Foundation/Foundation.h>

#if defined(SN_RELEASE_VERSION) 

#define SN_ASSERT(STATEMENT) do { (void)sizeof(STATEMENT); } while(0)
#define SN_LOG(format, ...) do{}while(0)
#define SN_LOG_MOREINFO(format, ...) do{}while(0)

#else

#define SN_ASSERT(STATEMENT) do { NSAssert(NO,STATEMENT); } while(0)
#define SN_LOG(...) do { NSLog(__VA_ARGS__); [[SNLogging main] log:[NSString stringWithFormat:__VA_ARGS__]]; } while(0)
#define SN_LOG_MOREINFO(format,...) NSLog(@"File:%s\r\nSelector:%@\r\nLine:%d\r\nInfo:\r\n%@",__FILE__,NSStringFromSelector(_cmd),__LINE__,[NSString stringWithFormat:((format)), ##__VA_ARGS__])

#endif

extern char* loggingFileName;

@interface SNLogging : NSObject 
{
@private
    NSString *fileName;
    FILE     *file;
}
@property(nonatomic, copy) NSString *fileName;

+ (SNLogging *)main;
- (void)log:(NSString*)logs withTime:(BOOL)hasTime;
- (void)log:(NSString*)logs;
- (void)clear;
- (void)flush;
- (void)close;

@end


void customExceptionHandler(NSException *cep);

#endif
