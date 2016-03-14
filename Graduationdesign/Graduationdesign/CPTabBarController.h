//
//  CPTabBarController.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTabBarController : UITabBarController

@property (strong,nonatomic) void (^myTabBarBlock)(CPTabBarController *tabbar);

@end
