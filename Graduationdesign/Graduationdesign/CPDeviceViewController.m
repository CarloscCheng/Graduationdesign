//
//  CPDeviceViewController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//
#import "CPDeviceViewController.h"
#import "CPDeviceGroup.h"
#import "CPHeaderView.h"
#import "CPTotalCell.h"
#import "CPCellFrame.h"
#import "MJRefresh.h"
#import "CPNologinHeaderView.h"
#import "CPCenterViewController.h"
#import "CPTopMenu.h"
#import "CPTopShow.h"
#import "CPWeatherConnect.h"

@interface CPDeviceViewController ()<UITableViewDataSource,CPHeaderViewDelegate,UITableViewDelegate,CPTopMenuDelegate,CPWeatherConnectDelegate>

@property (weak,nonatomic) UITableViewCell *cell;
/**
 *  存放所有cell的frame模型数据
 */
@property (strong,nonatomic) NSArray *cellFrames;

/**
 *  头部view
 */
@property (strong,nonatomic) CPHeaderView *headerview;

@end

@implementation CPDeviceViewController
//@synthesize 自动生成property的同名变量

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    //设置下拉刷新
    [self setupRefresh];

    //隐藏右边的滑动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //滑动速率
    self.tableView.decelerationRate = 0.3;
    
    //设置nagvitionitem的titleview和代理
    CPTopMenu *topMenuView = [CPTopMenu topMenuWithView];
    self.navigationItem.titleView = topMenuView;
    topMenuView.delegate = self;
    
}

//添加一个通知的监听
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToWeatherData) name:@"CPLifedataViewCell" object:nil];
}

//移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CPLifedataViewCell" object:nil];
}

#pragma mark 跳转到天气信息的界面
//跳转到天气信息界面
- (void)jumpToWeatherData
{
    CPLog(@"收到通知");
    [self performSegueWithIdentifier:@"weatherData" sender:nil];
}

#pragma mark 刷新的方法
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"载入中...";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];

        //当刷新成功通知cell刷新天气数据
        CPWeatherConnect *weatherconnect = [[CPWeatherConnect alloc] init];
        [weatherconnect startRefreshWeatherData];
        //设置代理
        weatherconnect.delegate = self;
    });
}

#pragma mark 天气刷新成功的代理方法
#warning 解决了必须第二次刷新了才能更新同步界面的天气数据,
//天气刷新成功则刷新表格
- (void)weatherDidFinshedRefresh:(CPWeatherConnect *)weatherconnect
{
    // 刷新表格
    CPLog(@"开始刷新表格");
    [self.tableView reloadData];
}

#pragma mark 模型懒加载
//懒加载
- (NSArray *)cellFrames
{
    if (_cellFrames == nil) {
        //获得plist的全路径
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MydeviceList.plist" ofType:nil]];
        
        //将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            //创建CPdeviceGroup模型对象
            CPDeviceGroup *group = [CPDeviceGroup groupWithDict:dict];
            
            //创建CPCellFrame模型对象
            CPCellFrame *cellFrame = [[CPCellFrame alloc] init];
            cellFrame.cGroup = group;
            
            //添加模型对象到数组中
            [groupArray addObject:cellFrame];
        }
        _cellFrames = groupArray;
    }
    return _cellFrames;
}




#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CPCellFrame *cellframe = self.cellFrames[section];
    CPDeviceGroup *group = cellframe.cGroup;
    
    return (group.isOpened ? group.info.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCellFrame *cellframe = self.cellFrames[indexPath.section];
    CPDeviceGroup *group = cellframe.cGroup;
    
    //set cell
    CPTotalCell *cell = [CPTotalCell cellWithTableView:tableView andWithGroups:group];
    [cell setcellData:group withIndex:indexPath];
    
    
    return cell;
}

//row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPCellFrame *cellframe = self.cellFrames[indexPath.section];
    NSLog(@"++++++++ row = %d",indexPath.section);
    return cellframe.cellH;
}


/**
 *  返回每一组需要显示的头部标题
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1.创建头部控件
    self.headerview= [CPHeaderView headerViewWithTableView:tableView];
    
    //设置代理
    self.headerview.delegate = self;
    
    // 2.给header设置数据(给header传递模型)
    CPCellFrame *cellframe = self.cellFrames[section];
    self.headerview.group = cellframe.cGroup;
    
    return self.headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidTouchView:(CPHeaderView *)headerView
{
    NSLog(@"头部View被点击");
    [self.tableView reloadData];
}

//选择完城市后刷新一次天气
- (void)headerViewDidChooseCity:(CPHeaderView *)headerView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        CPLog(@"==============&&&&&&&&&&&开始刷新表格");
        [self.tableView reloadData];
    });
}
@end
