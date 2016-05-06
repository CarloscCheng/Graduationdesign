//
//  CPStrategyCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPStrategyCell.h"
#import "CPGameInfo.h"

@interface CPStrategyCell()
@property (weak, nonatomic) IBOutlet UIImageView *strategyImgView;
@property (weak, nonatomic) IBOutlet UILabel *strategyDetail;
@property (weak, nonatomic) IBOutlet UILabel *strategySubDetail;

@end

@implementation CPStrategyCell

+ (instancetype)strategyCellCreate:(UITableView *)tableview
{
    CPStrategyCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPStrategyCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPStrategyCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setGameStrategyList:(CPGameStrategyList *)gameStrategyList
{
    _gameStrategyList = gameStrategyList;
    
    NSURL *url = [NSURL URLWithString:gameStrategyList.img];
    [self.strategyImgView sd_setImageWithURL:url];
    
    self.strategyDetail.text = gameStrategyList.name;
    self.strategySubDetail.text = [NSString stringWithFormat:@"当前共收录:%@",gameStrategyList.num];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
