//
//  CPTiygViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPTiygViewCell.h"
#import "CPDeviceList.h"
#import "CPDeviceGroup.h"

@interface CPTiygViewCell()
/**
 *  了解更多按钮属性
 */
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@end

@implementation CPTiygViewCell

//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Tiyg";
    CPTiygViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPTiygViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath
{

}

- (void)awakeFromNib
{
    // Initialization code
    [self.moreBtn.layer setMasksToBounds:YES];
    [self.moreBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.moreBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 229/255, 229/255, 229/255, 0.3 });
    
    [self.moreBtn.layer setBorderColor:colorref];//边框颜色
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
