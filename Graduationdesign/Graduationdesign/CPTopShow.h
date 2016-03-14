//
//  CPTopShow.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-28.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPTopShow;


@interface CPTopShow : UIView

- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)topMenuWithContentView:(UIView *)contentView;


@property (nonatomic, assign, getter = isDimBackground) BOOL dimBackground;
/**
 *  显示菜单
 */
- (void)showInRect:(CGRect)rect;

/**
 *  关闭菜单
 */
- (void)dismiss;

@end
