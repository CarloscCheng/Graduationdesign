//
//  CPGameTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameTableViewCell.h"
#import "CPVCModel.h"
#import "CPTimeFreeModel.h"
#import "CPUILineLabel.h"
#import "CPGameInfo.h"


#define downFont [UIFont systemFontOfSize:11.0]
#define downSize [NSString sizeWithText:@"下载(免费)" font:downFont maxSize:CPMAXSIZE]

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
 *  游戏价格所在view
 */
@property (weak, nonatomic) UIView *gamePriceView;
@property (strong, nonatomic) UIView *downView;

@end

@implementation CPGameTableViewCell

+ (instancetype)gameCellCreate:(UITableView *)tableview
{
    CPGameTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPGameTableViewCell class])];
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
    
    //游戏分类
    self.gameCategoryLabel.text = gameList.category;
    
    //游戏语言
    self.gameLanguageLabel.text = gameList.language;
    
    //游戏大小
    self.gameSizeLabel.text = gameList.size;
    
    //游戏价格
//    self.gamePriceView.backgroundColor = [UIColor redColor];
    UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.gamePriceView.width, 20)];
    pricelabel.centerY = self.gamePriceView.centerY - self.gamePriceView.y;
    pricelabel.textColor = CP_RGB(0, 192, 139);
    
    pricelabel.font = [UIFont systemFontOfSize:11.0];
    pricelabel.textAlignment = NSTextAlignmentRight;
    if ([gameList.price isEqualToString:@"0.00"]) {
        pricelabel.text = @"免费";
    }
    [self.gamePriceView addSubview:pricelabel];
    
}


#pragma mark 点击了限免的按钮
- (void)setTimeFreeListModel:(CPTimeFreeListModel *)timeFreeListModel
{
    _timeFreeListModel = timeFreeListModel;
    
    //设置图片
    NSURL *imgUrl = [NSURL URLWithString:timeFreeListModel.img];
    [self.gameImg sd_setImageWithURL:imgUrl];
    
    //游戏名
    CGSize nameSize = [NSString sizeWithText:timeFreeListModel.name font:[UIFont systemFontOfSize:13.0] maxSize:CPMAXSIZE];
    
    if (timeFreeListModel.isHot) {
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
        nameLabel.text = timeFreeListModel.name;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        [self.gameNameView addSubview:nameLabel];
    }else{
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameSize.width, 16)];
        nameLabel.centerY = self.gameNameView.centerY;
        nameLabel.text = timeFreeListModel.name;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        [self.gameNameView addSubview:nameLabel];
    }
    //游戏评分
    
    //游戏分类
    self.gameCategoryLabel.text = timeFreeListModel.category;
    
    //游戏语言
    self.gameLanguageLabel.text = timeFreeListModel.language;
    
    //游戏大小 
    self.gameSizeLabel.text = timeFreeListModel.size;
    
    //游戏价格
    CPUILineLabel *prePriceLable = [[CPUILineLabel alloc] initWithFrame:CGRectMake(0, 0, self.gamePriceView.width, 20)];
    prePriceLable.lineType = CPLineTypeMiddle;
    prePriceLable.lineColor = CP_RGB(255, 127, 0);
    prePriceLable.centerY = self.gamePriceView.centerY - self.gamePriceView.y - 8;
    prePriceLable.textColor = CP_RGB(255, 127, 0);
    prePriceLable.font = [UIFont systemFontOfSize:10.0];
    prePriceLable.textAlignment = NSTextAlignmentRight;
    prePriceLable.text = [NSString stringWithFormat:@"¥%@", timeFreeListModel.pre_price];
    [self.gamePriceView addSubview:prePriceLable];
    
    UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.gamePriceView.width, 20)];
    pricelabel.centerY = self.gamePriceView.centerY - self.gamePriceView.y + 8;
    pricelabel.textColor = CP_RGB(0, 192, 139);
    pricelabel.font = [UIFont systemFontOfSize:11.0];
    pricelabel.textAlignment = NSTextAlignmentRight;
    
    if ([timeFreeListModel.price isEqualToString:@"0.00"]) {
        pricelabel.text = @"免费";
    }else{
        pricelabel.text = [NSString stringWithFormat:@"¥%@", timeFreeListModel.price];
    }
    
    [self.gamePriceView addSubview:pricelabel];
}


- (void)setGameDetail:(CPGameDetail *)gameDetail
{
    self.accessoryType = UITableViewCellAccessoryNone;
    
    _gameDetail = gameDetail; 
    
    //设置图片
    NSURL *imgUrl = [NSURL URLWithString:gameDetail.img];
    [self.gameImg sd_setImageWithURL:imgUrl];
    
    //游戏名
    CGSize nameSize = [NSString sizeWithText:gameDetail.name font:[UIFont systemFontOfSize:13.0] maxSize:CPMAXSIZE];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameSize.width, 16)];
    nameLabel.text = gameDetail.name;
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    [self.gameNameView addSubview:nameLabel];
    
    //游戏分类
    self.gameCategoryLabel.text = gameDetail.category;
    
    //游戏语言
    self.gameLanguageLabel.text = gameDetail.language;
    
    //游戏大小
    self.gameSizeLabel.text = gameDetail.size;
    
    //下载按钮
    UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.downView.width, 30)];
    downButton.backgroundColor = CP_RGB(0, 192, 139);
    downButton.centerY = self.downView.centerY;
//    downButton.centerX = self.downView.centerX - self.downView.x;
    downButton.titleLabel.font = downFont;
    downButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([gameDetail.price isEqualToString:@"0.00"]) {
        [downButton setTitle:@"下载(免费)" forState:UIControlStateNormal];
    }else{
        [downButton setTitle:[NSString stringWithFormat:@"下载(%@)",gameDetail.price] forState:UIControlStateNormal];
    }
    [self.downView addSubview:downButton];
    
    //action
    [downButton addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(238, 0, 50, 79)];
    self.gamePriceView = priceView;
    [self.contentView addSubview:priceView];
    
    //下载的view
     self.downView = ({
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width - downSize.width, 0, downSize.width + 15, 79)];
//        downView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:downView];
        downView;
     });
}


#pragma mark 下载
- (void)downClick
{
    CPLog(@"下载");
}

@end
