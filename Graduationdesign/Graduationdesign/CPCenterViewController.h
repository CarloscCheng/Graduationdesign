//
//  CPCenterViewController.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCenterViewController : UIViewController



#warning 登录注销等操作的时候一定要对其进行相应的操作
/**
 *  标识当前登录状态,  YES : 登录 ,  NO : 没有登录(default is no)
 */
@property (nonatomic, readonly, getter = isLogined) BOOL logined;


@end
