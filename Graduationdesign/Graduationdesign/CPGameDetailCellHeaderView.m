//
//  CPGameDetailCellHeaderView.m
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameDetailCellHeaderView.h"

#define LABELFONT [UIFont systemFontOfSize:13.0]
#define LABELSIZE [NSString sizeWithText:@"标准四字" font:LABELFONT maxSize:CPMAXSIZE]
#define PADDING 8

@interface CPGameDetailCellHeaderView()

@property (nonatomic, strong) UIImageView *secitonImageView;
@property (nonatomic, strong) UILabel *sectionLabel;

@end

@implementation CPGameDetailCellHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = CP_RGB(239, 239, 244);
        
        self.secitonImageView = ({
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, 0, 16, 16)];
            imageview.centerY = frame.size.height * 0.5;
            [self addSubview:imageview];
            imageview; 
        });
        

        self.sectionLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.secitonImageView.x + self.secitonImageView.width + PADDING, 0, LABELSIZE.width, LABELSIZE.height)];
            label.centerY = frame.size.height * 0.5;
            label.font = LABELFONT;
            [self addSubview:label];
            label; 
        });

    }
    return self;
}

+ (instancetype)gameDetailCellHeaderView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
}


- (void)setCellSection:(NSUInteger)cellSection
{
    _cellSection = cellSection; 
    
    if (cellSection == 0) {
        //游戏截图
        self.secitonImageView.image = [UIImage imageNamed:@"screenshot_section_icon"];
        self.sectionLabel.text = @"游戏截图";
    }else if (cellSection == 1) {
        //内容摘要
        self.secitonImageView.image = [UIImage imageNamed:@"content_section_icon"];
        self.sectionLabel.text = @"内容摘要";
    }else if (cellSection == 2) {
        //游戏视频
        self.secitonImageView.image = [UIImage imageNamed:@"video_section_icon"];
        self.sectionLabel.text = @"游戏视频";
    }else if (cellSection == 3) {
        //游戏相关
        self.secitonImageView.image = [UIImage imageNamed:@"relate_section_icon"];
        self.sectionLabel.text = @"游戏相关";
//    }else if (cellSection == 4) {
//        //用户评论
//        self.secitonImageView.image = [UIImage imageNamed:@"section_comment"];
//        self.sectionLabel.text = @"用户评论";
    }else if (cellSection == 5) {
        //游戏推荐
        self.secitonImageView.image = [UIImage imageNamed:@"suggest_section_icon"];
        self.sectionLabel.text = @"游戏推荐";
    }
    
}
@end
