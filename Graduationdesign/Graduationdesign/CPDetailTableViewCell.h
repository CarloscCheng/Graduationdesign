//
//  CPDetailTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameCellFrame;

@interface CPDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setGameCellFrame:(CPGameCellFrame *)gameCellFrame section:(NSInteger)section;

@property (nonatomic, assign, getter=isSencondShow) BOOL sencondShow;

@end
