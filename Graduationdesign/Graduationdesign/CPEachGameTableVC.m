//
//  CPEachGameTableVC.m
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPEachGameTableVC.h"
#import "CPGameTableViewCell.h" 
#import "CPGameInfo.h"
#import "CPEachHeaderView.h"
#import "CPGameDetailTableViewCell.h"
#import "CPStrategyTableViewCell.h"
#import "CPVideoCellTableViewCell.h"

#define FIRSTCELLH 80
#define SECONDCELLH 520

typedef NS_ENUM(NSUInteger, CPChooseType) {
    CPChooseTypeGameDetail = 0, //游戏概要
    CPChooseTypeGameStrategy = 1,   //游戏攻略
    CPChooseTypeGameVideo = 2, //游戏视频
};

@interface CPEachGameTableVC()<CPEachHeaderViewDelegate, CPGameDetailTableViewCellDelegate>
- (IBAction)back:(id)sender;

@property (nonatomic, strong) CPGameResult *gameResult;
@property (nonatomic, strong) CPGameDetail *gameDetail;
//@property (nonatomic, strong) CPGameStrategy *gameStrategy;
@property (nonatomic, strong) CPGameVideo *gameVideo;

@property (nonatomic, strong) CPGameDetailTableViewCell *gameDetailCell;
@property (nonatomic, strong) CPStrategyTableViewCell *gameStrategyCell;
@property (nonatomic, strong) CPVideoCellTableViewCell *videoCell;
/**
 *  控制器是否是返回状态(默认为NO)
 */
@property (nonatomic, readonly, getter=isVcBack) BOOL vcBack;

@property (nonatomic, assign) CPChooseType currentType;


//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;
@end

@implementation CPEachGameTableVC

- (void)viewDidLoad {
    //控制器出现设置返回状态为NO（即表示控制器没有返回）
    _vcBack = NO;
    
    //默认
    self.currentType = CPChooseTypeGameDetail;
}

#pragma mark 加载模型数据
- (void)LoadDataToModel:(NSString *)fileId;
{
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:fileId];
    NSData *gameData = [NSData dataWithContentsOfFile:cachefilename];
    NSDictionary *gameDataDict = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableLeaves error:nil];
    
    CPGameInfo *gameInfo = [CPGameInfo gameInfoWithDict:gameDataDict];
    
    //网路获取的具体有用数据模型
    self.gameResult = [CPGameResult gameResultWithDict:gameInfo.result];
    
    //游戏详情模型
    self.gameDetail = [CPGameDetail gameDetailWithDict:self.gameResult.detail];
//    //游戏攻略模型
//    self.gameStrategy = [CPGameStrategy gameStrategyWithDict:gameResult.strategy];
//    //游戏视频模型
    self.gameVideo = [CPGameVideo gameVideoWithDict:self.gameResult.video];

    CPLog(@"加载数据%@",self.gameDetail.name);
} 
 

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//[[UITableViewCell alloc] init];
     
    if (indexPath.section == 0) {
        CPGameTableViewCell *gameCell = [CPGameTableViewCell gameCellCreate:tableView];
        [self LoadDataToModel:self.fileID];
        gameCell.gameDetail = self.gameDetail;
        cell = gameCell;
    }else if (indexPath.section == 1) {
        if (self.currentType == CPChooseTypeGameDetail) {
            self.gameDetailCell = [CPGameDetailTableViewCell gameDetailCellCreate:tableView];
            
            self.gameDetailCell.gameDetailModel = self.gameDetail;
            self.gameDetailCell.gameResultModel = self.gameResult;
            
            self.gameDetailCell.delegate = self;
            
            cell = self.gameDetailCell;
            CPLog(@"游戏介绍cell");
        }else if (self.currentType == CPChooseTypeGameStrategy){
            self.gameStrategyCell = [CPStrategyTableViewCell gameStrategyCellCreate:tableView];
            self.gameStrategyCell.gameResultModel = self.gameResult;
            cell = self.gameStrategyCell;
            CPLog(@"游戏攻略cell");
        }else if (self.currentType == CPChooseTypeGameVideo){
            self.videoCell =[CPVideoCellTableViewCell videoCellCellCreate:tableView];
            self.videoCell.gameResultModel = self.gameResult;
            cell = self.videoCell;
            CPLog(@"游戏视频cell"); 
        }
    } 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 0) {
        height = FIRSTCELLH;
    }else if (indexPath.section == 1){
        height = SECONDCELLH;
        CPLog(@"=====%f",height);
    }
    return height;
}

#pragma mark 返回每一组需要显示的头部标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    if (section == 1) {
        CPEachHeaderView *eachheaderView = [CPEachHeaderView eachHeaderView];
        eachheaderView.gameResult = self.gameResult;
        eachheaderView.delegate = self;
        
        UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, eachheaderView.height, 320, 1)];
        padding.backgroundColor = [UIColor lightGrayColor];
        padding.alpha = 0.5;
        
        [headerView  addSubview:padding];
        [headerView addSubview:eachheaderView];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 0;
    if (section == 0) {
        headerHeight = 0.01;
    }else if (section == 1)
    {
        headerHeight = 50;
    }
     
    return headerHeight; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01; 
}



#pragma mark tableview的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //没有返回才可以监听滚动事件(过滤事件)
    if (!_vcBack) {
        //section == 2的headerView的Y值
        CGFloat headerY = scrollView.contentOffset.y + FIRSTCELLH;
        
        //headerView终止的Y值
        CGFloat headerendY = FIRSTCELLH - RECTSTATUSNAV; 
        if (headerY < headerendY) {
            //section == 2的cell中的tableView禁止滚动
//            CPLog(@"禁止滚动");
            self.gameDetailCell.scrollEnabled = NO;
        } else {
            //section == 2的cell中的tableView可以滚动
//            CPLog(@"开始滚动");
            self.gameDetailCell.scrollEnabled = YES;
        }
//        CPLog(@"=======滚动%f",headerY);  
    }
}
 
#pragma mark 返回
- (IBAction)back:(id)sender {
    CPLog(@"返回");
    _vcBack = YES;
    self.gameDetailCell.scrollEnabled = !_vcBack; 
    [self.navigationController popViewControllerAnimated:YES];  
}


- (void)eachHeaderViewChooseGameDetail:(CPEachHeaderView *)view
{
    CPLog(@"游戏介绍");
    self.currentType = CPChooseTypeGameDetail;
    [self.tableView reloadData];
}

- (void)eachHeaderViewChooseGameVideo:(CPEachHeaderView *)view
{
    CPLog(@"游戏视频");
    self.currentType = CPChooseTypeGameVideo;
    [self.tableView reloadData];
}

- (void)eachHeaderViewChooseGameStrategy:(CPEachHeaderView *)view
{
    CPLog(@"游戏攻略");
    self.currentType = CPChooseTypeGameStrategy;
    [self.tableView reloadData];
}


#pragma mark CPGameDetailTableViewCellDelegate
- (void)gameDetailTableViewCellClickPalyVideo:(CPGameDetailTableViewCell *)cell
{
    CPLog(@"播放视频");
    self.gameDetailCell.scrollEnabled = NO;
    
    //保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    self.moviePlayerViewController=nil;
    
    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}

#pragma mark 懒加载
- (MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getNetworkUrl];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl {
    NSString *urlStr = self.gameVideo.show.url;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            CPLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            CPLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            CPLog(@"停止播放.");
            break;
        default:
            CPLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    CPLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
 