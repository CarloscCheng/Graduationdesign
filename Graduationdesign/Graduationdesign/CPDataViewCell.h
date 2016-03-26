//
//  CPDataViewCell.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPData;

@protocol CPDataViewCellDelegate <NSObject>

@optional
- (void)dataViewCellChooseAlterImage:(UITableViewCell *)tableviewcell;
- (void)dataViewCellChooseAlterName:(UITableViewCell *)tableviewcell;
- (void)dataViewCellChooseAlterSex:(UITableViewCell *)tableviewcell;
- (void)dataViewCellChooseAlterBirth:(UITableViewCell *)tableviewcell;
- (void)dataViewCellChooseAlterPwd:(UITableViewCell *)tableviewcell;
- (void)dataViewCellChooseAlterLimit:(UITableViewCell *)tableviewcell;
@end

@interface CPDataViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 *  个人资料模型
 */
@property (nonatomic, strong) CPData *data;


- (void)alterDataWith:(CPData *)data;

@property (weak, nonatomic) id<CPDataViewCellDelegate> delegate;
@end
