#define UIColorFromHex(hex)      [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGB(r,g,b)    ([UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:1.0])

#define UIColorFromRGBWithAlpha(r,g,b,a)    ([UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:a])

#define kTableViewSeparatorColor [UIColor colorWithWhite:230.0/255.0 alpha:1.0f]

#define kTableViewGrayColor      UIColorFromHex(0xf6f6f6)
#define kCommonBackgroundColor   UIColorFromRGB(248,248,248)
#define kTableViewCellGrayColor  UIColorFromRGB(239,239,239)

#define kControllerGrayColor     UIColorFromHex(0xf6f6f6)

#define kGreenColor        UIColorFromRGB(65, 156, 159) //UIColorFromRGB(86, 179, 11)
#define kDarkGreenColor    UIColorFromRGB(75, 166, 169) //UIColorFromRGB(78, 163, 25)
#define kYellowColor       UIColorFromRGB(242, 138, 49)
#define kBlackColor        UIColorFromHex(0x333333)
#define kDarkGrayColor     UIColorFromRGB(107, 107, 107)
#define kLightGrayColor    UIColorFromHex(0x999999)
#define kBlueColor         UIColorFromHex(0x6f8ad3)
#define kDarkBlueColor     UIColorFromHex(0x3f63c4)
#define kDarRedColor       UIColorFromHex(0xff6868)
#define kLightGreenColor   UIColorFromRGB(242, 252, 240)
#define kLightBlueColor    UIColorFromRGB(240, 251, 252)

#define kDarkLineColor     UIColorFromHex(0xcccccc)
#define kLightLineColor    UIColorFromHex(0xdddddd)

#define kHomeBackColor UIColorFromRGB(41,155,157)

#define kOrangeColor UIColorFromRGB(244,193,130)

#define kPayBtnColor       kGreenColor
#define kDarkPayBtnColor   kDarkGreenColor

#pragma =====  FontSize =========
#define kCommonTitleFontSize      16
#define kCommonDescFontSize       14
#define kAnnotationFontSize       12

#pragma mark ======== Font =========
#define kCommonTitleFont [UIFont systemFontOfSize:kCommonTitleFontSize]
#define kCommonDescFont [UIFont systemFontOfSize:kCommonDescFontSize]
#define kScoreNumberFont [UIFont boldSystemFontOfSize:22]
#define kAnnotationFont [UIFont systemFontOfSize:kAnnotationFontSize]

#define SystemFont_10 [UIFont systemFontOfSize:10]
#define SystemFont_12 [UIFont systemFontOfSize:12]
#define SystemFont_13 [UIFont systemFontOfSize:13]
#define SystemFont_14 [UIFont systemFontOfSize:14]
#define SystemFont_18 [UIFont systemFontOfSize:18]
#define SystemFont_22 [UIFont systemFontOfSize:22]


#define kButtonBlueNor     @"common_button_blue"
#define kButtonBlueSel     @"common_button_blue_highlighted"

#define kButtonYellowNor   @"common_button_yellow"
#define kButtonYellowSel   @"common_button_yellow_highlighted"

#define kButtonGreenNor    @"btn_green_nor"
#define kButtonGreenSel    @"btn_green_sel"

#define kButtonWhiteNor    @"btn_white_nor"
#define kButtonWhiteSel    @"btn_white_sel"

#define kScreenWidth             ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight            ([UIScreen mainScreen].bounds.size.height)
#define kNavigationHeight        (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0) ? 64.0 : 44.0)
#define kNavigationDelY          (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0) ? 20.0 : 0.0)
#define kTabBarHeight            44.0f
#define kTopTabBarHeight         40.0f

#define kScreenRatio             (kScreenWidth / 320.0)

#define AdaptedValue(x)          (ceilf((x) * kScreenRatio))

#define kLoadMoreCellHeigth                     55

#define kDefaultLineHeight       (1.0 / [UIScreen mainScreen].scale)

#define kControllerContentRect              (CGRectMake(0, kNavigationHeight, kScreenWidth, CGRectGetHeight(self.view.bounds) - kNavigationHeight))

#define kFirstLevelControllerContentRect    (CGRectMake(0, kNavigationHeight, kScreenWidth, CGRectGetHeight(self.view.bounds) - kNavigationHeight - kTabBarHeight))

#define kCurrentLat     [[NSUserDefaults standardUserDefaults] objectForKey:@"lat"]
#define kCurrentLng     [[NSUserDefaults standardUserDefaults] objectForKey:@"lng"]
//#define kCurrentCity    [[NSUserDefaults standardUserDefaults] objectForKey:@"city"]

#define kPageSize       20
#define kPageInfoKey    @"pageInfo"
#define kCurrPageKey    @"currentPage"
#define kTotalPageKey   @"totalPage"

#define kDefaultMerchantSortField  @"distance"

#define Is_Phone4       (kScreenHeight < 568)
#define Is_Phone5       ((int)kScreenHeight == 568)

#define kNotification_OrderPaySuccess       @"Notification_OrderPaySuccess"
#define kNotification_OrderRefundSuccess    @"Notification_OrderRefundSuccess"
#define kNotification_OrderCancelSuccess    @"Notification_OrderCancelSuccess"
#define kNotification_OrderCommentSuccess   @"Notification_OrderCommentSuccess"
#define kNotification_OrderConfirmSuccess   @"Notification_OrderConfirmSuccess"
#define kNotification_OrderSubmitSuccess       @"Notification_OrderSubmitSuccess" // 预约成功

#define kNotification_OrderCountChange      @"Notification_OrderCountChange"

#define kNotification_LogoutSuccess         @"Notification_LogoutSuccess"

#define kNotification_CityChange      @"Notification_CityChange"

//======================
#define kServicePhoneNumber     @"400-890-9636"

#define kPlatForm     @"APP_IOS_USER"

typedef void(^CUCommomButtonAction)(void);

//以5s做标准参考，用来充当固定值比例系数
//横向
#define HFixRatio6  (kScreenWidth / 375.0)
//纵向
#define VFixRatio6  (kScreenHeight / 667.0)