//
//  CPDataViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDataViewCell.h"
#import "CPData.h"
@interface CPDataViewCell()<UIActionSheetDelegate>
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *detail;
/**
 *  详细信息
 */
@property (weak, nonatomic) IBOutlet UILabel *subDetail;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIButton *imgButton;

/**
 *  分割线
 */
@property (weak,nonatomic) UIView *splitline;

@end

@implementation CPDataViewCell

//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"data";
    CPDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPDataViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setData:(CPData *)data
{
    //设置属性
    _data = data;
    self.detail.text = data.detail;
    self.subDetail.text = data.subdetail;
    //设置按钮圆角
    //设置注销按钮圆角半径
    [self.imgButton.layer setCornerRadius:10.0];
    [self.imgButton setBackgroundImage:[UIImage imageNamed:data.img] forState:UIControlStateNormal];
    
//    //设置头像为圆角显示
//    self.imgButton.imageView.layer.masksToBounds = YES;//没这句话它圆不起来
//    self.imgButton.imageView.layer.cornerRadius = 25.0;//设置图片圆角的尺度
    
    //设置cell的编辑属性
    if (data.isSelected) {
        //设置右边辅助按钮
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        //设置该cell不可被选择操作
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}


- (void)awakeFromNib
{
    // Initialization code

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
