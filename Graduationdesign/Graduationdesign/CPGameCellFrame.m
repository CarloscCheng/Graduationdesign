//
//  CPGameCellFrame.m
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameCellFrame.h"
#import "CPGameInfo.h"

@interface CPGameCellFrame()

@property (nonatomic, copy) NSString *fixAbstract;

@end

@implementation CPGameCellFrame

- (void)setGameResult:(CPGameResult *)gameResult
{
    _gameResult = gameResult;

    //游戏截图
    CPGameGallary *gallary = [CPGameGallary gallaryWithDict:(NSDictionary *)[gameResult.gallary lastObject]];
    CGFloat oriW = [gallary.width floatValue];
    CGFloat oriH = [gallary.height floatValue];
    
    //缩放比例
    CGFloat padding = 0;
    if (oriW <= oriH) {
        //长大于宽
        padding = 80;
    }else {
        //长小于宽
        padding = 10;
    }
    CGFloat width = 320 - padding * 2;
    CGFloat newH = (width * oriH) / oriW;
    _gallaryF = CGRectMake(0, 0, width, newH);
    
    //内容概要
    CPGameDetail *detail = [CPGameDetail gameDetailWithDict:(NSDictionary *)gameResult.detail];
    self.fixAbstract = detail.abstract;
    [self FixBody];
    
    self.gameDetail = detail;
    CGSize detailSize = [NSString sizeWithText:self.fixAbstract font:[UIFont systemFontOfSize:11.0] maxSize:CGSizeMake(320, MAXFLOAT)];
    
//    NSString *hideStr = [self.fixAbstract substringToIndex:self.fixAbstract.length * 0.5];
    
    CGSize detailHideSize = [NSString sizeWithText:self.fixAbstract font:[UIFont systemFontOfSize:11.0] maxSize:CGSizeMake(320, 100)];
    
    //默认展开时候的高度 
    _detailF = CGRectMake(0, 0, 320, detailSize.height + 35);
    
    _detailHideF = CGRectMake(0, 0, 320, detailHideSize.height + 35);
    
    //游戏视频
    //游戏视频模型
    CPGameVideo *video = [CPGameVideo gameVideoWithDict:self.gameResult.video];
    if (video.list.count != 0) {
        _vedioF = CGRectMake(0, 0, 320, 160);
    }else{
        _vedioF = CGRectMake(0, 0, 320, 0);
    }
    //游戏相关新闻
    //新闻个数
    CGFloat eachNews = 44;
    NSArray *news = gameResult.relateNews;
    _relateNewsF = CGRectMake(0, 0, 320, eachNews * news.count);
    
//    //用户评论
//    _commentsF = CGRectMake(0, 0, 0, 50);

    //游戏相关游戏
    CGFloat gameH = 80;
    _relateGameF = CGRectMake(0, 0, 320, gameH);
}

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



@end
