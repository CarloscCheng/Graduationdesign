//
//  CPVideoTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPVideoTableViewCell.h"
#import "CPVCModel.h"

@interface CPVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImgView;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end


static NSString *ID = @"video";

@implementation CPVideoTableViewCell

+ (instancetype)videoCellCreate:(UITableView *)tableview
{
    CPVideoTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPVideoTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setVcTopModel:(CPVCTopModel *)vcTopModel
{
    _vcTopModel = vcTopModel;

    //设置图片
    NSURL *imgUrl = [NSURL URLWithString:vcTopModel.img];
    [self.myImgView sd_setImageWithURL:imgUrl];
    
    self.myTextView.text = [NSString stringWithFormat:@"  【专题简介】%@",vcTopModel.desc];
}


- (void)awakeFromNib
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:10.0],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.myTextView.attributedText = [[NSAttributedString alloc] initWithString:@"输入你的内容" attributes:attributes];
    
    self.myTextView.editable = NO; 
    self.myTextView.selectable = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
