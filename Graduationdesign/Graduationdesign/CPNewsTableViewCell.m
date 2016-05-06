//
//  CPNewsTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPNewsTableViewCell.h"
#import "CPGameInfo.h"
@interface CPNewsTableViewCell()

/**
 *  类型
 */
@property (nonatomic, strong) UIButton *typeButton;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *relateTitleLabel;

/**
 *  查看
 */
@property (nonatomic, strong) UILabel *lookLabel;
@end

@implementation CPNewsTableViewCell

+ (instancetype)newsCellWithTableView:(UITableView *)tableView
{
    CPNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPNewsTableViewCell class])];
    if (cell == nil) {
        cell = [[CPNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CPNewsTableViewCell class])];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//        self.backgroundColor = [UIColor redColor];
        self.typeButton = ({
            UIButton *typeButton = [[UIButton alloc] init];
            typeButton.centerY = self.contentView.centerY;
            typeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.contentView addSubview:typeButton];
            
            typeButton;
        });
        
        self.relateTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:11.0];
            [self.contentView addSubview:label];
            
            label;
        });
        
        
        self.lookLabel = ({
            CGSize lookSize = [NSString sizeWithText:@"查看" font:[UIFont systemFontOfSize:11.0] maxSize:CPMAXSIZE];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lookSize.width, lookSize.height)];
            label.text = @"查看";
            label.font = [UIFont systemFontOfSize:11.0];
            label.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:label];
            
            label;
        });

    }
    return self;
} 

- (void)setNews:(CPGameRelatenews *)news height:(CGFloat)height
{
//    _news = news;
    CGFloat padding = 10;
    CGFloat centerY = height * 0.5;
    //类型
    self.typeButton.frame = CGRectMake(padding, 0, 30, 16);
    self.typeButton.centerY = height * 0.5;
    
    [self.typeButton setTitle:news.typeName forState:UIControlStateNormal]; 
    if ([news.typeName isEqualToString:@"新闻"]) {
        self.typeButton.backgroundColor = CP_RGB(0, 192, 139);
    }else if ([news.typeName isEqualToString:@"评测"]){
        self.typeButton.backgroundColor = CP_RGB(87, 141, 199);
    }

    //查看
    self.lookLabel.centerY = centerY;
    self.lookLabel.x = self.contentView.width - self.lookLabel.width - 30;
    
    //相关标题
    self.relateTitleLabel.frame = CGRectMake(self.typeButton.x + self.typeButton.width + padding, 0, self.lookLabel.x - (self.typeButton.x + self.typeButton.width + padding * 2 ), self.lookLabel.height);
    self.relateTitleLabel.centerY = centerY;
    self.relateTitleLabel.text = news.title;
    
}

@end
