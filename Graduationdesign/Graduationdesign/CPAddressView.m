//
//  CPAddressView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPAddressView.h"
#import "CPAdressModel.h"
#import "CPAdressCell.h"
#import "CPCitiesModel.h"
#import "CPWeatherConnect.h"
#import "CPAreaIDModel.h"

#define ROWHEIGHT 43.0;

@interface CPAddressView()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (strong,nonatomic) NSArray *palceArray;

/**
 *  当前为选择省份还是城市的页面，进去为0即省份选择
 */
@property (readonly,nonatomic,getter = isProSelected) BOOL proSelected;
/**
 *  当前的cell的row数
 */
@property (readonly,nonatomic) NSInteger curCount;
/**
 *  选择城市的model
 */
@property (strong,nonatomic) CPAdressModel *adressModel;
@property (strong,nonatomic) CPCitiesModel *cityModel;
/**
 *  当前选择省份的view
 */
@property (weak,nonatomic) UITableView *proviceView;
/**
 *  选择城市的view
 */
@property (weak,nonatomic) UITableView *cityView;
/**
 *  蒙板
 */
@property (weak,nonatomic) UIButton *button;

@property (nonatomic , strong)CLLocationManager *locationManager;

/**
 *  定位城市
 */
@property (copy, nonatomic) NSString *locationCity;
@end

@implementation CPAddressView

- (instancetype)init
{
    if (self = [super init]) {
        //蒙板
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor lightGrayColor];
        button.alpha = 0.5;
        self.button = button;
        [self addSubview:button];
        [self sendSubviewToBack:button];
        [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //省份选择器view
        UITableView *proviceView = [[UITableView alloc] init];
        //滚动速度
        proviceView.decelerationRate = 0.3;
        proviceView.delegate = self;
        proviceView.dataSource = self;
        [self addSubview:proviceView];
        self.proviceView = proviceView;
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.frame = self.window.frame;
    self.button.frame = self.window.frame;
    
    CGFloat proviceViewH = 300;
    CGFloat proviceViewY = self.window.size.height - proviceViewH;
    CGFloat proviceViewW = self.window.size.width;
    self.proviceView.frame = CGRectMake(0,proviceViewY,proviceViewW,proviceViewH);
}

- (void)cityAfterChooseProvice:(CGRect)rect
{
    //城市选择器view
    UITableView *cityView = [[UITableView alloc] init];
    //滚动速度
    cityView.decelerationRate = 0.3;
    cityView.delegate = self;
    cityView.dataSource = self;
    
    self.cityView = cityView;
    self.cityView.frame = rect;
    [self addSubview:self.cityView];
}


- (NSArray *)palceArray
{
    if (_palceArray == nil) {
        //获得plist的全路径
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Address.plist" ofType:nil]];
        
        //将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            //创建CPdeviceGroup模型对象
            
            CPAdressModel *group = [CPAdressModel groupWithDict:dict];
            //添加模型对象到数组中
            [groupArray addObject:group];
        }
        _palceArray = groupArray;
    }
    
    return _palceArray;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_proSelected) {
        _curCount = self.palceArray.count;
    }else{
        _curCount = self.adressModel.Cities.count;
    }
    return _curCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPAdressCell *cell = [CPAdressCell cellWithTableView:tableView];
    
    if (!_proSelected) {
        cell.provicemodel  = self.palceArray[indexPath.row];
    }else{
        cell.citiesmodel = self.adressModel.Cities[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_proSelected) {
        if (indexPath.row == 0) {
            CPLog(@"定位功能");
            [self getLocate];
        }else{
            //获取具体城市信息模型
            self.adressModel = self.palceArray[indexPath.row];
     
            //城市cell个数
            CGFloat cellCount = self.adressModel.Cities.count;
            CGFloat allcellH = cellCount * ROWHEIGHT;
            CGFloat cityviewH;
            CGFloat cityviewY;
            CGFloat cityviewW = self.window.frame.size.width;
            if (allcellH > self.proviceView.frame.size.height){
                //大于则为标准高度
                cityviewH = 300;
                cityviewY = self.window.size.height - cityviewH;

            }else{
                //小于则为cell高度
                cityviewH = allcellH;
                cityviewY = self.window.size.height - allcellH;
            }
            
            CGRect rect = CGRectMake(0, cityviewY, cityviewW, cityviewH);
            
            //增加动画
            [UIView animateWithDuration:1 animations:^{
                //移除省份选择view
                [self.proviceView removeFromSuperview];
            } completion:^(BOOL finished) {
                //弹出城市选择框
                [self cityAfterChooseProvice:rect];
            }];
            //当前跳转到城市选择
            _proSelected = YES;
        }
        [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.5];
        
    }else{
        //城市模型
        self.cityModel = self.adressModel.Cities[indexPath.row];

        //传输数据
        //api的问题导致不能输入**市的方式查询天气，要去掉市
        NSString *cityStr = [self.cityModel.Areaname stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        //把城市名称传递给areaid模型得到areaid
        CPAreaIDModel *areaidmodel = [CPAreaIDModel areaIdWithStr:cityStr]; 
        
        //刷新天气
        CPWeatherConnect *wconn = [[CPWeatherConnect alloc] init];
        [wconn refreshWeatherDataWithAreaid:areaidmodel.AREAID];
        
        
        //刷新我的设备表格数据
        if ([self.delegate respondsToSelector:@selector(addressViewCityNameIsChoosed:)]) {
            [self.delegate addressViewCityNameIsChoosed:self.adressModel];
        }
        
        //跳转等其他操作
        [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.5];
        
        //关闭位置选择器材
        [self removeFromSuperview];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT;
}

//去除选定时一直高亮的效果
- (void)delectCell:(id)sender
{
    [self.proviceView deselectRowAtIndexPath:[self.proviceView indexPathForSelectedRow] animated:YES];
    [self.cityView deselectRowAtIndexPath:[self.cityView indexPathForSelectedRow] animated:YES];
}


#pragma mark 定位功能
//开始定位
- (void)getLocate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        [MBProgressHUD showMessage:nil];
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
        
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请确认是否开启定位功能" preferredStyle:UIAlertControllerStyleAlert];
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
             
             [MBProgressHUD hideHUD];
             self.locationCity = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
             
             //把城市名称传递给areaid模型得到areaid
             CPAreaIDModel *areaidmodel = [CPAreaIDModel areaIdWithStr:self.locationCity];
             CPLog(@"定位城市为%@",self.locationCity);
             
             //刷新天气
             CPWeatherConnect *wconn = [[CPWeatherConnect alloc] init];
             [wconn refreshWeatherDataWithAreaid:areaidmodel.AREAID];
             
             //刷新我的设备表格数据
             if ([self.delegate respondsToSelector:@selector(addressViewCityNameIsChoosed:)]) {
                 [self.delegate addressViewCityNameIsChoosed:self.adressModel];
             }
             
             //跳转等其他操作
             [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.5];

             //关闭位置选择器材
             [self removeFromSuperview];
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


- (void)dealloc
{
    CPLog(@"dealloc");
//    [super dealloc];
}

- (void)buttonClicked
{
    CPLog(@"button clicked");
    [self removeFromSuperview];
}

@end
