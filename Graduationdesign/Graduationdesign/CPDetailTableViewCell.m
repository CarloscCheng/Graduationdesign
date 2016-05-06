//
//  CPDetailTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPDetailTableViewCell.h"
#import "CPGameInfo.h"
#import "CPGameCellFrame.h"
#import "CPGallaryCollectionVCell.h"
#import "CPPageControl.h"
#import "CPNewsTableViewCell.h"
#import "CPReleateGameView.h"

//记录简介处的cell展开和收起的状态
static BOOL mySencondCellShow;

@interface CPDetailTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) NSArray *imagArray;
@property (nonatomic, strong) NSArray *newsArray;

@property (nonatomic, strong) CPGameCellFrame *gameCellFrame;

@property (nonatomic, strong) UIPageControl *pageControl;



@property (nonatomic, strong) UIImageView *videoShowImgView;

@property (nonatomic, strong) UITableView *newsTableView;

@property (nonatomic, strong) CPReleateGameView *releateGameView;



@end


@implementation CPDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    CPDetailTableViewCell *cell = [[CPDetailTableViewCell alloc] init];
    return cell;
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.collectionView = ({
            UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumLineSpacing = 0.0f;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = [UIColor whiteColor];
            [collectionView registerClass:[CPGallaryCollectionVCell class] forCellWithReuseIdentifier:NSStringFromClass([CPGallaryCollectionVCell class])];
            
            collectionView.pagingEnabled = YES;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            collectionView.showsHorizontalScrollIndicator = NO;
            
            collectionView;
        });
        
        self.pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
            pageControl.currentPage = 0;
            pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
            
            pageControl;
        });
        
        self.videoShowImgView = ({
            UIImageView *imgView = [[UIImageView alloc] init];
            
            imgView;
        });
        
        self.newsTableView = ({
            UITableView *tableview = [[UITableView alloc] init];
            tableview.delegate = self;
            tableview.dataSource = self;
            tableview.scrollEnabled = NO;
            
            tableview;
        });
        
        
        self.releateGameView = ({
            CPReleateGameView *gameview = [CPReleateGameView releateGame];
            gameview.backgroundColor = [UIColor blackColor];
            gameview;
        });
        
    }
    return self;


}


#pragma mark 不同部分的cell内容
- (void)setGameCellFrame:(CPGameCellFrame *)gameCellFrame section:(NSInteger)section
{
    _gameCellFrame = gameCellFrame;
    if (section == 0) {
        //游戏截图
        //collectionView的frame
        CGFloat padding = 10;
        self.collectionView.frame = CGRectMake(0, padding, gameCellFrame.gallaryF.size.width, gameCellFrame.gallaryF.size.height - padding * 2 - 10);
        self.collectionView.centerX = self.contentView.centerX;
        [self.contentView addSubview:self.collectionView];
        
        //pageControl
        self.pageControl.centerX = self.contentView.centerX;
        self.pageControl.y = padding + self.collectionView.height + 5;
        [self.contentView addSubview:self.pageControl];
        
    }else if (section == 1) {
        
    }else if (section == 2) {
        //游戏视频
        CGFloat paddingW = 20;
        CGFloat paddingH = 10;
        
        self.videoShowImgView.frame = CGRectMake(paddingW, paddingH, gameCellFrame.vedioF.size.width - 2 * paddingW, gameCellFrame.vedioF.size.height - 2 * paddingH);
        
        CPGameVideo *gameVideo = [CPGameVideo gameVideoWithDict:(NSDictionary *)gameCellFrame.gameResult.video];
        CPGameVideoShow *videoShow = [CPGameVideoShow gameVideoShowWithDict:(NSDictionary *)gameVideo.show];
        self.videoShowImgView.backgroundColor = [UIColor redColor];
        NSURL *imgUrl = [NSURL URLWithString:videoShow.img];
        [self.videoShowImgView sd_setImageWithURL:imgUrl];
        
        [self.contentView addSubview:self.videoShowImgView];
        
    }else if (section == 3) {
        //游戏相关
        self.newsTableView.frame = CGRectMake(0, 0, gameCellFrame.relateNewsF.size.width, gameCellFrame.relateNewsF.size.height);
        [self.contentView addSubview:self.newsTableView];
        
    }else if (section == 4) {
        //用户评论
        
        
    }else if (section == 5) {
        //游戏推荐
        self.releateGameView.frame = CGRectMake(0, 0, self.contentView.width, gameCellFrame.relateGameF.size.height);
        self.releateGameView.gamecellFrame = gameCellFrame;
        [self.contentView addSubview:self.releateGameView];
    }
}

- (void)setSencondShow:(BOOL)sencondShow
{
    _sencondShow = sencondShow;
    mySencondCellShow = sencondShow;
}

#pragma mark 懒加载
- (NSArray *)imagArray
{
    if (_imagArray == nil) {
        _imagArray = self.gameCellFrame.gameResult.gallary;
    }
    return _imagArray;
} 

- (NSArray *)newsArray {
    if (_newsArray == nil) {
        _newsArray = self.gameCellFrame.gameResult.relateNews;
    }
    return _newsArray;
 
}
 
#pragma mark <UICollectionView>的数据源
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.pageControl.numberOfPages = self.imagArray.count;
    return self.imagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath  
{
    CPGallaryCollectionVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CPGallaryCollectionVCell class]) forIndexPath:indexPath];
    cell.gallary = [CPGameGallary gallaryWithDict:self.imagArray[indexPath.row]];
    CPLog(@"%ld===%@",indexPath.row ,cell.gallary.src);
    
    self.pageControl.currentPage = indexPath.row;
    return cell;
}
 
#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.width, self.collectionView.height);
}
 
#pragma mark <UITableView>的数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPNewsTableViewCell *gameCell = [CPNewsTableViewCell newsCellWithTableView:tableView];
    CPGameRelatenews *news = [CPGameRelatenews gameRelatenewsWithDict:self.newsArray[indexPath.row]];
    
    CGFloat height = self.gameCellFrame.relateNewsF.size.height / self.newsArray.count;
    [gameCell setNews:news height:height];

//    gameCell.news = news;
    return gameCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.gameCellFrame.relateNewsF.size.height / self.newsArray.count;
}

@end
