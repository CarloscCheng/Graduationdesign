//
//  CPWeatherDataSV.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-5.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPWeatherDataSV.h"
#import "CPWDataTopView.h"
#import "CPWDataMiddleView.h"
#import "CPWDataBottomView.h"

@interface CPWeatherDataSV()

/**
 *  顶部的view
 */
@property (weak,nonatomic) CPWDataTopView *topView;
/**
 *  中间的view
 */
@property (weak,nonatomic) CPWDataMiddleView *middleView;
/**
 *  下方的view
 */
@property (weak,nonatomic) CPWDataBottomView *bottomView;
@end


@implementation CPWeatherDataSV

- (instancetype)init
{
    self = [super init];
    if (self) {
        //参数设置
        self.scrollEnabled = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = 0.3;
        
        CPWDataTopView *topView = [[CPWDataTopView alloc] init];
        self.topView = topView;
        [self addSubview:topView];
        
        CPWDataMiddleView *middleView = [[CPWDataMiddleView alloc] init];
        self.middleView = middleView;
        [self addSubview:middleView];
        
        CPWDataBottomView *bottomView = [[CPWDataBottomView alloc] init];
        self.bottomView = bottomView;
        [self addSubview:bottomView];
    }
    return self;
}


- (void)layoutSubviews
{
    self.topView.frame = CGRectMake(0, 0, CPWINDOWWIDTH, 64);
    self.middleView.frame = CGRectMake(0, self.topView.height + 10, CPWINDOWWIDTH, 200);
    self.bottomView.frame = CGRectMake(0, self.middleView.y + self.middleView.height + 20, CPWINDOWWIDTH, 264);
    self.frame = CGRectMake(0, 0, 320, self.bottomView.y + self.bottomView.height + 20);
    self.contentSize = CGSizeMake(0, self.height);
}

@end
