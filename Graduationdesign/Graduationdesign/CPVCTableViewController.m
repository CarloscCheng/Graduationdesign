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

@interface CPVCTableViewController ()
- (IBAction)back:(id)sender;

@property (nonatomic, strong) NSArray *gameListArray;
@end

@implementation CPVCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:self.gallarymodel.title];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //下拉刷新
    [self setupRefresh];
    CPLog(@"viewDidLoad");
    
    
#pragma mark 页面需要进两次才能刷新数据
//    [self setVCTableViewData:self.gallarymodel];
}

- (void)setVCTableViewData:(CPGallaryModel *)gallarymodel
{
    //获取缓存目录 
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *vccachefilename = [cacheDirectory stringByAppendingPathComponent:vcGameCacheName];
    
    
    //拼接请求网址
    NSString *host = @"http://cdn.4399sj.com";
    
    NSRange range = [gallarymodel.url rangeOfString:@"?"];
    
    NSString *path = [NSString stringWithFormat:@"/app/iphone/v2.1/special-detail.html?%@&start=1&count=20",[gallarymodel.url substringFromIndex:range.location + 1]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"GET地址%@",urlStr);
    
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
        CPVCTopModel *vctopmodel = [CPVCTopModel vcModel];
        _gameListArray = vctopmodel.list;
    }
    return _gameListArray;
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        CPVideoTableViewCell *videoCell = [CPVideoTableViewCell videoCellCreate:tableView];
        CPVCTopModel *topmodel = [CPVCTopModel vcModel];
        videoCell.vcTopModel = topmodel;
        
        cell = videoCell;
    }else if (indexPath.section == 1){
        CPGameTableViewCell *gameCell = [CPGameTableViewCell gameCellCreate:tableView];
        
        CPVCGameList *gameList = self.gameListArray[indexPath.row];
        gameCell.gameList = gameList;
        cell = gameCell;
    }
    return cell;
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
        cellheaderView.vcTopModel = [CPVCTopModel vcModel];
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
