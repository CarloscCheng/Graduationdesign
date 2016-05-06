//
//  CPReleateGameView.m
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPReleateGameView.h"
#import "CPGameCellFrame.h"
#import "CPGameInfo.h"
#import "CPReleateGameCollectionVCell.h"

#define EACHVIEWGAMENUM 4

@interface CPReleateGameView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *gameArray;

@end

@implementation CPReleateGameView

+ (instancetype)releateGame
{
    CPReleateGameView *view = [[CPReleateGameView alloc] init];
    return view;
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.collectionView = ({
            UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumLineSpacing = 0.0f;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.pagingEnabled = YES;
            
            [collectionView registerClass:[CPReleateGameCollectionVCell class] forCellWithReuseIdentifier:NSStringFromClass([CPReleateGameCollectionVCell class])];
            
            collectionView.pagingEnabled = YES;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; 
            collectionView.showsHorizontalScrollIndicator = NO;
            [self addSubview:collectionView];
            
            collectionView;
        });
    }
    return self;
} 

- (void)setGamecellFrame:(CPGameCellFrame *)gamecellFrame 
{
    _gamecellFrame = gamecellFrame;
    self.collectionView.frame = CGRectMake(0, 0, self.width, gamecellFrame.relateGameF.size.height);
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark 懒加载
- (NSArray *)gameArray{
    if (_gameArray == nil) {
        _gameArray = self.gamecellFrame.gameResult.relateGame;
    }
    return _gameArray;

}

#pragma mark <UICollectionView>的数据源
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gameArray.count / EACHVIEWGAMENUM;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPReleateGameCollectionVCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CPReleateGameCollectionVCell class]) forIndexPath:indexPath];

    [cell setReleateGameArray:[self getEachGameViewGame:indexPath] cellFrame:self.gamecellFrame];

    CPLog(@"%ld===%ld",indexPath.row ,indexPath.section);
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, self.gamecellFrame.relateGameF.size.height);
}

#pragma mark 一个collectionviewcell上的四个游戏数组
- (NSArray *)getEachGameViewGame:(NSIndexPath *)indexpath
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < EACHVIEWGAMENUM; i ++) {
        [arr addObject:self.gameArray[(indexpath.row * 4) + i]];
    }
    return arr;
}

@end
