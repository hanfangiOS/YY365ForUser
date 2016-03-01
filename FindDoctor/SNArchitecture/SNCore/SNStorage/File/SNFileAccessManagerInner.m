//
//  SNFileAccessManagerInner.m


#import "SNFileAccessManagerInner.h"
#import "NSFileManager+Size.h"

@interface SNFileAccessManagerInner()

@property(strong,nonatomic) NSString * nameSpace;
@property(strong,nonatomic) NSString * fullStoragePath;

@end


@implementation SNFileAccessManagerInner

+ (NSString *)fullPathWithNameSpace:(NSString *)spaceName
{
    if (spaceName == nil) {
        return nil;
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullFileName = [NSString stringWithFormat:@"%@",spaceName];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fullFileName];
    return path;

}

+ (NSString *)fullFilePathForKey:(NSString *)key nameSpace:(NSString *)nameSpace
{
    if (key == nil) {
        return nil;
    }
    return [[[self class] fullPathWithNameSpace:nameSpace] stringByAppendingPathComponent:key];

}

-(id)initWithNameSpace:(NSString*)nameSpace
{
    self = [super init];
    if (self)
    {
        self.nameSpace = nameSpace;
        //新建namesapce目录
        [[NSFileManager defaultManager] createDirectoryAtPath:self.fullStoragePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}

- (NSString *)fullStoragePath
{
    if (_fullStoragePath.length == 0)
    {
        _fullStoragePath = [[self class] fullPathWithNameSpace:self.nameSpace];
    }
    return _fullStoragePath;
}

-(NSError*)createError:(NSString*)description errorCode:(NSInteger)code
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"com.huiyangche.hyc" code:code userInfo:userInfo];
}

- (NSString *)filePathForKey:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    return [self.fullStoragePath stringByAppendingPathComponent:key];
}

//是否存在key
-(BOOL)existObjectForKey:(NSString*)key
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePathForKey:key]]?YES:NO;
}

//同步读取key
-(NSData*)loadObjectForKey:(NSString*)key error:(NSError**)error
{
    NSString *path = [self filePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 更新文件修改时间，以便不被清除
    [[NSFileManager defaultManager] setAttributes: @{NSFileModificationDate: [NSDate date]} ofItemAtPath:path error:nil];
    return data;
}

//同步保存key
-(BOOL)saveObject:(NSData*)obj forKey:(NSString*)key error:(NSError**)error
{
    if ([obj isEqual:[NSNull null]])
    {
        if (error) {
            *error = [self createError:@"not support Null value" errorCode:-1];
        }
        return FALSE;
    }
    //新建namesapce目录
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.fullStoragePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.fullStoragePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[NSFileManager defaultManager] createFileAtPath:[self filePathForKey:key] contents:obj attributes:nil];
}

//同步移除key
-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error
{
    if ([self existObjectForKey:key])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:[self filePathForKey:key] error:error];
    }
    return YES;
}

//清空整个命名空间
-(BOOL)cleanNameSpaceWithError:(NSError **)error
{
    return [[self class] cleanNameSpace:self.nameSpace withError:error];
}

+(BOOL)cleanNameSpace:(NSString *)nameSpace withError:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:[[self class] fullPathWithNameSpace:nameSpace] error:error];
}

@end

@implementation SNFileAccessManagerInner(Size)

+(CGFloat)sizeOfNameSpace:(NSString *)nameSpace
{
    return [NSFileManager directorySizeAtPath:[[self class] fullPathWithNameSpace:nameSpace]];
}

- (CGFloat)sizeOfObjectForKey:(NSString *)key
{
    return  [[self class] sizeOfObjectForKey:key underNameSpace:self.nameSpace];
}

+ (CGFloat)sizeOfObjectForKey:(NSString *)key underNameSpace:(NSString *)nameSpace
{
    CGFloat theSize = 0.0;
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    theSize = [[[fileManager attributesOfItemAtPath:[[self class] fullFilePathForKey:key nameSpace:nameSpace] error:nil] objectForKey:@"NSFileSize"] floatValue];
//    return theSize;
    theSize = [NSFileManager fileSizeAtPath:[[self class] fullFilePathForKey:key nameSpace:nameSpace]];
    return theSize;
}


@end

