//
//  CPNewsTableViewCell.h
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameRelatenews;

@interface CPNewsTableViewCell : UITableViewCell

+ (instancetype)newsCellWithTableView:(UITableView *)tableView;

//@property (nonatomic, strong) CPGameRelatenews *news;

- (void)setNews:(CPGameRelatenews *)news height:(CGFloat)height;
@end
