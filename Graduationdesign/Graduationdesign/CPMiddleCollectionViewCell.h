//
//  CPMiddleCollectionViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPMiddleCollectionViewCell;

@protocol CPMiddleCollectionViewCellDelegate <NSObject>

@required
- (void)middleCollectionViewCellChooseTimeFree:(CPMiddleCollectionViewCell *)cell;
- (void)middleCollectionViewCellChooseNecessary:(CPMiddleCollectionViewCell *)cell;
- (void)middleCollectionViewCellChooseForum:(CPMiddleCollectionViewCell *)cell;
- (void)middleCollectionViewCellChooseGift:(CPMiddleCollectionViewCell *)cell;
@end

@interface CPMiddleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<CPMiddleCollectionViewCellDelegate> delegate;

@end
