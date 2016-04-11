//
//  CPGameTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameTableViewCell.h"
#import "CPVCModel.h"

@interface CPGameTableViewCell ()
/**
 *  游戏图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *gameImg;
/**
 *  游戏名称所在view
 */
@property (weak, nonatomic) IBOutlet UIView *gameNameView;
/**
 *  评价view
 */
@property (weak, nonatomic) IBOutlet UIView *starView;
/**
 *  游戏分类
 */
@property (weak, nonatomic) IBOutlet UILabel *gameCategoryLabel;
/**
 *  游戏语言
 */
@property (weak, nonatomic) IBOutlet UILabel *gameLanguageLabel;
/**
 *  游戏大小
 */
@property (weak, nonatomic) IBOutlet UILabel *gameSizeLabel;
/**
 *  游戏价格
 */
@property (weak, nonatomic) IBOutlet UILabel *gamePriceLabel;
@end

static NSString *ID = @"game";
@implementation CPGameTableViewCell

+ (instancetype)gameCellCreate:(UITableView *)tableview
{
    CPGameTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPGameTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setGameList:(CPVCGameList *)gameList
{
    _gameList = gameList;
    
    //设置图片
    NSURL *imgUrl = [NSURL URLWithString:gameList.img];
    [self.gameImg sd_setImageWithURL:imgUrl];
    
    //游戏名
    CGSize nameSize = [NSString sizeWithText:gameList.name font:[UIFont systemFontOfSize:13.0] maxSize:CPMAXSIZE];

//    self.gameNameView.backgroundColor = [UIColor yellowColor];
    if (gameList.isHot) {
        //热门
        UIButton *hotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 30, 16)];
        [hotButton setTitle:@"热" forState:UIControlStateNormal];
        hotButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        hotButton.backgroundColor = CP_RGB(255, 118, 98);
        [self.gameNameView addSubview:hotButton];
        
        //游戏名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotButton.width + 3, 2, nameSize.width, 16)];
        nameLabel.centerY = hotButton.centerY;
//        nameLabel.backgroundColor = [UIColor blueColor];
        nameLabel.text = gameList.name;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        [self.gameNameView addSubview:nameLabel];
    }else{
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameSize.width, 16)];
        nameLabel.centerY = self.gameNameView.centerY;
        nameLabel.text = gameList.name;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        [self.gameNameView addSubview:nameLabel];
    }
    
    //游戏评分
//    UIImageView *starImageview = [[UIImageView alloc] init];
//    if (gameList.star %2 == 0) {
//        //能整除2的星星数量
//        for (int i = 0; i < gameList.star / 2; i++) {
//            starImageview.frame = CGRectMake(i * 10, 0, 10, 10);
//            starImageview.image = [UIImage imageNamed:@"full_star"];
//
//        }
//        [self.starView addSubview:starImageview];
////        starImageview.frame = CGRectMake(starImageview.x + starImageview.width, 0, 10, 10);
////        [self.starView addSubview:starImageview];
//        
//    }else{
//        //不能整除2的星星数量
//    }
    //游戏分类
    self.gameCategoryLabel.text = gameList.category;
    
    //游戏语言
    self.gameLanguageLabel.text = gameList.language;
    
    //游戏大小
    self.gameSizeLabel.text = gameList.size;
}

- (void)awakeFromNib {
    // Initialization code 
    self.gameCategoryLabel.textColor = [UIColor grayColor];
    self.gameLanguageLabel.textColor = [UIColor grayColor];
    self.gameSizeLabel.textColor = [UIColor grayColor];
    
    //图片圆角
    [self.gameImg.layer setMasksToBounds:YES];
    [self.gameImg.layer setCornerRadius:12.0];
    
    self.gameNameView.height = 20;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
