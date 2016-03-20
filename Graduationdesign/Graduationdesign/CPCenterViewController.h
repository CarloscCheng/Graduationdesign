//
//  CPCenterViewController.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCenterViewController : UIViewController

/**
 *  标识当前登录状态,  YES : 登录 ,  NO : 没有登录(default is no)
 */
@property (nonatomic, readonly, getter = isLogined) BOOL logined;

@end
