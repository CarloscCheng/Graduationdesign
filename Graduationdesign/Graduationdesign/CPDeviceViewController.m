//
//  CPDeviceViewController.m
//  Graduationdesign
//
//  Created by cheng on 16/3/16.
//  Copyright © 2016年 chengpeng. All rights reserved.
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


#import "CPLifedataViewCell.h"

@interface CPDeviceViewController ()<UITableViewDataSource,CPHeaderViewDelegate,UITableViewDelegate,CPTopMenuDelegate,CPWeatherConnectDelegate,CPNologinHeaderViewDelegate>

@property (weak,nonatomic) UITableViewCell *cell;
/**
 *  存放所有cell的frame模型数据
 */
@property (strong,nonatomic) NSArray *cellFrames;

/**
 *  头部view
 */
@property (strong,nonatomic) CPHeaderView *headerview;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/**
 *  头部tipsView
 */
@property (weak,nonatomic) CPNologinHeaderView *nologinView;

/**
 *  是否要显示上方未登录的tips(未登录0-show，登录1-hide)
 */
@property (readonly,nonatomic,getter = isTipsStatus) BOOL tipsStatus;

@end
//@synthesize 自动生成property的同名变量


@implementation CPDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置下拉刷新
    [self setupRefresh];
    
    //设置数据源和代理
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    //隐藏右边的滑动条
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    //滑动速率
    self.myTableView.decelerationRate = 0.3;
    
    //设置nagvitionitem的titleview和代理
    CPTopMenu *topMenuView = [CPTopMenu topMenuWithView];
    self.navigationItem.titleView = topMenuView;
    topMenuView.delegate = self;
    
    //初始化CPNologinHeaderView
    self.nologinView = [CPNologinHeaderView viewWithNologinView];
    self.nologinView.frame = CGRectMake(0, 64, 320, 44);
    self.nologinView.delegate = self;
    [self.view addSubview:self.nologinView];
}

#pragma mark 界面消失和出现
//添加一个通知的监听
- (void)viewWillAppear:(BOOL)animated
{
    CPLog(@"我的设备界面将要出现");
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToWeatherData) name:@"CPLifedataViewCell" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tipsStatusrefresh) name:@"CPCenterViewController" object:nil];
    
    //获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *login = [userDefault objectForKey:@"lastLogin"];
    
    if (!_tipsStatus) {
        if(login)
        {
            //登录不显示tips
            self.myTableView.y = 0;
            self.nologinView.hidden = YES;
        }else{
            //未登录显示tips
            self.myTableView.y = 44;
            self.nologinView.hidden = NO;
        }
    }
}

//移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    CPLog(@"我的设备界面已经消失");
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CPLifedataViewCell" object:nil];
}

#pragma mark nologinHeaderView的代理方法
- (void)nologinViewisClickClose:(UIView *)view
{
    CPLog(@"关闭tips");
    _tipsStatus = YES;
    self.myTableView.y = 0;
    self.nologinView.hidden = YES;
}

- (void)tipsStatusrefresh
{
    CPLog(@"==============&&&&&&&&&&&tipsStatusrefresh");
    _tipsStatus = NO;
    
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CPCenterViewController" object:nil];
    
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
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.tableView headerBeginRefreshing];
    
    self.myTableView.headerPullToRefreshText = @"下拉刷新";
    self.myTableView.headerRefreshingText = @"载入中...";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
        
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
    [self.myTableView reloadData];
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

//    CPLog(@"&&&&&&&&!!!!!!!!!!!!!^^^^^^^^^^^%ld",(long)section);
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
    return cellframe.cellH;
}


/**
 *  返回每一组需要显示的头部标题
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1.创建头部控件
    self.headerview= [CPHeaderView headerViewCreate];
    
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
    CPLog(@"头部View被点击");
    [self.myTableView reloadData];
}

//选择完城市后刷新一次天气
- (void)headerViewDidChooseCity:(CPHeaderView *)headerView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // 刷新表格
        [self.myTableView reloadData];
    });
}


@end
