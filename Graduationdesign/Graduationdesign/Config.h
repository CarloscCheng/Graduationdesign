//
//  Config.h
//  yizhong
//
//  Created by ced on 15/3/30.
//  Copyright (c) 2015年 feibo. All rights reserved.
//

#ifndef yizhong_Config_h
#define yizhong_Config_h

// 注释这个宏使用外部地址，否则使用内部地址
#warning release之前注释掉
//#define INNER_SERVER

//#if defined INNER_SERVER && DEBUG
//#if defined INNER_SERVER
//#   define kREQ_URL @"http://192.168.45.3:81/api.php"
//#   define kREQ_URL @"http://58.23.56.98:45381/api.php"
//#   define kREQ_URL @"http://test2.yizhong.cccwei.com/api.php"
//#else
#   define kREQ_URL @"https://api.yizhong.cccwei.com/api.php"
//#endif

//应用内使用`DLog`替换`NSLog`
#ifdef DEBUG
#   define DLog(...) NSLog(__VA_ARGS__)
#else
#   define DLog(...)
#endif

//Dealloc
#ifdef DEBUG
#define FB_LOG_DEALLOC \
- (void)dealloc \
{ \
NSLog(@"%@ DEALLOCATED", NSStringFromClass(self.class)); \
}
#else
#define FB_LOG_DEALLOC
#endif


#define kGUIDE_REGISTER_PUSH_KEY @"a66d3a621350a54b4183ed1a65d3aadf"

#define kDEFAULT_REQ_PAGE_SIZE 20

#define kSHARE_URL_LIFT_DETAIL @"http://yizhong.cccwei.com/article/details/id/%@.html"
#define kSHARE_URL_RECORD @"http://yizhong.cccwei.com/"

#define IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define IS_IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] \
                        ? CGSizeEqualToSize(CGSizeMake(640, 960), \
                        [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] \
                        ? CGSizeEqualToSize(CGSizeMake(640, 1136), \
                        [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] \
                        ? CGSizeEqualToSize(CGSizeMake(750, 1334), \
                        [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] \
                            ? (CGSizeEqualToSize(CGSizeMake(1125,2001), \
                            [[UIScreen mainScreen] currentMode].size) \
                            || CGSizeEqualToSize(CGSizeMake(1242, 2208),\
                            [[UIScreen mainScreen] currentMode].size)) : NO)


// Address
#define KEY_ADDRESS_VERSION @"key_address_version"
#define DOWNLOAD_CITY_FILE_NAME @"area.plist"

//Size
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kNAVI_BAR_ITEM_FRAME CGRectMake(0.0, 0.0, 40.0, 64.0)

#define FB_FIX_SIZE(w) (((w) / 320.0) * kSCREEN_WIDTH)

//Notification
#define kEXPERIENCE_ORDER_STATUS_DID_CHANGE @"kExperenceOrderStatusDidChange"
#define kEXPERIENCE_ORDER_REFUND_SUCCESS @"kExperenceOrderRefundSuccess"

#define kNET_ERROR_MESSAGE @"世界上最遥远的距离就是没网\n请检查设置"

#endif
