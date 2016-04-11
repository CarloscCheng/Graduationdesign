//
//  CPGameTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVCGameList;
@interface CPGameTableViewCell : UITableViewCell

+ (instancetype)gameCellCreate:(UITableView *)tableview;

@property (nonatomic, strong) CPVCGameList *gameList;

@end

