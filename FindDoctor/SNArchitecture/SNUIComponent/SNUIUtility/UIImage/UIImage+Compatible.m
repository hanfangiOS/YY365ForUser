//
//  UIImage+Compatible.m
//  SinaNews
//
//  Created by nova on 12-10-18.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import "UIImage+Compatible.h"
#import "UIDevice+Resolutions.h"

@implementation UIImage (Compatible)

+ (UIImage *)compatibleNotCachedImageNamed:(NSString *)name
{
    UIImage *image = nil;
    
    if ([[UIDevice currentDevice] retinaResolution]) {
        NSString *extension = [name pathExtension];
        
        NSString *retinaName = [[name stringByDeletingPathExtension] stringByAppendingString:@"@2x"];
        
        if (extension.length != 0)
            retinaName = [retinaName stringByAppendingPathExtension:extension];
        image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:retinaName]];
        if (image == nil) {
            image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name]];
        }
    }
    else {
        image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name]];
        
        if (image == nil) {
            NSString *extension = [name pathExtension];
            
            NSString *retinaName = [[name stringByDeletingPathExtension] stringByAppendingString:@"@2x"];
            
            if (extension.length != 0)
                retinaName = [retinaName stringByAppendingPathExtension:extension];
            image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:retinaName]];
        }
    }
    
    return image;
}

+ (UIImage *)compatibleImageNamed:(NSString *)name
{
    return [self compatibleImageNamed:name shouldCache:YES];
}

+ (UIImage *)compatibleImageNamed:(NSString *)name andNameOf4Inch:(NSString *)nameOf4Inch
{
    return [self compatibleImageNamed:name andNameOf4Inch:nameOf4Inch shouldCache:YES];
}

+ (UIImage *)compatibleImageNamed:(NSString *)name shouldCache:(BOOL)cache
{
    UIImage *image = nil;
    if ([[UIDevice currentDevice] is4InchRetinaResolution]) {
        NSString *extension = [name pathExtension];
        
        NSString *nameOf4Inch = [[name stringByDeletingPathExtension] stringByAppendingString:@"-568h"];
        
        if (extension.length != 0)
            nameOf4Inch = [nameOf4Inch stringByAppendingPathExtension:extension];
        
        if (cache) {
            image = [UIImage imageNamed:nameOf4Inch];
        }
        else {
            image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:nameOf4Inch]];
            
            if (image == nil) {
                image = [[self class] compatibleNotCachedImageNamed:name];
            }
        }
    }
    else {
        if (cache) {
            image = [UIImage imageNamed:name];
        }
        else {
            image = [[self class] compatibleNotCachedImageNamed:name];
        }
    }
    
    return image;
}

+ (UIImage *)compatibleImageNamed:(NSString *)name andNameOf4Inch:(NSString *)nameOf4Inch shouldCache:(BOOL)cache
{
    UIImage *image = nil;
    if ([[UIDevice currentDevice] is4InchRetinaResolution]) {
        if (cache) {
            image = [UIImage imageNamed:nameOf4Inch];
        }
        else {
            image = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:nameOf4Inch]];
            
            if (image == nil) {
                image = [[self class] compatibleNotCachedImageNamed:name];
            }
        }
    }
    else {
        if (cache) {
            image = [UIImage imageNamed:name];
        }
        else {
            image = [[self class] compatibleNotCachedImageNamed:name];
        }
    }
    return image;
}

@end
