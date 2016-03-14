//
//  CPWeatherDataVC.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-5.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPWeatherDataVC.h"
#import "CPWeatherDataSV.h"
#import "CPShareView.h"

@interface CPWeatherDataVC ()

- (IBAction)backAction:(id)sender;
- (IBAction)shareWeatherData:(id)sender;

@end

@implementation CPWeatherDataVC


- (void)viewDidLoad
{
    CPLog(@"viewdidload");
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"天气信息"];
    
    CPWeatherDataSV *scroll = [[CPWeatherDataSV alloc] init];
    [self.view addSubview:scroll];
}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享天气信息
- (IBAction)shareWeatherData:(id)sender
{
    CPShareView *shareView = [[CPShareView alloc] init];
    [self.view.window addSubview:shareView];
}
@end
