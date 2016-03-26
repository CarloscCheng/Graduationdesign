//
//  CPMiddleView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPMiddleView.h"

@interface CPMiddleView()

@end

@implementation CPMiddleView


- (void)layoutSubviews
{
    [super layoutSubviews];
    //添加和设置子控件
    //设置图片
    UIButton *integral = [[UIButton alloc] initWithFrame:CGRectMake(21, 0, 70, 66)];
    
    UIImageView *integralimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"integral"]];
    integralimgview.frame = CGRectMake(20, 10, 30, 26);
    //设置文字
    UILabel *integraltext = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 60, 20)];
    integraltext.text = @"我的积分";    
    
    integraltext.font = [UIFont systemFontOfSize:10.0];
    integraltext.textColor = [UIColor blackColor];
    integraltext.textAlignment = NSTextAlignmentCenter;
    [integral addSubview:integraltext];
    [integral addSubview:integralimgview];
    //加载到button上
    [self addSubview:integral];
    //添加点击事件
    //改变按下和普通状态uibutton颜色
    [integral addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [integral addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    //按钮被点击
    [integral addTarget:self action:@selector(integralisClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *family = [[UIButton alloc] initWithFrame:CGRectMake(91, 0, 70, 66)];
    UIImageView *familyimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"family"]];
    familyimgview.frame = CGRectMake(20, 10, 30, 26);
    
    UILabel *familytext = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 60, 20)];
    familytext.text = @"我的家人";
    familytext.font = [UIFont systemFontOfSize:10.0];
    familytext.textColor = [UIColor blackColor];
    familytext.textAlignment = NSTextAlignmentCenter;
    [family addSubview:familytext];
    [family addSubview:familyimgview];
    [self addSubview:family];
    
    //改变按下和普通状态uibutton颜色
    [family addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [family addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    //按钮被点击
    [family addTarget:self action:@selector(personalMiddleisClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *scene = [[UIButton alloc] initWithFrame:CGRectMake(161, 0, 70, 66)];
    UIImageView *sceneimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scene"]];
    sceneimgview.frame = CGRectMake(20, 10, 30, 26);
    
    UILabel *scenetext = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 60, 20)];
    scenetext.text = @"智能场景";
    scenetext.font = [UIFont systemFontOfSize:10.0];
    scenetext.textColor = [UIColor blackColor];
    scenetext.textAlignment = NSTextAlignmentCenter;
    [scene addSubview:scenetext];
    [scene addSubview:sceneimgview];
    [self addSubview:scene];
    //改变按下和普通状态uibutton颜色
    [scene addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [scene addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮被点击
    [scene addTarget:self action:@selector(personalMiddleisClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *device = [[UIButton alloc] initWithFrame:CGRectMake(230, 0, 70, 66)];
    UIImageView *deviceimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device"]];
    deviceimgview.frame = CGRectMake(20, 10, 30, 26);
    
    UILabel *devicetext = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 60, 20)];
    devicetext.text = @"设备共享";
    devicetext.font = [UIFont systemFontOfSize:10.0];
    devicetext.textColor = [UIColor blackColor];
    devicetext.textAlignment = NSTextAlignmentCenter;
    [device addSubview:devicetext];
    [device addSubview:deviceimgview];
    [self addSubview:device];
    //改变按下和普通状态uibutton颜色
    [device addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [device addTarget:self action:@selector(buttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮被点击
    [device addTarget:self action:@selector(personalMiddleisClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 自定义方法
//普通状态下的背景色
- (void)buttonBackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
}

//高亮状态下的背景色
- (void)buttonBackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark 按钮事件
- (void)personalMiddleisClicked:(UIButton *)sender
{
}

- (void)integralisClicked:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"敬请期待!" message:@"功能开发中"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
    [alert show];
}

@end
