//
//  CPShareDetailView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-9.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPShareDetailView.h"

#import <ShareSDK/ShareSDK.h>

@interface CPShareDetailView()
- (IBAction)miliaoShare:(id)sender;
- (IBAction)weixinShare:(id)sender;
- (IBAction)friendShare:(id)sender;
- (IBAction)weiboShare:(id)sender;

@end

@implementation CPShareDetailView

- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CPShareDetailView" owner:nil options:nil] lastObject];
    }
    return self;

}



- (IBAction)miliaoShare:(id)sender{
}

- (IBAction)weixinShare:(id)sender{

}

- (IBAction)friendShare:(id)sender
{
    CPLog(@"微信分享");
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupWeChatParamsByText:nil title:@"微信分享" url:nil thumbImage:nil image:[UIImage imageNamed:@"icon.jpg"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    

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

- (IBAction)weiboShare:(id)sender {
}
@end
