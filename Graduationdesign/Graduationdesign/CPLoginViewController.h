//
//  CPLoginViewController.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-26.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPLoginViewController;
@protocol CPLoginViewControllerDelegate <NSObject>

@optional
//ThirdParty是否为第三方登录
- (void)loginViewControllerisLogined:(CPLoginViewController *)loginvc WithUserInfo:(NSArray *)userinfo AndThirdParty:(BOOL)ThirdParty;
@end

@interface CPLoginViewController : UIViewController

@property (weak,nonatomic) id<CPLoginViewControllerDelegate> delegate;

@end
