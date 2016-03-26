//
//  CPDlistViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDlistViewCell.h"
#import "CPDeviceList.h"
#import "CPDeviceGroup.h"
@implementation CPDlistViewCell
//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"device";
    CPDlistViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPDlistViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath
{

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
