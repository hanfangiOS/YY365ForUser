
/*
 本类提供文件相关的操作，整个File存储都放在document这个路径下，把所有常用数据，转化成data来存和取
 1、数据存文件，同步异步
 2、读文件数据，同步异步
 3、清除文件，同步异步
 4、删除过期文件 TODO
 */


#import <Foundation/Foundation.h>

@interface SNFileAccessManager : NSObject

-(id)initWithNameSpace:(NSString*)nameSpace;

//是否有对应的key
-(BOOL)existObjectForKey:(NSString*)key;

// 同步：保存数据
-(BOOL)saveObject:(id)obj forKey:(NSString*)key error:(NSError**)error;
// 异步：保存数据
-(void)saveObject:(id)obj forKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandle;

/*
 这两个方法把object都转成data取出来
 */
// 同步：获取数据
-(id)loadObjectForKey:(NSString*)key error:(NSError**)error;
// 异步：获取数据
-(void)loadObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error,id obj))completionHandle;

// 同步：删除文件
-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error;
// 异步：删除文件
-(void)removeObjectForKey:(NSString*)key completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

// 同步：清空整个命名空间
-(BOOL)cleanNameSpaceWithError:(NSError **)error;
// 异步：清楚整个命名空间
-(void)cleanNameSpaceCompletionHandle:(void(^)(BOOL success,NSError* error))completionHandler;

// 同步：清空整个命名空间
+(BOOL)cleanNameSpace:(NSString *)nameSpace WithError:(NSError **)error;
// 异步：清楚整个命名空间
+(void)cleanNameSpace:(NSString *)nameSpace completionHandle:(void(^)(BOOL success,NSError* error))completionHandler;
//
//TODO删除过期文件



@end

@interface SNFileAccessManager (NSData)

- (NSData *)setObjectAsData:(id)object forKey:(NSString *)key;
- (id)objectFromData:(NSData *)data;

@end




