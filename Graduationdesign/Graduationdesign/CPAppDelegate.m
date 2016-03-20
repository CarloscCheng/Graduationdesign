//
//  CPAppDelegate.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPAppDelegate.h"
#import "CPTabBarController.h"
#import "CPNewfeaturesController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//微信SDK头文件
#import "WXApi.h"

//短信注册验证码
#import <SMS_SDK/SMSSDK.h>

#define appkey @"109d20ea71558"
#define app_secrect @"52fce96e761868b9ba01c83dbcbdaa5c"

#define wechatAppId @"wx8a7a34879b6f886f"
#define wechatAppSecret @"222a9b43efa8913ee01dd809e9a12cd2"

@implementation CPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //判断版本新特性
    NSString *VersionKey = @"CFBundleVersion";
    
    //沙盒中上次存储的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:VersionKey];
    NSLog(@"last version = %@",lastVersion);
    
     //获得当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[VersionKey];
    NSLog(@"new version = %@",currentVersion);
    
//    self.window.rootViewController = [[CPNewfeaturesController alloc] init];
    //判断
    if (![currentVersion isEqualToString:lastVersion]) {
//        self.window.rootViewController = [[CPNewfeaturesController alloc] init];
        CPLog(@"旧版本");
        //存储新版本
        [defaults setObject:currentVersion forKey:VersionKey];
        [defaults synchronize];
    }
    
    //获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *login = [userDefault objectForKey:@"lastlogin"];
    CPLog(@"login = %@",login);
    if (login) {
        //如果已经登录了，则进入程序后就为登录状态
        CPLog(@"退出前为登录状态，记录中有登录信息");
        _closeLogined = YES;
    }else
    {
        CPLog(@"退出前为注销状态，记录中没有登录信息");
        _closeLogined = NO;
    }

    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:appkey withSecret:app_secrect];
    
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:wechatAppId
                                       appSecret:wechatAppSecret];
                 break;
             default:
                 break;
         }
     }];
    
    return YES;
}

@end
