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
//个人信息的头像被修改
- (void)dataViewHeaderPhotoIsAltered:(NSString *)alterImageName;
//个人信息的昵称被修改
- (void)dataViewHeaderNameIsAltered:(NSString *)alterName;
@end

@interface CPDataViewController : UIViewController
//设置代理，告诉个人中心vc收到了注销的通知

@property (weak,nonatomic) id<CPDataViewControllerDelegate> delegate;

//将登录的手机号传递至资料界面
- (void)transmitPhone:(NSString *)phone;

@end
