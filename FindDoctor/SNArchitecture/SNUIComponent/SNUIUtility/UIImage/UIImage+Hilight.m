//
//  UIImage+Hilight.m


#import "UIImage+Hilight.h"

@implementation UIImage (Hilight)

- (UIImage *)defaultHilightImage {
    UIColor *redColor = [UIColor colorWithRed:248/255.0 green:76/255.0 blue:75/255.0 alpha:1];
    return [self colorizeImage:self withColor:redColor];
}

- (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    /*
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeScreen);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    */
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
