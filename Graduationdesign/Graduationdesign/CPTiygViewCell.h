//
//  CPTiygViewCell.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  体验馆

#import <UIKit/UIKit.h>
@class CPDeviceList;
@class CPDeviceGroup;
@interface CPTiygViewCell : UITableViewCell
/**
 *  通过一个tableView来创建一个cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property (strong,nonatomic) CPDeviceGroup *cellGroup;
- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath;
@end
