/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Jamie Pinkham
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <TargetConditionals.h>
#import "UIImage+GIF.h"

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else
#import <UIKit/UIKit.h>
#endif

#if ! __has_feature(objc_arc)
#define SDWIAutorelease(__v) ([__v autorelease]);
#define SDWIReturnAutoreleased SDWIAutorelease

#define SDWIRetain(__v) ([__v retain]);
#define SDWIReturnRetained SDWIRetain

#define SDWIRelease(__v) ([__v release]);
#define SDWISafeRelease(__v) ([__v release], __v = nil);
#define SDWISuperDealoc [super dealloc];

#define SDWIWeak
#else
// -fobjc-arc
#define SDWIAutorelease(__v)
#define SDWIReturnAutoreleased(__v) (__v)

#define SDWIRetain(__v)
#define SDWIReturnRetained(__v) (__v)

#define SDWIRelease(__v)
#define SDWISafeRelease(__v) (__v = nil);
#define SDWISuperDealoc

#define SDWIWeak __unsafe_unretained
#endif

NS_INLINE UIImage *SDScaledImageForKey(NSString *key, UIImage *image)
{
    if ([image.images count] > 0)
    {
        NSMutableArray *scaledImages = [NSMutableArray array];
        
        for (UIImage *tempImage in image.images)
        {
            [scaledImages addObject:SDScaledImageForKey(key, tempImage)];
        }
        
        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];
    }
    else
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            CGFloat scale = 1.0;
            if (key.length >= 8)
            {
                // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
                NSRange range = [key rangeOfString:@"@2x." options:0 range:NSMakeRange(key.length - 8, 5)];
                if (range.location != NSNotFound)
                {
                    scale = 2.0;
                }
            }
            
            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            image = scaledImage;
        }
        return image ;
    }
}

NS_INLINE UIImage *SDScaledImageForPath(NSString *path, NSObject *imageOrData)
{
    if (!imageOrData)
    {
        return nil;
    }
    
    UIImage *image = nil;
    if ([imageOrData isKindOfClass:[NSData class]])
    {
        image = [[UIImage alloc] initWithData:(NSData *)imageOrData];
    }
    else if ([imageOrData isKindOfClass:[UIImage class]])
    {
        image = SDWIReturnRetained((UIImage *)imageOrData);
    }
    else
    {
        return nil;
    }
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        CGFloat scale = 1.0;
        if (path.length >= 8)
        {
            // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
            NSRange range = [path rangeOfString:@"@2x." options:0 range:NSMakeRange(path.length - 8, 5)];
            if (range.location != NSNotFound)
            {
                scale = 2.0;
            }
        }
        
        UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
        SDWISafeRelease(image)
        image = scaledImage;
    }
    
    return SDWIReturnAutoreleased(image);
}

/*  for GIF
NS_INLINE UIImage *SDScaledImageForPath(NSString *path, NSObject *imageOrData)
{
    if (!imageOrData)
    {
        return nil;
    }

    UIImage *image = nil;
    if ([imageOrData isKindOfClass:[NSData class]])
    {
        image = [[UIImage alloc] initWithData:(NSData *)imageOrData];
        // modify by 马华  支持gif
        //image = [UIImage sd_animatedGIFWithData:(NSData *)imageOrData];
        //image = [SDScaledImageForKey(path, image) retain];
    }
    else if ([imageOrData isKindOfClass:[UIImage class]])
    {
        image = SDWIReturnRetained((UIImage *)imageOrData);
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
            CGFloat scale = 1.0;
            if (path.length >= 8)
            {
                // Search @2x. at the end of the string, before a 3 to 4 extension length (only if key len is 8 or more @2x. + 4 len ext)
                NSRange range = [path rangeOfString:@"@2x." options:0 range:NSMakeRange(path.length - 8, 5)];
                if (range.location != NSNotFound)
                {
                    scale = 2.0;
                }
            }
            
            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
            SDWISafeRelease(image)
            image = scaledImage;
        }
    }
    else
    {
        return nil;
    }

    return SDWIReturnAutoreleased(image);
}
*/