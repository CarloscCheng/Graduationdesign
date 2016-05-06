//
//  CPCellHeaderView.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPCellHeaderView.h"
#import "CPVCModel.h"
@interface CPCellHeaderView ()
/**
 *  游戏数量
 */
@property (weak, nonatomic) IBOutlet UILabel *gameCountLabel;
/**
 *  上架时间
 */
@property (weak, nonatomic) IBOutlet UILabel *gameDateLabel;

@end

@implementation CPCellHeaderView

+ (instancetype)cellHeaderViewCreate
{
    CPCellHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"CPCellHeaderView" owner:self options:nil] lastObject];
    return view;
}

- (void)setVcTopModel:(CPVCTopModel *)vcTopModel 
{
    _vcTopModel = vcTopModel;
    self.gameCountLabel.text = [NSString stringWithFormat:@"共 %@ 款",vcTopModel.gameCount];

    self.gameDateLabel.textColor = [UIColor grayColor];
    self.gameDateLabel.text = [NSString stringWithFormat:@"上架时间 :%@",vcTopModel.date];
}
 
@end
