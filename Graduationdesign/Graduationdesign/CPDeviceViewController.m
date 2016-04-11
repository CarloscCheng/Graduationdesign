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

#import "CPLoginViewController.h"
#import "CPAreaIDModel.h"
#import "CPData.h"
#import "CPDataHeader.h"

@interface CPDeviceViewController ()<UITableViewDataSource,CPHeaderViewDelegate,UITableViewDelegate,CPTopMenuDelegate,CPWeatherConnectDelegate,CPNologinHeaderViewDelegate,CPLoginViewControllerDelegate,CLLocationManagerDelegate>

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


@property (nonatomic , strong)CLLocationManager *locationManager;
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

#pragma mark <CPNologinHeaderView>的代理方法
- (void)nologinViewisClickClose:(UIView *)view
{
    CPLog(@"关闭tips");
    _tipsStatus = YES;
    self.myTableView.y = 0;
    self.nologinView.hidden = YES;
}

- (void)nologinViewisClicked:(UIView *)view
{
    CPLog(@"登录操作");
    [self performSegueWithIdentifier:@"device2login" sender:@"device"];
}

#pragma mark tips刷新状态
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

#pragma mark 添加segue进行判断
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"weatherData"]) {
        //跳转到个人资料界面
        
    }else if([segue.identifier isEqualToString:@"device2login"]){
        //跳转到登录界面
        CPLoginViewController *loginvc = segue.destinationViewController;
        loginvc.delegate = self;
    }

}

#warning 这里的做法不够好，需要优化
#pragma mark <CPLoginViewController>的代理
- (void)loginViewControllerisLogined:(CPLoginViewController *)loginvc WithUserInfo:(NSArray *)userinfo AndThirdParty:(BOOL)ThirdParty
{
    //关闭tips
    [self nologinViewisClickClose:self.view];
    
    //自动定位
    [self getLocate];

    //自动刷新(一进入程序就下拉刷新)
    [self.myTableView headerBeginRefreshing];
    
    //存入登录信息
    if (!ThirdParty) {
         [self setLoginInfoWithUserInfo:userinfo];
    }else{
        NSDictionary *thirdPartyDict = [userinfo lastObject];
        
        //如果是第三方登录
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *loginDict = @{@"userImg": @"user_default",
                                    @"userName": thirdPartyDict[@"name"],
                                    @"numDevice": @"10个智能设备",
                                    @"curStatus": @"1",
                                    @"loginPhone": thirdPartyDict[@"name"]};
        
        //存储到userfalut]
        [userDefaults setObject:loginDict forKey:@"lastLogin"];
        [userDefaults synchronize]; 
    }
    
    //设置通知 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CPCenterViewController" object:nil];
}

- (void)setLoginInfoWithUserInfo:(NSArray *)userinfo
{
    NSString *userimg = [NSString string];
    NSString *username = [NSString string];
    NSString *numdevice = @"10个智能设备";
    NSString *curStatus = @"1";
    NSString *loginPhone = [NSString string];
    
    for (NSDictionary *dict in userinfo){
        CPData *data = [CPData dataWithDict:dict];
        if ([data.detail isEqualToString:CPDATA_HEADIMG_DETAIL]) {
            //设置头像数据
            userimg = data.img;
        }else if([data.detail isEqualToString:CPDATA_NAME_DETAIL]){
            username = data.subdetail;
        }else if([data.detail isEqualToString:CPDATA_PHONE_DETAIL]){
            //记录登录的用户手机号
            loginPhone = data.subdetail; 
        }
    }
    
    //获取userdefault单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginDict = @{@"userImg": userimg,
                                @"userName": username,
                                @"numDevice": numdevice,
                                @"curStatus": curStatus,
                                @"loginPhone": loginPhone};
    
    //存储到userfalut]
    [userDefaults setObject:loginDict forKey:@"lastLogin"];
    [userDefaults synchronize];
}

#pragma mark 定位功能
//开始定位
- (void)getLocate
{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [_locationManager requestWhenInUseAuthorization];
        }
        //更新用户位置
        [_locationManager startUpdatingLocation];
        CPLog(@"定位开启了");
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //更新用户位置
    [_locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //CPLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             //把城市名称传递给areaid模型得到areaid
             CPAreaIDModel *areaidmodel = [CPAreaIDModel areaIdWithStr:[city stringByReplacingOccurrencesOfString:@"市" withString:@""]];
             
             //刷新天气
             CPWeatherConnect *wconn = [[CPWeatherConnect alloc] init];
             [wconn refreshWeatherDataWithAreaid:areaidmodel.AREAID];
             
             //刷新我的设备表格数据
            [self.myTableView reloadData];
             CPLog(@"定位完成:%@",city);
             
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0){
             CPLog(@"No results were returned.");
         }else if (error != nil){
             CPLog(@"An error occurred = %@", error);
         }
     }];
}


#pragma mark 刷新的方法
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
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
- (void)headerViewDidTouchView:(CPHeaderView *)headerView
{
    CPLog(@"头部View被点击");
    [self.myTableView reloadData];
}

#pragma mark 选择完城市后刷新一次天气
- (void)headerViewDidChooseCity:(CPHeaderView *)headerView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // 刷新表格
        [self.myTableView reloadData];
    });
}

@end
