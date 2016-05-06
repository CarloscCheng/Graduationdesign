//
//  CPAbstractCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameCellFrame;
@class CPAbstractCell;

@protocol CPAbstractCellDelegate <NSObject>
- (void)abstractCellShowOrHideDetail:(CPAbstractCell *)cell;

@end


@interface CPAbstractCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setGameCellFrame:(CPGameCellFrame *)gameCellFrame withShowOrHide:(BOOL)show;

@property (nonatomic, weak) id<CPAbstractCellDelegate> delegate;
@end
