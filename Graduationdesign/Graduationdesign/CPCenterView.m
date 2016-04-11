//
//  CPCenterView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPCenterView.h"

@interface CPCenterView()

@end


@implementation CPCenterView

//头像处被触摸时告诉个人中心控制器弹到个人资料处
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(centerViewisTouched:)]) {
        [self.delegate centerViewisTouched:self];
        CPLog(@"头像处被触摸");
    }
}

@end
