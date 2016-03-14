//
//  CPAdressCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPAdressCell.h"
#import "CPAdressModel.h"
#import "CPCitiesModel.h"
@interface CPAdressCell()
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end


@implementation CPAdressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"adress";
    CPAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPAdressCell" owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)setProvicemodel:(CPAdressModel *)provicemodel
{
    _provicemodel = provicemodel;
    self.cellTitle.text = provicemodel.State;
}


- (void)setCitiesmodel:(CPCitiesModel *)citiesmodel
{
    _citiesmodel = citiesmodel;
    self.cellTitle.text = citiesmodel.Areaname;
}
@end
