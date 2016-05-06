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
#import "CPEachGameTableVC.h"

#define SECTIONS 2

static NSString *gameCellID = @"gameCell";

@interface CPVCTableViewController ()
- (IBAction)back:(id)sender;

@property (nonatomic, strong) NSArray *gameListArray;

@property (nonatomic, strong) CPVCTopModel *vcTopModel;

@property (nonatomic, strong) UITableViewCell *cell;
 

@property (nonatomic, strong) CPVCGameList *gamelist;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPLog(@"===%ld,%ld",indexPath.row, indexPath.section);
    if (indexPath.section == 1) {
        CPVCGameList *gameList = self.gameListArray[indexPath.row];
        self.gamelist = gameList;
        
        NSString *host = @"http://cdn.4399sj.com";
        NSString *path = [[NSString alloc] init];
        NSString *fileID = [[NSString alloc] init];
        
        path = [NSString stringWithFormat:@"/app/iphone/v2.2/game.html?id=%ld",(long)gameList.id];
        fileID = [NSString stringWithFormat:@"%@-%ld",vcGameCacheName, (long)gameList.id];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",host, path];
        CPLog(@"请求的数据地址%@",urlStr);
        
        //获取缓存目录
        NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *vccachefilename = [cacheDirectory stringByAppendingPathComponent:fileID];
        
        //连接服务器get数据
        AFHTTPSessionManager *httpMrg = [AFHTTPSessionManager manager];
        httpMrg.responseSerializer = [AFHTTPResponseSerializer serializer];
        [httpMrg GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (responseObject) {
                //写入文件
                NSError *error;
                if ([responseObject writeToFile:vccachefilename options:NSDataWritingAtomic error:&error]) {
                    CPLog(@"写入缓存成功");
                    [self performSegueWithIdentifier:@"vcTableView2eachGame" sender:fileID];
                    
                }else{
                    CPLog(@"写入缓存失败");
                }
            }else{
                CPLog(@"获取数据为空");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            CPLog(@"失败%@",error);
        }];

    
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"vcTableView2eachGame"]) {
        CPEachGameTableVC *eachgameVC = segue.destinationViewController;
        eachgameVC.fileID = sender;
        UIView *titleView = [[UIView alloc] init];
        //新游推荐
        titleView = ({
            CGSize titleSize = [NSString sizeWithText:self.gamelist.name font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            label.font = MYITTMFONTSIZE;
            label.text = self.gamelist.name;
            [view addSubview:label];
            view;
        });
        
        [eachgameVC.navigationItem setTitleView:titleView];
    }
}


#pragma mark 返回控制器
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
