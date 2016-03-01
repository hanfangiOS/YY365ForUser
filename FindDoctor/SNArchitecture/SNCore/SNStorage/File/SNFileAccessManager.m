

#import "SNFileAccessManager.h"
#import "SNFileAccessManagerInner.h"
#import "NSData+SNExtension.h"

typedef enum
{
    SNSupportObjectType_NSData = 0,
    SNSupportObjectType_NSArray = 1,
    SNSupportObjectType_NSDictionary = 2,
    SNSupportObjectType_NSString = 3,
    SNSupportObjectType_UIImage = 4,
    SNSupportObjectType_NSCoding = 5
    
}SNSupportObjectType;

static dispatch_queue_t get_file_io_queue()
{
    static dispatch_queue_t file_io_queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (file_io_queue == NULL) {
            file_io_queue = dispatch_queue_create("com.hyc.huiyangche.file_io_queue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return file_io_queue;
};

static dispatch_queue_t get_file_asyn_io_queue()
{
    static dispatch_queue_t file_asyn_io_queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (file_asyn_io_queue == NULL) {
            file_asyn_io_queue = dispatch_queue_create("com.hyc.huiyangche.file_asyn_io_queue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return file_asyn_io_queue;
};

@interface SNFileAccessManager ()

@property (strong,nonatomic) id<SNStorageProtocol> innerManager;
@property (strong,nonatomic) NSDictionary * supportObjectType;

@end

@implementation SNFileAccessManager

-(id)initWithNameSpace:(NSString*)nameSpace
{
    if (self = [super init])
    {
        self.innerManager = [[SNFileAccessManagerInner alloc] initWithNameSpace:nameSpace];
        self.supportObjectType = @{@"NSData":[NSNumber numberWithInt:SNSupportObjectType_NSData],
                                   @"NSArray":[NSNumber numberWithInt:SNSupportObjectType_NSArray],
                                   @"NSDictionary":[NSNumber numberWithInt:SNSupportObjectType_NSDictionary],
                                   @"NSString":[NSNumber numberWithInt:SNSupportObjectType_NSString],
                                   @"UIImage":[NSNumber numberWithInt:SNSupportObjectType_UIImage],
                                   @"NSCoding":[NSNumber numberWithInt:SNSupportObjectType_NSCoding]};
    }
    return self;
}

//是否有对应的key
-(BOOL)existObjectForKey:(NSString*)key
{
    return [self.innerManager existObjectForKey:key];
}

// 同步：保存数据
-(BOOL)saveObject:(id)obj forKey:(NSString*)key error:(NSError**)error
{
    __block BOOL result = NO;
    dispatch_sync(get_file_io_queue(), ^{
        
        NSData * data = [self setObjectAsData:obj forKey:key];
        if (data != nil)
        {
            result = [self.innerManager saveObject:data forKey:key error:error];
        }
    });
    
    return result;
    
}
// 异步：保存数据
-(void)saveObject:(id)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandle
{
    dispatch_async(get_file_asyn_io_queue(), ^{
        
        NSError * error = nil;
        NSData * data = [self setObjectAsData:obj forKey:key];
        BOOL success = (data!=nil)?YES:NO;
        if (success)
        {
            success = [self.innerManager saveObject:data forKey:key error:&error];
        }
        
        if (completionHandle)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandle(success,error);
            });
        }
    });
}

/*
 这两个方法把object都转成data取出来
 */
// 同步：获取数据
-(id)loadObjectForKey:(NSString*)key error:(NSError**)error
{
    __block id obj = nil;
    dispatch_sync(get_file_io_queue(), ^{
        
        NSData *data = [self.innerManager loadObjectForKey:key error:error];
        obj = [self objectFromData:data];
    });
    return obj;
}
// 异步：获取数据
-(void)loadObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandle
{
    dispatch_async(get_file_asyn_io_queue(), ^{
        
        NSError * error = nil;
        NSData * data = [self.innerManager loadObjectForKey:key error:&error];
        id obj = [self objectFromData:data];
        
        if (completionHandle)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL success = obj ? NO:YES;
                completionHandle(success,error,obj);
                
            });
        }
    });

}

// 同步：删除文件
-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error
{
    __block BOOL success = NO;
    dispatch_sync(get_file_io_queue(), ^{
        
        success = [self.innerManager removeObjectForKey:key error:error];
        
    });
    return success;
}

