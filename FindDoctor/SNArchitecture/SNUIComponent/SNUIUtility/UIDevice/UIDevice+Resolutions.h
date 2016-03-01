//
//  UIDevice+Resolutions.h
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

enum {
	UIDeviceResolution_Unknown			= 0,
    UIDeviceResolution_iPhoneStandard	= 1,    // iPhone 1,3,3GS 标准	(320x480px)
    UIDeviceResolution_iPhoneRetina35	= 2,    // iPhone 4,4S 高清 3.5"	(640x960px)
    UIDeviceResolution_iPhoneRetina4	= 3,    // iPhone 5 高清 4"		(640x1136px)
    UIDeviceResolution_iPadStandard		= 4,    // iPad 1,2 标准		(1024x768px)
    UIDeviceResolution_iPadRetina		= 5     // iPad 3 高清			(2048x1536px)
    
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

/*
 获取屏幕分辨率类型
 */
- (UIDeviceResolution)resolution;

/*
 获取屏幕分辨率尺寸
 */
- (CGSize)resolutionSize;

/*
 获取屏幕分辨率类型字符串
 */
NSString * NSStringFromResolution(UIDeviceResolution resolution);


/*
  如果设备是iPad 标准，对应为UIDeviceResolution_iPhoneStandard，
  如果设备是iPad Retina，对应为UIDeviceResolution_iPhoneRetina35
*/
- (CGSize)resolutionIphoneOnly;

//屏幕是否为retina屏幕
- (BOOL)retinaResolution;

//是否为4inch的屏幕
- (BOOL)is4InchRetinaResolution;



@end
