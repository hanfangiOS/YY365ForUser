//
//  SNStorageProtocol.h
//  底层数据存储协议，全部都是同步方式，异步方式写在具体的实现的类中


#import <Foundation/Foundation.h>

@protocol SNStorageProtocol <NSObject>

//是否存在key
-(BOOL)existObjectForKey:(NSString*)key;

//同步读取key
-(NSData*)loadObjectForKey:(NSString*)key error:(NSError**)error;

//同步保存key
-(BOOL)saveObject:(NSData*)obj forKey:(NSString*)key error:(NSError**)error;

//同步移除key
-(BOOL)removeObjectForKey:(NSString*)key error:(NSError **)error;

@optional
//清空整个命名空间
-(BOOL)cleanNameSpaceWithError:(NSError **)error;

-(id)initWithNameSpace:(NSString*)nameSpace;

@end
