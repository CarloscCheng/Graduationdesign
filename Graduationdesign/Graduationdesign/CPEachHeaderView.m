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
@property (nonatomic, readonly) NSUInteger segmentsCount;
@property (nonatomic, strong) NSMutableArray *segmentedArray;
@end

@implementation CPEachHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
//        self.backgroundColor =[UIColor blueColor];
        _segmentsCount = 1;
        self.segmentedArray = [[NSMutableArray alloc] initWithObjects:@"游戏介绍", nil];
    }
    return self;
}

+ (instancetype)eachHeaderView
{
    return [[self alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
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
    
    if (gameStrategy.list.count != 0) {
        _segmentsCount += 1;
        [self.segmentedArray addObject:@"攻略"];
    }
    if (gameVideo.list.count != 0) {
        _segmentsCount += 1; 
        [self.segmentedArray addObject:@"精彩视频"];
    }
    //添加UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, self.width, self.height);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor lightGrayColor];
    [self addSubview:segmentedControl];
}


@end