// 异步：删除文件
-(void)removeObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_file_asyn_io_queue(), ^{
        
        NSError * error = nil;
        BOOL success = [self.innerManager removeObjectForKey:key error:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success,error);
            });
        }
        
    });
}

// 同步：清空整个命名空间
-(BOOL)cleanNameSpaceWithError:(NSError **)error
{
    __block BOOL success = NO;
    dispatch_sync(get_file_io_queue(), ^{
        
        success = [self.innerManager cleanNameSpaceWithError:error];
        
    });
    return success;
}
// 异步：清楚整个命名空间
-(void)cleanNameSpaceCompletionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_file_asyn_io_queue(), ^{
        
        NSError * error = nil;
        BOOL success = [self.innerManager cleanNameSpaceWithError:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success,error);
            });
        }
        
    });

}

// 同步：清空整个命名空间
+(BOOL)cleanNameSpace:(NSString *)nameSpace WithError:(NSError **)error
{
    __block BOOL success = NO;
    dispatch_sync(get_file_io_queue(), ^{
        
        success = [SNFileAccessManagerInner cleanNameSpace:nameSpace withError:error];
        
    });
    return success;
}

// 异步：清楚整个命名空间
+(void)cleanNameSpace:(NSString *)nameSpace completionHandle:(void(^)(BOOL success,NSError* error))completionHandler
{
    dispatch_async(get_file_asyn_io_queue(), ^{
        
        NSError * error = nil;
        BOOL success = [SNFileAccessManagerInner cleanNameSpace:nameSpace withError:&error];
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(success,error);
            });
        }
        
    });

}

@end


@implementation SNFileAccessManager (NSData)

- (NSData *)setObjectAsData:(id)object forKey:(NSString *)key
{
    NSMutableData * finalData = nil;
    if (object != nil)
    {
        // 将Object的类型保存起来，都是基本类型，比如NSString、NSArray、NSDictionary、UIImage、NSCoding
        BOOL isCoding = [object conformsToProtocol:@protocol(NSCoding)];
        int type = isCoding ? [self typeOfSupportingObject:object isCoding:YES]:[self typeOfSupportingObject:object isCoding:NO];
        
        finalData = [[NSMutableData alloc] initWithBytes:&type length:sizeof(type)];
        if (isCoding)
        {
            [finalData appendData:[NSKeyedArchiver archivedDataWithRootObject:object]];
        }
        else if ([object conformsToProtocol:@protocol(NSDataProtocol)])
        {
            [finalData appendData:[object data]];
        }
    }
  
    return finalData;
}


- (id)objectFromData:(NSData *)data
{
    id result = nil;
    if(data.length > 2)
    {
        int type = 0;
        NSData *typeHeader = [data subdataWithRange:NSMakeRange(0, sizeof(type))];
        [typeHeader getBytes:&type];
        
        NSData *dataContent = [data subdataWithRange:NSMakeRange(sizeof(type), data.length - sizeof(type))];
        switch (type)
        {
            case SNSupportObjectType_NSData:
            {
                result = dataContent;
            }
                break;
            case SNSupportObjectType_NSArray:
            {
                result = [dataContent array];
            }
                break;
            case SNSupportObjectType_NSDictionary:
            {
                result = [dataContent dictionary];
            }
                break;
            case SNSupportObjectType_NSString:
            {
                result = [dataContent UTF8String];
            }
                break;
            case SNSupportObjectType_UIImage:
            {
                result = [dataContent image];
            }
                break;
            case SNSupportObjectType_NSCoding:
            {
                result = [NSKeyedUnarchiver unarchiveObjectWithData:dataContent];
            }
                break;
                
            default:
                break;
        }
        
    }
    return result;
}

- (int)typeOfSupportingObject:(id)object isCoding:(BOOL)isCoding
{
    __block int type = 0;
    if (isCoding)
    {
        type = [[self.supportObjectType objectForKey:@"NSCoding"] intValue];
    }
    else
    {
        [self.supportObjectType enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSNumber * obj, BOOL *stop)
        {
            if ([object isKindOfClass:NSClassFromString(key)])
            {
                type = [object intValue];
            }
        }];
    }
    return type;
}


@end



