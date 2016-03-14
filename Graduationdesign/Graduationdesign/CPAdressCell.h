//
//  CPAdressCell.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPAdressModel;
@class CPCitiesModel;


@interface CPAdressCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableview;


@property (strong,nonatomic) CPAdressModel *provicemodel;
@property (strong,nonatomic) CPCitiesModel *citiesmodel;

@end
