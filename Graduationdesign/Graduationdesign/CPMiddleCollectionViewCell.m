//
//  CPMiddleCollectionViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPMiddleCollectionViewCell.h"

@interface CPMiddleCollectionViewCell()

//限免
- (IBAction)timeFree;
//必备
- (IBAction)Necessary;
//论坛
- (IBAction)Forum;
//礼包
- (IBAction)Gift;


@end



@implementation CPMiddleCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)timeFree {
    CPLog(@"限免");
    if ([self.delegate respondsToSelector:@selector(middleCollectionViewCellChooseTimeFree:)]) {
        [self.delegate middleCollectionViewCellChooseTimeFree:self];
    }
}

- (IBAction)Necessary {
    CPLog(@"必备");
    if ([self.delegate respondsToSelector:@selector(middleCollectionViewCellChooseNecessary:)]) {
        [self.delegate middleCollectionViewCellChooseNecessary:self];
    }
}

- (IBAction)Forum {
    CPLog(@"论坛");
    if ([self.delegate respondsToSelector:@selector(middleCollectionViewCellChooseForum:)]) {
        [self.delegate middleCollectionViewCellChooseForum:self];
    }
}

- (IBAction)Gift {
    CPLog(@"礼包");
    if ([self.delegate respondsToSelector:@selector(middleCollectionViewCellChooseGift:)]) {
        [self.delegate middleCollectionViewCellChooseGift:self];
    }
}
@end
