//
//  CPShareDetailView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-9.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPShareDetailView.h"
#import <ShareSDK/ShareSDK.h>

static UIImage *shareimage;

@interface CPShareDetailView()

- (IBAction)miliaoShare:(id)sender;
- (IBAction)weixinShare:(id)sender;
- (IBAction)friendShare:(id)sender;
- (IBAction)weiboShare:(id)sender;

@end

@implementation CPShareDetailView

+ (instancetype)shareDetailViewCreate
{
    CPShareDetailView *shareDetailView = [[[NSBundle mainBundle] loadNibNamed:@"CPShareDetailView" owner:nil options:nil] lastObject];
    return shareDetailView;
}


- (IBAction)friendShare:(id)sender
{
    CPLog(@"微信分享");
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    // 定制微信朋友圈的分享内容
    [shareParams SSDKSetupWeChatParamsByText:@"Graduationdesign天气分享" title:@"title" url:nil thumbImage:nil image:shareimage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateBegin: {
                
                break;
            }
            case SSDKResponseStateSuccess: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel: {
                
                break;
            }
        }
    }];
    
}

- (void)transmitImage:(UIImage *)img
{
    shareimage = img;
}

- (IBAction)weixinShare:(id)sender{
    
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    // 定制微信朋友圈的分享内容
    [shareParams SSDKSetupWeChatParamsByText:@"Graduationdesign天气分享" title:@"title" url:nil thumbImage:nil image:shareimage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateBegin: {
                
                break;
            }
            case SSDKResponseStateSuccess: {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail: {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel: {
                
                break;
            }
        }
        
        
        
        
    }];
}

- (IBAction)miliaoShare:(id)sender
{
    
}
- (IBAction)weiboShare:(id)sender
{

}
@end
