//
//  CPGameDetailTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameDetail;

@interface CPGameDetailTableViewCell : UITableViewCell

+ (instancetype)gameDetailCellCreate:(UITableView *)tableview;

@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, strong) CPGameDetail *gameDetailModel;

@end
