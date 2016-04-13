//
//  CPGameTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVCGameList;
@class CPTimeFreeListModel;
@class CPGameDetail;

@interface CPGameTableViewCell : UITableViewCell

+ (instancetype)gameCellCreate:(UITableView *)tableview;

@property (nonatomic, strong) CPVCGameList *gameList;
@property (nonatomic, strong) CPTimeFreeListModel *timeFreeListModel;

@property (nonatomic, strong) CPGameDetail *gameDetail;
@end

