//
//  CPTopImgCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/8.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGallaryModel;
@class CPTopImgCell;

@protocol CPTopImgCellDelegate <NSObject>

- (void)topImgCellClick:(CPTopImgCell *)topimgcell GallaryModel:(CPGallaryModel *)gallaryModel;
@end

@interface CPTopImgCell : UICollectionViewCell

@property (nonatomic, strong) CPGallaryModel *gallaryModel;

@property (nonatomic, weak) id<CPTopImgCellDelegate> delegate;
@end
