//
//  CPNologinHeaderView.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-27.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  用户没有登录的时候提示用户登录

#import <UIKit/UIKit.h>
@class CPNologinHeaderView;

@protocol CPNologinHeaderViewDelegate <NSObject>

@optional
- (void)tipsViewisClicked:(UIView *)view;

@end

@interface CPNologinHeaderView : UIView

@property (weak,nonatomic) id<CPNologinHeaderViewDelegate> delegate;

+ (instancetype)viewWithNologinView;

@end
