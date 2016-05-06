//
//  CPAbstractCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPAbstractCell.h"
#import "CPGameDetailCellFooterView.h"
#import "CPGameCellFrame.h"
#import "CPGameInfo.h"

@interface CPAbstractCell()<CPGameDetailCellFooterViewDelegate>

@property (nonatomic, strong) UITextView *myTextView;

@property (nonatomic, copy) NSString *fixAbstract;

@end

@implementation CPAbstractCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CPAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPAbstractCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPAbstractCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.myTextView = ({
        UITextView *textview = [[UITextView alloc] init];
        textview.font = [UIFont systemFontOfSize:11.0];
        textview.selectable = NO;
        textview.editable = NO;
        textview.scrollEnabled = NO;
        
        textview;
    });
}


- (void)setGameCellFrame:(CPGameCellFrame *)gameCellFrame withShowOrHide:(BOOL)show
{
    if (!show) {
        self.contentView.height = gameCellFrame.detailHideF.size.height;
    }else{
        self.contentView.height = gameCellFrame.detailF.size.height;
    }

    CPGameDetailCellFooterView *gameFooter = [CPGameDetailCellFooterView gameDetailCellFooterView];
    gameFooter.delegate = self;
    gameFooter.y = self.contentView.height - gameFooter.height;
 
    
    //内容概要
//    CGFloat textvieHeight = mySencondCellShow ? gameCellFrame.detailF.size.height : (gameCellFrame.detailF.size.height * 0.4);
     
    
    self.myTextView.frame = CGRectMake(0, 0, gameCellFrame.detailF.size.width, self.contentView.height);
    
    self.fixAbstract = gameCellFrame.gameDetail.abstract;
    [self FixBody];
    
    self.myTextView.text = self.fixAbstract;//gameCellFrame.gameDetail.abstract;
    self.myTextView.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.myTextView];
    [self.contentView addSubview:gameFooter];
}

//处理字符串里字符
//@"【温馨提示】
//
//【活动1】每日游戏盒签到领造梦OL好礼，5级强化石等你签！</span>\n
//【活动介绍】造梦西游OL联手4399游戏盒为玩家送上给力福利，每日签到即可领取造梦OL的超级好礼：五级强化石、仙魂币、仙气、战功、灵魂等你来拿，签得越多拿得越好。让你游戏里面快人一步，速度成长，今天你签到了吗？\n
//更多活动详情请点击&gt;&gt;&gt;\n
//
//【活动2】<span style=\"color:#FF0000;\">《造梦西游OL》神兵觉醒，全新神技降临！</span>\n
//寒假结束，开学季又可以与昔日的同学、小伙伴们相聚，每天愉快的学习玩耍了，想来就有点小兴奋呢!如今《造梦西游OL》推出了开学版本（5.6.0），更新了全新装备觉醒和跨服聊天，具体新版本内容一起来看一下吧!\n
//<span style=\"line-height: 20.7999992370605px;\">更多活动详情请点击&gt;&gt;&gt;<a href=\"http://bbs.4399.cn/thread-tid-3487850\" target=\"_blank\">活动地址2</a></span>\n<strong style=\"line-height: 20.7999992370605px; color: rgb(255, 0, 0);\">【活动3】<span style=\"line-height: 20.7999992370605px; color: rgb(255, 0, 0);\">春季大放送，《造梦西游OL》福利巨轮说造就造！</span><br style=\"line-height: 20.7999992370605px;\" />\n<span style=\"line-height: 20.7999992370605"	0x00007f8ba115ce00

- (void)FixBody
{
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</p>" withString:@"                                                                                                    "];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--VIDEO#0-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--VIDEO#1-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--VIDEO#2-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--SPINFO#0-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--@@PRE-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--@@H2-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<!--@@H1-->" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<p align=\"center\">" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<font color=\"#a4512c\">" withString:@""];
    
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"<span style=\"color:#FF0000;\">" withString:@""];
    
    self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:@"</a>" withString:@">"];
    
    
    NSScanner * scanner = [NSScanner scannerWithString:self.fixAbstract];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    for (NSInteger i = 0; i < 50; i++) {
    //        self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--link%ld-->", i] withString:@""];
    //    }
    //    for (NSInteger i = 0; i < 100; i++) {
    //        self.fixAbstract = [self.fixAbstract stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--IMG#%ld-->", i] withString:@""];
    //    }
}
#pragma mark gameDetailCellFooterView代理
- (void)gameDetailCellFooterViewShowOrHideButtonClick:(CPGameDetailCellFooterView *)view show:(BOOL)show
{
    if ([self.delegate respondsToSelector:@selector(abstractCellShowOrHideDetail:)]) {
        [self.delegate abstractCellShowOrHideDetail:self];
    }
}

@end
