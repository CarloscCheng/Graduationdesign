//
//  CPStrategyCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameStrategyList;

@interface CPStrategyCell : UITableViewCell

+ (instancetype)strategyCellCreate:(UITableView *)tableview;

@property (nonatomic, strong) CPGameStrategyList *gameStrategyList;

@end
