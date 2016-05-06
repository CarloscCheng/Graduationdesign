//
//  CPEachHeaderView.m
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPEachHeaderView.h"
#import "CPGameInfo.h"

@interface CPEachHeaderView()

@property (nonatomic, weak) UIView *headerView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end


static NSInteger selectIndex = 0;

@implementation CPEachHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        //添加UISegmentedControl
        self.segmentedControl = ({
            UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] init];//WithItems:self.segmentedArray];
            [segmentedControl insertSegmentWithTitle:@"游戏介绍" atIndex:0 animated:NO];
            segmentedControl.tintColor = [UIColor lightGrayColor];
//            segmentedControl.selectedSegmentIndex = selectIndex;
            
            [self addSubview:segmentedControl];

            [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
            
            segmentedControl;
        });
    }
    return self;
}

+ (instancetype)eachHeaderView
{
    return [[self alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
}

//根据模型不同设置不同的headerView
- (void)setGameResult:(CPGameResult *)gameResult
{
    _gameResult = gameResult;
    //游戏详情模型
    CPGameDetail *gameDetail = [CPGameDetail gameDetailWithDict:gameResult.detail];
    //游戏攻略模型
    CPGameStrategy *gameStrategy = [CPGameStrategy gameStrategyWithDict:gameResult.strategy];
    //游戏视频模型
    CPGameVideo *gameVideo = [CPGameVideo gameVideoWithDict:gameResult.video];
    
    
    
    CGFloat padding = 10;
    self.segmentedControl.frame = CGRectMake(0, padding, self.width, self.height - 2 * padding);
    
    if (gameStrategy.list.count != 0) {
        [self.segmentedControl insertSegmentWithTitle:@"攻略" atIndex:1 animated:NO];
    }
    if (gameVideo.list.count != 0) {
        [self.segmentedControl insertSegmentWithTitle:@"精彩视频" atIndex:2 animated:NO];
    }

}

#pragma mark segmentedControl
- (void)segmentedControlAction:(UISegmentedControl *)seg {
    NSString *title = [seg titleForSegmentAtIndex:seg.selectedSegmentIndex];
//    self.segmentedControl.selectedSegmentIndex = seg.selectedSegmentIndex;
    CPLog(@"index = %ld",selectIndex);
     
    if ([title isEqualToString:@"游戏介绍"]) {
        if ([self.delegate respondsToSelector:@selector(eachHeaderViewChooseGameDetail:)]) {
            [self.delegate eachHeaderViewChooseGameDetail:self];
        }
        selectIndex = 0;
    }else if ([title isEqualToString:@"攻略"]) {
        if ([self.delegate respondsToSelector:@selector(eachHeaderViewChooseGameStrategy:)]) {
            [self.delegate eachHeaderViewChooseGameStrategy:self];
        }
        selectIndex = 1;
    }else if ([title isEqualToString:@"精彩视频"]) {
        if ([self.delegate respondsToSelector:@selector(eachHeaderViewChooseGameVideo:)]) {
            [self.delegate eachHeaderViewChooseGameVideo:self];
        }
        selectIndex = 2;
    } 
} 

 
@end
