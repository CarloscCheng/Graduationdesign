//
//  CPDataViewController.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPDataViewController;
@protocol CPDataViewControllerDelegate<NSObject>

@optional
- (void)dataViewLogoutisClicked:(CPDataViewController*)dataView;

@end

@interface CPDataViewController : UIViewController
//设置代理，告诉个人中心vc收到了注销的通知

@property (weak,nonatomic) id<CPDataViewControllerDelegate> delegate;
@end
