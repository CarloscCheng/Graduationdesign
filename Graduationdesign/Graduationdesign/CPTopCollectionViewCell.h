//
//  CPTopCollectionViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGallaryModel;
@class CPTopCollectionViewCell;

@protocol CPTopCollectionViewCellDelegate <NSObject>
@required
/**
 *  跳转固定UI
 *
 *  @param topCollectionViewCell CollectionViewCell
 *  @param gallaryModel          Gallary模型
 */
- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell WebGameGallaryModel:(CPGallaryModel *)gallaryModel;

/**
 *  跳转到网页游戏页面
 *
 *  @param topCollectionViewCell CollectionViewCell
 *  @param gallaryModel          Gallary模型
 */
- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell WebArticleGallaryModel:(CPGallaryModel *)gallaryModel;

/**
 *  跳转到网页文章页面
 *
 *  @param topCollectionViewCell CollectionViewCell
 *  @param gallaryModel          Gallary模型
 */
- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell VCGallaryModel:(CPGallaryModel *)gallaryModel;
@end


@interface CPTopCollectionViewCell : UICollectionViewCell


@property (nonatomic, weak) id<CPTopCollectionViewCellDelegate> delegate;
@end
