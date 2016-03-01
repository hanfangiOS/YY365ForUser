//
//  SNNetworkImageCache.m
//  Weibo
//
//  Created by Wade Cheng on 3/15/12.
//  Copyright (c) 2012 Sina. All rights reserved.
//

#import "SNNetworkImageCache.h"
#import <CommonCrypto/CommonDigest.h>

#define kMaximumImageCacheSize          10                  // 10 MB.
#define kMaximumImageCacheCount         200
#define kMaximumImageCacheAge           60 * 60 * 24 * 7    // 1 week

#ifndef SN_NETWORKING_IMAGE_CACHE_DIRECTORY
#define SN_NETWORKING_IMAGE_CACHE_DIRECTORY @"SNImageCache"
#endif

static dispatch_queue_t _image_disk_cache_operation_queue;
static dispatch_queue_t image_disk_cache_operation_queue() {
    if (_image_disk_cache_operation_queue == NULL) {
        _image_disk_cache_operation_queue = dispatch_queue_create("com.sina.weibo.image_disk_cache_operation_queue", 0);
    }
    
    return _image_disk_cache_operation_queue;
}

@implementation SNNetworkImageCache

#pragma mark - Memory management

+ (SNNetworkImageCache *)sharedCache
{
    static SNNetworkImageCache *_sharedImageCache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedImageCache = [[self alloc] initWithCacheDirectory:SN_NETWORKING_IMAGE_CACHE_DIRECTORY];
    });
    
    return _sharedImageCache;
}

- (id)initWithCacheDirectory:(NSString *)directory
{
    if ((self = [super init]))
    {
        memCache = [[NSCache alloc] init];
        [memCache setTotalCostLimit:kMaximumImageCacheSize * 1024 * 1024];
        [memCache setCountLimit:kMaximumImageCacheCount];
        
        if (!directory)
        {
            directory = @"SNImageCache";
        }
        
        [diskCachePath release];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        diskCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:directory] retain];
        
        diskCachePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:directory] retain];//
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [memCache release], memCache = nil;
    [diskCachePath release], diskCachePath = nil;
    
    [super dealloc];
}

#pragma mark - Key of Path

- (NSString *)cachePathForURL:(NSString *)URL
{
    const char *str = [URL UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return [diskCachePath stringByAppendingPathComponent:filename];
}

#pragma mark - Read / Write cache

- (void)storeImageDataToDisk:(NSData *)imageData forURL:(NSString *)URL sync:(BOOL)isSync
{
    void (^storeImageToDiskBlock)(void) = ^(void) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSString *cachePath = [self cachePathForURL:URL];
        
        if (![fileManager fileExistsAtPath:cachePath])
        {
            [fileManager createFileAtPath:cachePath contents:imageData attributes:nil];
        }
        
        [fileManager release];
    };
    
    if (isSync)
    {
        dispatch_sync(image_disk_cache_operation_queue(), storeImageToDiskBlock);
    }
    else
    {
        dispatch_async(image_disk_cache_operation_queue(), storeImageToDiskBlock);
    }
}

- (void)storeImage:(UIImage *)image withData:(NSData *)imageData forURL:(NSString *)URL sync:(BOOL)isSync
{
    if (!URL || (!image && !imageData))
    {
        return;
    }
    
    if (image)
    {
//        @synchronized(memCache)
//        {
//            [memCache setObject:image forKey:URL cost:image.size.width * image.size.height * 4];
//        }
        
        if (!imageData)
        {
            imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        }
        
        // 有可能出现image处理不了的情况，所以还需要再次判断imageData是否为空
        if (imageData)
        {
            [self storeImageDataToDisk:imageData forURL:URL sync:isSync];
        }
    }
    else if (imageData.length > 0)
    {
//        @synchronized(memCache)
//        {
//            [memCache setObject:imageData forKey:URL cost:imageData.length];
//        }
        [self storeImageDataToDisk:imageData forURL:URL sync:isSync];
    }
}

