//
//  CPTotalCell.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  用于封装所有类型的cell

#import <UIKit/UIKit.h>


@class CPDeviceGroup;


@interface CPTotalCell : UITableViewCell

//不同cell设置相同的方法选择调用
- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath;

/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView andWithGroups:(CPDeviceGroup *)group;


@end
