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
//新浪微博SDK头文件
#import "WeiboSDK.h"
//短信注册验证码
#import <SMS_SDK/SMSSDK.h>

#define appkey @"109d20ea71558"
#define app_secrect @"52fce96e761868b9ba01c83dbcbdaa5c"

#define wechatAppId @"wx8a7a34879b6f886f"
#define wechatAppSecret @"222a9b43efa8913ee01dd809e9a12cd2"

#define weiboAppKey @"4222661985"
#define weiboappSecret @"551842607b1ea7d49aa75144e212df39"

//4399首页数据(charles抓包得到)
#define gameHttpUrl @"http://cdn.4399sj.com/app/iphone/v2.2/home.html"
#define gameHttpArg [NSString stringWithFormat:@"start=%d&count=%d",1,10]

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
    CPLog(@"last version = %@",lastVersion);
    
     //获得当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[VersionKey];
    CPLog(@"new version = %@",currentVersion);
    
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
    NSDictionary *login = [userDefault objectForKey:@"lastLogin"];
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

    //此处是因为不当操作导致plist文件被删除(plist文件被删除直接初始化)，但是个人中心和个人资料没有被注销仍然显示数据点击再次崩溃的错误
    NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"PersonlData.plist"];
    NSMutableArray *regArr = [NSMutableArray arrayWithContentsOfFile:filename];
    
    if(!regArr){
        //没有数据创建默认的
        [userDefault removeObjectForKey:@"lastLogin"];
        [userDefault synchronize];
        
        _closeLogined = NO;
    }

    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:appkey withSecret:app_secrect];
    
    [ShareSDK registerApp:@"iosv1101"
          activePlatforms:@[@(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
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
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:weiboAppKey
                                           appSecret:weiboappSecret
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    //获取家庭娱乐页面的网络数据存入缓存
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:gameCacheName];

    [self getHomeGameDataWithCacheName:cachefilename];
    
    NSData *gameData = [NSData dataWithContentsOfFile:cachefilename];
    CPLog(@"gameData=%@",gameData);
    
//    NSError *error;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableLeaves error:&error];
//    CPLog(@"error==%@,dict == %@",error, dict);

    return YES;
}

#pragma mark 网络处理获取游戏中心的页面数据
- (void)getHomeGameDataWithCacheName:(NSString *)cachefilename
{
    //URL
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",gameHttpUrl,gameHttpArg];
    CPLog(@"GET地址%@",urlStr);
    
    AFHTTPSessionManager *httpMrg = [AFHTTPSessionManager manager];
    httpMrg.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMrg GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //写入文件
            NSError *error;
            if ([responseObject writeToFile:cachefilename options:NSDataWritingAtomic error:&error]) {
                CPLog(@"写入缓存成功");
            }else{
                CPLog(@"写入缓存失败");
            }
        }else{
            CPLog(@"获取数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CPLog(@"失败%@",error);
    }];

}


@end
