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
#import "CPShareDetailView.h"

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

@property (readonly, nonatomic) int count;
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
//        self.decelerationRate = 0.3;
        
        CPWDataTopView *topView = [[CPWDataTopView alloc] init];
        self.topView = topView;
        [self addSubview:topView];
        
        CPWDataMiddleView *middleView = [[CPWDataMiddleView alloc] init];
        self.middleView = middleView;
        [self addSubview:middleView];
        
        CPWDataBottomView *bottomView = [[CPWDataBottomView alloc] init];
        self.bottomView = bottomView;
        [self addSubview:bottomView];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview
{
    CPLog(@"CPWeatherDataSV --- didAddSubview");
    self.topView.frame = CGRectMake(0, 0, CPWINDOWWIDTH, 64);
    self.middleView.frame = CGRectMake(0, self.topView.height + 10, CPWINDOWWIDTH, 200);
    self.bottomView.frame = CGRectMake(0, self.middleView.y + self.middleView.height + 20, CPWINDOWWIDTH, 264);
    self.frame = CGRectMake(0, 0, 320, self.bottomView.y + self.bottomView.height + 20);
    self.contentSize = CGSizeMake(0, self.height);
    self.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _count ++;
        [self getScreenShots];
    });

}

//截图
- (void)getScreenShots
{
    //获取scrollview的截图
    if (_count == 1) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [self center].x, [self center].y);
        CGContextConcatCTM(context, [self transform]);
        CGContextTranslateCTM(context, -[self bounds].size.width*[[self layer] anchorPoint].x, -[self bounds].size.height*[[self layer] anchorPoint].y);
        [[self layer] renderInContext:context];
        
        CGContextRestoreGState(context);
    
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CPLog(@"Suceeded!");
        
        [[CPShareDetailView shareDetailViewCreate] transmitImage:image];
    }

}

- (void)dealloc
{
    _count = 0;
    CPLog(@"dealloc");
}


- (void)test
{
    //获取scrollview的截图
    if (_count == 1) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        //    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        //        if (![self respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [self center].x, [self center].y);
        CGContextConcatCTM(context, [self transform]);
        CGContextTranslateCTM(context, -[self bounds].size.width*[[self layer] anchorPoint].x, -[self bounds].size.height*[[self layer] anchorPoint].y);
        [[self layer] renderInContext:context];
        
        CGContextRestoreGState(context);
        //        }
        //    }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        CPLog(@"Suceeded!");
        
        [[CPShareDetailView shareDetailViewCreate] transmitImage:image];
    }
    
}
@end
