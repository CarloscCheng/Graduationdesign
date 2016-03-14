//
//  CPAppDelegate.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  这个app退出或关闭后台的时候是登录状态还是未登录状态,第一次加载程序为未登录
 */
@property (readonly,nonatomic,getter = iscCloseLogined) BOOL closeLogined;
@end
