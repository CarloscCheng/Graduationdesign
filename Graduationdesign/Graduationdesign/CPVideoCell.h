//
//  CPVideoCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameVideoList;

@interface CPVideoCell : UITableViewCell

+ (instancetype)videoCellCreate:(UITableView *)tableview;
@property (nonatomic, strong) CPGameVideoList *videoList;
@end
