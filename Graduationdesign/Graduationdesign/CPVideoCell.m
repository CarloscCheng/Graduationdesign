//
//  CPVideoCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPVideoCell.h"
#import "CPGameInfo.h"

@interface CPVideoCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImgView;
@property (weak, nonatomic) IBOutlet UILabel *myDetail;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CPVideoCell

+ (instancetype)videoCellCreate:(UITableView *)tableview
{
    CPVideoCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPVideoCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPVideoCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setVideoList:(CPGameVideoList *)videoList
{
    _videoList = videoList;
    
    NSURL *url = [NSURL URLWithString:videoList.img]; 
    [self.myImgView sd_setImageWithURL:url];
    
    self.myDetail.text = videoList.title;
    self.authorLabel.text = videoList.author;
    self.timeLabel.text = videoList.created;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
