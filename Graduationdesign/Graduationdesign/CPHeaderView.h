//
//  CPHeaderView.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//


#import <UIKit/UIKit.h>
@class CPDeviceGroup;
@class CPHeaderView;

//定义一个block
typedef BOOL(^loginStatusBlock)();

@protocol CPHeaderViewDelegate <NSObject>

@optional
- (void)headerViewDidTouchView:(CPHeaderView *)headerView;
- (void)headerViewDidChooseCity:(CPHeaderView *)headerView;
@end

@interface CPHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CPDeviceGroup *group;

@property (nonatomic, weak) id<CPHeaderViewDelegate> delegate;

//外部block接口
- (void)setAppLoginStatus:(loginStatusBlock)block;

@end
