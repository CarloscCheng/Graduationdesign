//
//  CPGameCellFrame.h
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPGameResult;
@class CPGameDetail;

@interface CPGameCellFrame : NSObject
/**
 *  游戏截图F
 */
@property (nonatomic, assign, readonly) CGRect gallaryF;
/**
 *  内容概要F
 */
@property (nonatomic, assign, readonly) CGRect detailF;

@property (nonatomic, assign, readonly) CGRect detailHideF;
/**
 *  游戏视频F
 */
@property (nonatomic, assign, readonly) CGRect vedioF;

/**
 *  游戏相关新闻F
 */
@property (nonatomic, assign, readonly) CGRect relateNewsF;
/**
 *  用户评论F
 */
@property (nonatomic, assign, readonly) CGRect commentsF;
/**
 *  游戏相关游戏F
 */
@property (nonatomic, assign, readonly) CGRect relateGameF;

/**
 *  CPGameResult模型
 */
@property (nonatomic, strong) CPGameResult *gameResult;
@property (nonatomic, strong) CPGameDetail *gameDetail;
@end
