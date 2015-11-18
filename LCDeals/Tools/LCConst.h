#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LCLog(...) NSLog(__VA_ARGS__)
#else
#define LCLog(...)
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LCGlobalBg LCColor(230, 230, 230)
#define LCNotifiCationCenter [NSNotificationCenter defaultCenter]
//常用颜色值
#define UIColor_Gray_BG           UIColorFromRGB(0xececec)
#define UIColor_Button_Disable    UIColorFromRGB(0xc0cfd6)
#define UIColor_Button_Normal       UIColorFromRGB(0x00b4ff)
#define UIColor_Button_HighLight    UIColorFromRGB(0x00a2ff)
#define UIColor_Blue_BarItemText  UIColorFromRGB(0x1178e7)
#define UIColor_Gray_Text           UIColorFromRGB(0xc6c6c6)
#define UIColor_DarkGray_Text           UIColorFromRGB(0x8f8f8f)
#define UIColor_XiaoDaiCellGray_Text           UIColorFromRGB(0x979797)
#define UIColor_RedButtonBGNormal           UIColorFromRGB(0xf96969)
#define UIColor_RedButtonBGHighLight           UIColorFromRGB(0xff5e5e)
#define UIColor_LightBlueButtonBGNormal           UIColorFromRGB(0x19cbeb)
#define UIColor_LightBlueButtonBGHighLight           UIColorFromRGB(0x18d2f4)
#define UIColor_Black_Text           UIColorFromRGB(0x333333)
//灰色分割线
#define UIColor_GrayLine           UIColorFromRGB(0xcacaca)

extern NSString *const LCCityDidSelectNotification;
extern NSString *const LCCitySelectCityKey;

extern NSString *const LCSortDidChangeNotification;
extern NSString *const LCSortSelectKey;

extern NSString *const LCCategoryDidChangeNotification;
extern NSString *const LCCategorySelectKey;
extern NSString *const LCSubCategorySelectKey;

extern NSString *const LCRegionDidChangeNotification;
extern NSString *const LCRegionSelectKey;
extern NSString *const LCSubRegionSelectKey;

extern NSString *const LCCollectStateDidChangeNotification;
extern NSString *const LCIsCollectKey;
extern NSString *const LCCollectDealKey;
