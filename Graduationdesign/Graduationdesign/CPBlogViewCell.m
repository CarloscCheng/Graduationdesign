//
//  CPBlogViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPBlogViewCell.h"
#import "CPDeviceList.h"
#import "CPDeviceGroup.h"
@implementation CPBlogViewCell
//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"device";
    CPBlogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPBlogViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


//- (void)setCellGroup:(CPDeviceGroup *)cellGroup
//{
//    NSLog(@"blog set cellgroup");
//}
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
