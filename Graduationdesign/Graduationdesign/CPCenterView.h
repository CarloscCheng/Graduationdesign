//
//  CPCenterView.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  个人中心用户头像，昵称，几个智能设备的view

#import <UIKit/UIKit.h>

//设置代理
@protocol CPCenterViewDelegate <NSObject>

@optional
- (void)centerViewisTouched:(UIView *)Tview;

@end



@interface CPCenterView : UIView

@property (weak,nonatomic) id<CPCenterViewDelegate> delegate;

@end
