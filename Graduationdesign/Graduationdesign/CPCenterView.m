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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//view加载完毕后部署子控件的frame等属性
- (void)layoutSubviews
{

}


//头像处被触摸时告诉个人中心控制器弹到个人资料处
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(centerViewisTouched:)]) {
        [self.delegate centerViewisTouched:self];
        NSLog(@"头像处被触摸");
    }
}

@end
