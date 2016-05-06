//
//  CPGallaryCollectionVCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGallaryCollectionVCell.h"
#import "CPGameInfo.h"

@interface CPGallaryCollectionVCell()
@end

@implementation CPGallaryCollectionVCell

- (void)setGallary:(CPGameGallary *)gallary
{
    _gallary = gallary;
    
    //加载图片
    CPLog(@"====%f===%f",self.width, self.height);
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    NSURL *imgUrl = [NSURL URLWithString:gallary.src];
    [imagView sd_setImageWithURL:imgUrl];
    [self addSubview:imagView];
} 
@end
