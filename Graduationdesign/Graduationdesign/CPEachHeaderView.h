//
//  CPEachHeaderView.h
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameResult;

@interface CPEachHeaderView : UIView
+ (instancetype)eachHeaderView;
@property (nonatomic, strong) CPGameResult *gameResult;
@end
