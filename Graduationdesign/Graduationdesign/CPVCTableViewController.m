//
//  CPVCTableViewController.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPVCTableViewController.h"
#import "CPVideoTableViewCell.h"
#import "CPGameTableViewCell.h"
#import "CPGameModel.h"
#import "CPVCModel.h"
#import "CPCellHeaderView.h"

#define SECTIONS 2

static NSString *gameCellID = @"gameCell";

@interface CPVCTableViewController ()
- (IBAction)back:(id)sender;

@property (nonatomic, strong) NSArray *gameListArray;

@property (nonatomic, strong) CPVCTopModel *vcTopModel;

@property (nonatomic, weak) UITableViewCell *cell;
@end

@implementation CPVCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //下拉刷新
    [self setupRefresh];
    CPLog(@"viewDidLoad");
}
#pragma mark- 刷新的方法
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"载入中...";
}

- (void)headerRereshing
{
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
        
    });
}


#pragma mark 懒加载
- (NSArray *)gameListArray
{
    if (!_gameListArray) {
        [self LoadVcModel:self.clickID];
        _gameListArray = self.vcTopModel.list;
    }
    return _gameListArray;
} 


#pragma mark 加载模型数据
- (void)LoadVcModel:(NSString *)fileId;
{
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:fileId];
    
    NSData *gameData = [NSData dataWithContentsOfFile:cachefilename];
    NSDictionary *gameDataDict = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableLeaves error:nil];
    
    CPVCGameModel *vcgameModel = [CPVCGameModel vcGameModelWithDict:gameDataDict];
    CPVCTopModel *vcTopModel = [CPVCTopModel vcTopModelWithDict:vcgameModel.result];
    self.vcTopModel = vcTopModel;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if(section == 0)
    {
        rows = 1;
    }else if (section == 1){
        rows = self.gameListArray.count;
        CPLog(@"====count%ld",(long)rows);
    }
    return rows; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CPVideoTableViewCell *videoCell = [CPVideoTableViewCell videoCellCreate:tableView];
        CPVCTopModel *topmodel = self.vcTopModel;
        videoCell.vcTopModel = topmodel;
        
        self.cell = videoCell;
    }else if (indexPath.section == 1){
        CPGameTableViewCell *gameCell = [CPGameTableViewCell gameCellCreate:tableView];
        CPVCGameList *gameList = self.gameListArray[indexPath.row];
        CPLog(@"cell循环利用%p",gameCell);
        gameCell.gameList = gameList;
        self.cell = gameCell;
    }
    return self.cell;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowheight;
    if (indexPath.section == 0) {
        rowheight = 170;
    }else if (indexPath.section == 1){
        rowheight = 80;
    }
    return rowheight;
}

/**
 *  返回每一组需要显示的头部标题
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 1) {
        CPCellHeaderView *cellheaderView = [CPCellHeaderView cellHeaderViewCreate];
        cellheaderView.vcTopModel = self.vcTopModel;
        headerView = cellheaderView;
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


#pragma mark 返回控制器
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
