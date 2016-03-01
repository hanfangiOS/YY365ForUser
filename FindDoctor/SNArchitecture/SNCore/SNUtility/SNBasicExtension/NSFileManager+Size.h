//
//  NSFileManager+Size.h
//  SNArchitecture


#import <Foundation/Foundation.h>

/**
 使用c的方式获取文件或文件夹大小
 
 NSFileManager方式，如果有大量的小文件会占用非常多的内存，速度慢
 */
@interface NSFileManager (Size)

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;
+ (unsigned long long)directorySizeAtPath:(NSString *)directoryPath;

@end
