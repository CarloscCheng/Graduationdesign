//
//  CPTotalCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPTotalCell.h"
#import "CPWeatherConnect.h"
#import "CPDeviceGroup.h"
#import "CPLifedataViewCell.h"
#import "CPTiygViewCell.h"
#import "CPDlistViewCell.h"
#import "CPBlogViewCell.h"

@interface CPTotalCell()


@end

@implementation CPTotalCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andWithGroups:(CPDeviceGroup *)group
{
    
    CPTotalCell *cell = [[CPTotalCell alloc] init];
    if ([group.infotitle isEqualToString:@"生活信息"]) {
        NSLog(@"=====生活信息");
        cell = (CPTotalCell *)[CPLifedataViewCell cellWithTableView:tableView];
    }else if ([group.infotitle isEqualToString:@"体验馆"])
    {
        cell = (CPTotalCell *)[CPTiygViewCell cellWithTableView:tableView];
    }else if ([group.infotitle isEqualToString:@"智能设备列表"])
    {
        cell = (CPTotalCell *)[CPDlistViewCell cellWithTableView:tableView];
    }else if ([group.infotitle isEqualToString:@"智能家庭论坛"])
    {
        cell = (CPTotalCell *)[CPBlogViewCell cellWithTableView:tableView];
    }

    return cell;
}

//用到时调用
- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath
{

}

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"totalcellawake");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
