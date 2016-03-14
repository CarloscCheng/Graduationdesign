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
//用户有没有登录
- (void)loginViewControllerisLogined:(CPLoginViewController *)loginvc;

@end

@interface CPLoginViewController : UIViewController

@property (weak,nonatomic) id<CPLoginViewControllerDelegate> delegate;

@end
