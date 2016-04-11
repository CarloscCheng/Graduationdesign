//
//  CPBottomCollectionViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPNewListModel;
@class CPHotListModel;

@interface CPBottomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CPNewListModel *newlistModel;
@property (nonatomic, strong) CPHotListModel *hotlistModel;
@end
