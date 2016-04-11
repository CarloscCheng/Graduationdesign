 //
//  CPBottomCollectionViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPBottomCollectionViewCell.h"
#import "CPGameModel.h"

//
#define descSize [NSString sizeWithText:@"这是我的毕业设计标准的十五个字" font:[UIFont systemFontOfSize:9.0] maxSize:CPMAXSIZE]
#define cateGorySize [NSString sizeWithText:@"休闲" font:[UIFont systemFontOfSize:9.0] maxSize:CPMAXSIZE]

#define LINESTRLENGTH 15
#define CATEGORYLENGTH 2
@interface CPBottomCollectionViewCell()<UITextViewDelegate>
/**
 *  下方collectioncellview的imgview
 */
@property (weak, nonatomic) IBOutlet UIImageView *myBottomImgView;
/**
 *  游戏名称
 */
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
/**
 *  描述所在的view
 */
@property (weak, nonatomic) IBOutlet UIView *descView;


@property (nonatomic, weak) UILabel *topLabel;
@property (nonatomic, weak) UILabel *middleLabel;
@property (nonatomic, weak) UILabel *bottomLabel;
@end

@implementation CPBottomCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.descView.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, descSize.width, descSize.height)];
    topLabel.font = [UIFont systemFontOfSize:9.0];
    topLabel.textColor = [UIColor grayColor];
    topLabel.numberOfLines = 0;
    
    self.topLabel = topLabel;
    [self.descView addSubview:topLabel];

    UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topLabel.y + descSize.height, cateGorySize.width, cateGorySize.height)];
    middleLabel.x = topLabel.width - cateGorySize.width;
    middleLabel.font = [UIFont systemFontOfSize:9.0];
    middleLabel.adjustsFontSizeToFitWidth = YES;
    middleLabel.textColor = [UIColor grayColor];
    
    self.middleLabel = middleLabel;
    [self.descView addSubview:middleLabel];

    UIImageView *middleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_indicator_green"]];
    middleImgView.frame = CGRectMake(middleLabel.x - cateGorySize.height - 3, topLabel.y + cateGorySize.height, cateGorySize.height - 3, cateGorySize.height - 3);
    middleImgView.centerY = middleLabel.centerY;
    [self.descView addSubview:middleImgView];

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, middleLabel.y + descSize.height, self.descView.width, descSize.height)];
    bottomLabel.font = middleLabel.font;
    bottomLabel.font = [UIFont systemFontOfSize:9.0];
    bottomLabel.textColor = [UIColor grayColor];
    
    self.bottomLabel = bottomLabel;
    [self.descView addSubview:bottomLabel];
    
    CPLog(@"heighy = %f",bottomLabel.y + bottomLabel.height);
     
}


- (void)setNewlistModel:(CPNewListModel *)newlistModel
{
    _newlistModel = newlistModel;
    
    NSURL *newlistUrl = [NSURL URLWithString:newlistModel.img]; 
    [self.myBottomImgView sd_setImageWithURL:newlistUrl];
    
    self.gameNameLabel.text = newlistModel.name;
    
    self.topLabel.text = [newlistModel.desc substringWithRange:NSMakeRange(0, LINESTRLENGTH)];
    self.middleLabel.text = [newlistModel.category substringWithRange:NSMakeRange(0, CATEGORYLENGTH)];
    self.bottomLabel.text = [newlistModel.desc substringWithRange:NSMakeRange(LINESTRLENGTH, newlistModel.desc.length - LINESTRLENGTH)];
}

- (void)setHotlistModel:(CPHotListModel *)hotlistModel
{
    _hotlistModel = hotlistModel;
    NSURL *hotlistUrl = [NSURL URLWithString:hotlistModel.img];
    [self.myBottomImgView sd_setImageWithURL:hotlistUrl];
    
    self.gameNameLabel.text = hotlistModel.name;
    self.topLabel.text = [hotlistModel.desc substringWithRange:NSMakeRange(0, LINESTRLENGTH)];
    self.middleLabel.text = [hotlistModel.category substringWithRange:NSMakeRange(0, CATEGORYLENGTH)];
    self.bottomLabel.text = [hotlistModel.desc substringWithRange:NSMakeRange(LINESTRLENGTH, hotlistModel.desc.length - LINESTRLENGTH)];
}

@end
