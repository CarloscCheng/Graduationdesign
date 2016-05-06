//
//  CPReleateGameCollectionVCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPReleateGameCollectionVCell.h"
#import "CPGameInfo.h"
#import "CPGameCellFrame.h"

@interface CPReleateGameCollectionVCell()


@property (nonatomic, weak) UILabel *mylabel;
@end

@implementation CPReleateGameCollectionVCell

- (void)setReleateGameArray:(NSArray *)array cellFrame:(CPGameCellFrame *)gameCellFrame {
    //设置button
    CGFloat imgViewH = gameCellFrame.relateGameF.size.height - 20;    //60
//    CGFloat padding = (gameCellFrame.relateGameF.size.width - array.count * imgViewH) / 5;
    CGFloat viewW = 320 / array.count;
    for (int i = 0; i < array.count; i ++) {
        CPGameRelategame *relategame = [CPGameRelategame relategameWithDict:array[i]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * viewW, 0, viewW, self.contentView.height)];
        [self.contentView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, imgViewH, imgViewH)];
        imageView.centerX = view.centerX - view.x;
        [imageView sd_setImageWithURL:[NSURL URLWithString:relategame.img]];
        [view addSubview:imageView];
        
        CGSize nameSize = [NSString sizeWithText:relategame.name font:[UIFont systemFontOfSize:9.0] maxSize:CPMAXSIZE];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameSize.width, nameSize.height)];
        label.centerX = view.centerX - view.x;
        label.y = 15 * 0.2 + imageView.y + imageView.height;
        label.font = [UIFont systemFontOfSize:9.0];
        label.text = relategame.name;
        
        self.mylabel = label;
        [view addSubview:self.mylabel];
    }
}
@end
