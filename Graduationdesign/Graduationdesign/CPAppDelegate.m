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
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectRenren:[RennClient class]];
                 break;
             case SSDKPlatformTypeGooglePlus:
//                 [ShareSDKConnector connectGooglePlus:[GPPSignIn class]
//                                           shareClass:[GPPShare class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx8a7a34879b6f886f"
                                       appSecret:@"222a9b43efa8913ee01dd809e9a12cd2"];
                 break;
             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"100371282"
//                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
//                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
//                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
//                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                            redirectUri:@"http://localhost"
//                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

    return YES;
}

//app失去焦点的时候调用（控件不能用）
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//app进入后台的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//app进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//app获得焦点控件可以使用
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//app关闭的时候调用
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