- (void)storeImageData:(NSData *)imageData forURL:(NSString *)URL sync:(BOOL)isSync
{
    [self storeImage:nil withData:imageData forURL:URL sync:isSync];
}

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL sync:(BOOL)isSync
{
    [self storeImage:image withData:nil forURL:URL sync:isSync];
}

- (void)storeImageData:(NSData *)imageData forURL:(NSString *)URL
{
    [self storeImageData:imageData forURL:URL sync:NO];
}

- (void)storeImage:(UIImage *)image withData:(NSData *)imageData forURL:(NSString *)URL
{
    [self storeImage:image withData:imageData forURL:URL sync:NO];
}

- (void)storeImage:(UIImage *)image forURL:(NSString *)URL
{
    [self storeImage:image forURL:URL sync:NO];
}

- (void)removeImageForURL:(NSString *)URL
{
    if (!URL)
    {
        return;
    }
    
    [memCache removeObjectForKey:URL];
    
    dispatch_async(image_disk_cache_operation_queue(), ^(void) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:[self cachePathForURL:URL] error:nil];
        [fileManager release];
    });
}

- (UIImage *)imageFromURL:(NSString *)URL
{
    if (!URL)
    {
        return nil;
    }
    
    UIImage *image = [[[memCache objectForKey:URL] retain] autorelease];
    
    if (!image)
    {
        NSString *cachePath = [self cachePathForURL:URL];
        NSData *imageData = [NSData dataWithContentsOfFile:cachePath];
        
        if (imageData)
        {
            image = [UIImage imageWithData:imageData];

            if (!image)
            {
                dispatch_async(image_disk_cache_operation_queue(), ^{
                    NSFileManager *fileManager = [[NSFileManager alloc] init];
                    [fileManager removeItemAtPath:cachePath error:nil];
                    [fileManager release];
                });
            }
            else
            {
//                @synchronized(memCache)
//                {
//                    [memCache setObject:image forKey:URL cost:image.size.width * image.size.height * 4];
//                }
            }
        }
    }
    else if ([image isKindOfClass:[NSData class]])
    {
        // 如果mem里面缓存的是data则进行转化
        image = [UIImage imageWithData:(NSData *)image];
    }
    
    return image;
}

- (NSData *)imageDataFromURL:(NSString *)URL
{
    if (!URL)
    {
        return nil;
    }
    
    NSData *imageData = [[[memCache objectForKey:URL] retain] autorelease];
    
    if (!imageData)
    {
        NSString *cachePath = [self cachePathForURL:URL];
        imageData = [NSData dataWithContentsOfFile:cachePath];
    }
    
    return imageData;
}

- (BOOL)hasMemoryCachedURL:(NSString *)URL
{
    if (!URL)
    {
        return NO;
    }
    
    if ([memCache objectForKey:URL])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasDiskCachedURL:(NSString *)URL
{
    if (!URL)
    {
        return NO;
    }
    
    NSString *cachePath = [self cachePathForURL:URL];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL fileExists = [fileManager fileExistsAtPath:cachePath];
    [fileManager release];
    
    return fileExists;
}

- (BOOL)hasCachedURL:(NSString *)URL
{
    return [self hasMemoryCachedURL:URL] || [self hasDiskCachedURL:URL];
}

#pragma mark - Clean cache

- (void)clearCache
{
    [self clearDisk];
}

- (void)clearMemory
{
    [memCache removeAllObjects];
}

- (void)clearDisk
{
    dispatch_async(image_disk_cache_operation_queue(), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:diskCachePath error:nil];
        [fileManager createDirectoryAtPath:diskCachePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
        [fileManager release];
    });
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-kMaximumImageCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    dispatch_async(image_disk_cache_operation_queue(), ^{
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        for (NSString *fileName in fileEnumerator)
        {
            NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [fileManager attributesOfItemAtPath:filePath error:nil];
            if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
            {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
        [fileManager release];
    });
}

@end
