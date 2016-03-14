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
        NSLog(@"旧版本");
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
