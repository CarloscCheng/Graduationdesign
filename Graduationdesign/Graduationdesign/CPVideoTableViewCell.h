//
//  CPVideoTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPVCTopModel;

@interface CPVideoTableViewCell : UITableViewCell

+ (instancetype)videoCellCreate:(UITableView *)tableview;

@property (nonatomic, strong) CPVCTopModel *vcTopModel;
@end
