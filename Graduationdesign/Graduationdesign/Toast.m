//
//  ViewToast.m
//  yizhong
//
//  Created by 张超 on 15/8/26.
//  Copyright (c) 2015年 feibo. All rights reserved.
//

#import "Toast.h"
#import <objc/runtime.h>

#import "Color.h"
#import "Config.h"
#import "Font.h"

#define MARGIN_SIZE FB_FIX_SIZE(10)

static void *ToastKey = &ToastKey;

@interface Toast ()

@property (nonatomic, strong) UILabel *lbText;

@end

@implementation Toast

+ (void)toast:(NSString *)msg
{
    [self toast:msg duration:1.5];
}

+ (void)toast:(NSString *)msg duration:(NSTimeInterval)duration
{
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - MARGIN_SIZE * 4, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kS4, NSFontAttributeName, nil] context:nil];
    
    UILabel *label = ({
        UILabel *l = [[UILabel alloc] init];
        [l setBounds:CGRectMake(0, 0, rect.size.width + MARGIN_SIZE * 2, rect.size.height + MARGIN_SIZE * 2)];
        [l.layer setCornerRadius:FB_FIX_SIZE(4)];
        [l.layer setMasksToBounds:YES];
        [l setBackgroundColor:FB_RGBA(0, 0, 0, 0.6)];
        [l setAlpha:0.0f];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setFont:kS4];
        [l setTextColor:kC7];
        [l setNumberOfLines:0];
        [l setText:msg];
        
        l;
    });
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [label setCenter:window.center];

    id temp = window.subviews.lastObject;
    if ([temp isMemberOfClass:[UILabel class]]) {
        [temp removeFromSuperview];
    }
    
    [window addSubview:label];
    
    [UIView animateWithDuration:0.2 animations:^{
        [label setAlpha:1.0f];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{
                [label setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
}

@end
