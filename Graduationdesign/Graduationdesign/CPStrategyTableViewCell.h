//
//  CPStrategyTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameResult;

@interface CPStrategyTableViewCell : UITableViewCell

+ (instancetype)gameStrategyCellCreate:(UITableView *)tableview;

@property (nonatomic, strong) CPGameResult *gameResultModel;

@end
