//
//  CPCellHeaderView.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVCTopModel;
@interface CPCellHeaderView : UIView

+ (instancetype)cellHeaderViewCreate;

@property (nonatomic, strong) CPVCTopModel *vcTopModel;
@end
