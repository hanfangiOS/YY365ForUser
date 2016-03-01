//
//  UIDevice+Resolutions.m
//  TBClient
//


#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

NSString *NSStringFromResolution(UIDeviceResolution resolution)
{
	switch (resolution) {
		case UIDeviceResolution_iPhoneStandard:
			return @"iPhone Standard";
			break;
		case UIDeviceResolution_iPhoneRetina35:
			return @"iPhone Retina 3.5\"";
			break;
		case UIDeviceResolution_iPhoneRetina4:
			return @"iPhone Retina 4\"";
			break;
		case UIDeviceResolution_iPadStandard:
			return @"iPad Standard";
			break;
		case UIDeviceResolution_iPadRetina:
			return @"iPad Retina";
			break;
		case UIDeviceResolution_Unknown:
		default:
			return @"Unknown";
			break;
	}
}

- (UIDeviceResolution)resolution
{
	UIDeviceResolution resolution = UIDeviceResolution_Unknown;
	UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
	CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		if (scale == 2.0f) {
			if (pixelHeight == 960.0f)
				resolution = UIDeviceResolution_iPhoneRetina35;
			else if (pixelHeight == 1136.0f)
				resolution = UIDeviceResolution_iPhoneRetina4;
            
		} else if (scale == 1.0f && pixelHeight == 480.0f)
			resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
		if (scale == 2.0f && pixelHeight == 2048.0f) {
			resolution = UIDeviceResolution_iPadRetina;
            
		} else if (scale == 1.0f && pixelHeight == 1024.0f) {
			resolution = UIDeviceResolution_iPadStandard;
		}
	}
    
	return resolution;
}

- (CGSize)resolutionSize
{
   CGSize resolusionSize = CGSizeZero;
   UIDeviceResolution resolution = [[UIDevice currentDevice] resolution];
    switch (resolution) {
        case UIDeviceResolution_iPhoneStandard:
            resolusionSize = CGSizeMake(320, 480);
            break;
        case UIDeviceResolution_iPhoneRetina35:
            resolusionSize = CGSizeMake(640, 960);
            break;
        case UIDeviceResolution_iPhoneRetina4:
            resolusionSize = CGSizeMake(640, 1136);
            break;
        case UIDeviceResolution_iPadStandard:
            resolusionSize = CGSizeMake(1024, 768);
            break;
        case UIDeviceResolution_iPadRetina:
            resolusionSize = CGSizeMake(2048, 1536);
            break;
            
        default:
            break;
    }
    
    return resolusionSize;
}

- (CGSize)resolutionIphoneOnly
{
    CGSize resolusionSize = CGSizeZero;
    UIDeviceResolution resolution = [[UIDevice currentDevice] resolution];
    switch (resolution) {
        
        case UIDeviceResolution_iPadStandard:
        case UIDeviceResolution_iPhoneStandard:
            resolusionSize = CGSizeMake(320, 480);
            break;
            
        case UIDeviceResolution_iPhoneRetina4:
            resolusionSize = CGSizeMake(640, 1136);
            break;
            
        case UIDeviceResolution_iPadRetina:
        case UIDeviceResolution_iPhoneRetina35:
            resolusionSize = CGSizeMake(640, 960);
            break;
            
        default:
            break;
    }
    
    return resolusionSize;
}

- (BOOL)retinaResolution
{
    BOOL isRetina = NO;
    UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    if (scale > 1.0) {
        isRetina = YES;
    }
    return isRetina;
}

- (BOOL)is4InchRetinaResolution
{
    return ([self resolution]==UIDeviceResolution_iPhoneRetina4)?YES:NO;
}

@end

