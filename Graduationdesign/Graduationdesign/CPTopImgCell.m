//
//  CPTopImgCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/8.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPTopImgCell.h"

#import "CPGameModel.h"


@interface CPTopImgCell()
@property (weak, nonatomic) IBOutlet UIImageView *myTopImageview;

@end

@implementation CPTopImgCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setGallaryModel:(CPGallaryModel *)gallaryModel
{
    _gallaryModel = gallaryModel;
    
    //设置滚动图片
    NSURL *gallaryUrl = [NSURL URLWithString:gallaryModel.src];
    [self.myTopImageview sd_setImageWithURL:gallaryUrl];
    
    //点击操作
    if ([self.delegate respondsToSelector:@selector(topImgCellClick:GallaryModel:)]) {
        [self.delegate topImgCellClick:self GallaryModel:gallaryModel];
    }
}
 
@end
