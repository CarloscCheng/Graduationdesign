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

#define FIRSTCELLH 80
#define SECONDCELLH 520

@interface CPEachGameTableVC()
- (IBAction)back:(id)sender;

@property (nonatomic, strong) CPGameResult *gameResult;
@property (nonatomic, strong) CPGameDetail *gameDetail;
//@property (nonatomic, strong) CPGameStrategy *gameStrategy;
//@property (nonatomic, strong) CPGameVideo *gameVideo;

@property (nonatomic, weak) CPGameDetailTableViewCell *gameDetailCell;
@end

@implementation CPEachGameTableVC


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
//    self.gameVideo = [CPGameVideo gameVideoWithDict:gameResult.video];
//    
//    self.headerDataArray = @[self.gameDetail,
//                             self.gameStrategy,
//                             self.gameVideo];
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        CPGameTableViewCell *gameCell = [CPGameTableViewCell gameCellCreate:tableView];
        [self LoadDataToModel:self.fileID];
        gameCell.gameDetail = self.gameDetail;
        cell = gameCell;
    }else if (indexPath.section == 1) {
        self.gameDetailCell = [CPGameDetailTableViewCell gameDetailCellCreate:tableView];
        self.gameDetailCell.gameDetailModel = self.gameDetail;
        cell = self.gameDetailCell;
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
        headerHeight = 30;
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
    //section == 2的headerView的Y值
    CGFloat headerY = scrollView.contentOffset.y + FIRSTCELLH;
    
    //headerView终止的Y值
    CGFloat headerendY = FIRSTCELLH - RECTSTATUSNAV;
    if (headerY < headerendY) {
        //section == 2的cell中的tableView禁止滚动
        CPLog(@"禁止滚动");
        self.gameDetailCell.scrollEnabled = NO;
    } else {
        //section == 2的cell中的tableView可以滚动
        CPLog(@"开始滚动");
        self.gameDetailCell.scrollEnabled = YES;
    }
}

#pragma mark 返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
