//
//  CPLifedataViewCell.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  生活信息

#import <UIKit/UIKit.h>
@class CPDeviceGroup;

@interface CPLifedataViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath;


@end
