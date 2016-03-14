//
//  CPWeatherConnect.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-1.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#define MYKEY @"4bee9c367a5e40d9b46f22652d7b2996"

#import "CPWeatherConnect.h"

@interface CPWeatherConnect()<NSURLConnectionDataDelegate>

@property (strong,nonatomic) NSMutableData *weatherData;
@property (strong,nonatomic) NSMutableDictionary *wDict;

@end

@implementation CPWeatherConnect
#warning 存在一个bug程序卸载后第一次运行选择城市不会马上刷新

#warning 修复了输入部分城市拼音搜索不到天气的bug，采用cityid的方式查询
- (void)refreshWeatherDataWithAreaid:(NSString *)areaid
{
    CPLog(@"开始刷新天气数据cityid = %@",areaid);
    //请求天气数据url
    //添加CN格式
    NSString *newcityid = [NSString stringWithFormat:@"CN%@",areaid];

    NSString *httpUrl = @"https://api.heweather.com/x3/weather";
    NSString *httpArg = [NSString stringWithFormat:@"cityid=%@&key=%@",newcityid,MYKEY];

    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];

    NSURL *url = [NSURL URLWithString: urlStr];
    
    // 默认就是GET请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
//    [request addValue: @"3b436b23f7129c98d56c4da3f9bccad5" forHTTPHeaderField: @"apikey"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];

}

//下拉刷新
- (void)startRefreshWeatherData
{
    __block CPWeatherConnect *wconn = self;
    [self setWeatherDataBlock:^(NSDictionary *dict) {
//        NSString *oldid = dict[@"cityid"];
        NSString *cityid = [dict[@"cityid"] stringByReplacingOccurrencesOfString:@"CN" withString:@""];
        [wconn refreshWeatherDataWithAreaid:cityid];
        CPLog(@"refresh cityid=%@",dict[@"cityid"]);
    }];
}

#pragma mark - NSURLConnectionDataDelegate 代理方法
/**
 *  当接受到服务器的响应(连通了服务器)就会调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"接收到服务器的响应");
    self.weatherData = [NSMutableData data];

}

/**
 *  当接受到服务器的数据就会调用(可能会被调用多次, 每次调用只会传递部分数据)
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"开始接收到服务器数据");
    [self.weatherData appendData:data];
}

/**
 *  当服务器的数据接受完毕后就会调用
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"数据接受完毕");
    //服务器段json封装的数据解析成oc数据
    if (self.weatherData) {
        NSError *error = [[NSError alloc] init];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.weatherData options:NSJSONReadingAllowFragments error:&error];
        //代理
        if ([self.delegate respondsToSelector:@selector(weatherDidFinshedRefresh:)]) {
            [self.delegate weatherDidFinshedRefresh:self];
        }
//        CPLog(@"dict = %@",dict);
        //写入本地缓存
        [dict dictToPlistWithPlistName:@"weatherData.plist"];
        
    }
}

- (void)setWeatherDataBlock:(void (^)(NSDictionary *dict))weatherDataBlock
{
    //读取文件
    NSDictionary *allDict = [NSDictionary dictFromPlistWithPlistName:@"weatherData.plist"];
    
    //装换数据
    [self getWeatherData:allDict];
    
    //存储到block
    weatherDataBlock(self.wDict);
}

#pragma mark 解析并提取需要的数据
- (void)getWeatherData:(NSDictionary *)weatherDict
{
    self.wDict = [NSMutableDictionary dictionary];
    NSMutableArray *arr = weatherDict[@"HeWeather data service 3.0"];
    NSDictionary *dict = [arr firstObject];
    
    //城市
    NSDictionary *basic = dict[@"basic"];
    NSString *city = basic[@"city"];
    if (city == nil) {
        city = @"-";
    }
    
    NSString *cityid = basic[@"id"];
    [self.wDict setValue:city forKey:@"city"];
    [self.wDict setValue:cityid forKeyPath:@"cityid"];
    
    //实况天气dict
    NSDictionary *nowdict = dict[@"now"];
    //天气状况dict
    NSDictionary *condict = nowdict[@"cond"];
    
    //风力信息
    NSDictionary *winddict = nowdict[@"wind"];
    //风力信息
    NSString *dir = winddict[@"dir"];
    [self.wDict setValue:dir forKey:@"dir"];
    //风力级数
    NSString *sc = winddict[@"sc"];
    [self.wDict setValue:sc forKey:@"sc"];

    
    //天气状况描述[@"txt"]eg晴
    NSString *condstr = condict[@"txt"];
    if (condstr == nil) {
        condstr = @"-";
    }
    [self.wDict setValue:condstr forKey:@"condstr"];
    
    //空气质量，仅限国内部分城市，国际城市无此字段
    NSDictionary *aqidict = dict[@"aqi"];
    NSDictionary *citydict = aqidict[@"city"];
    
    //空气质量类别
    NSString *qlty = citydict[@"qlty"];
    if (qlty == nil) {
        qlty = @"-";
    }
    [self.wDict setValue:qlty forKey:@"qlty"];
    
    //PM10 1小时平均值(ug/m³)
    NSString *pm10 = citydict[@"pm10"];
    if (pm10 == nil) {
        pm10 = @"-";
    }
    [self.wDict setValue:pm10 forKey:@"pm10"];
    
    //PM2.5 1小时平均值(ug/m³)
    NSString *pm25 = citydict[@"pm25"];
    if (pm25 == nil) {
        pm25 = @"-";
    }
    [self.wDict setValue:pm25 forKey:@"pm25"];

    //7天天气预报
    NSArray *dailyArr = dict[@"daily_forecast"];
    //当天天气
    NSDictionary *dailyDict = [dailyArr firstObject];
    //温度
    NSDictionary *tmpDict = dailyDict[@"tmp"];
    
    //最高温度
    NSString *max = tmpDict[@"max"];
    if (max == nil) {
        max = @"-";
    }
    [self.wDict setValue:max forKey:@"max"];
    
    //最低温度
    NSString *min = tmpDict[@"min"];
    if (min == nil) {
        min = @"-";
    }
    [self.wDict setValue:min forKey:@"min"];
    
    //天气预报
    NSArray *dailyforecastArr = dict[@"daily_forecast"];
    //第一天天气dict
    NSDictionary *fDict = dailyforecastArr[1];
    //天气详情
    NSDictionary *fCond = fDict[@"cond"];
    //白天
    NSString *ftxt_d = fCond[@"txt_d"];
    //晚上
    NSString *ftxt_n = fCond[@"txt_n"];
    [self.wDict setValue:ftxt_d forKey:@"ftxt_d"];
    [self.wDict setValue:ftxt_n forKey:@"ftxt_n"];
    
    //温度详细情
    NSDictionary *fTmp = fDict[@"tmp"];
    NSString *fmax = fTmp[@"max"];
    NSString *fmin = fTmp[@"min"];
    [self.wDict setValue:fmax forKey:@"fmax"];
    [self.wDict setValue:fmin forKey:@"fmin"];
    
    //日期
    NSString *fdate = fDict[@"date"];
    [self.wDict setValue:fdate forKey:@"fdate"];
    
    
    
    //第二天
    NSDictionary *sDict = dailyforecastArr[2];
    //天气详情
    NSDictionary *sCond = sDict[@"cond"];
    //白天
    NSString *stxt_d = sCond[@"txt_d"];
    //晚上
    NSString *stxt_n = sCond[@"txt_n"];
    [self.wDict setValue:stxt_d forKey:@"stxt_d"];
    [self.wDict setValue:stxt_n forKey:@"stxt_n"];
    
    //温度详细情
    NSDictionary *sTmp = sDict[@"tmp"];
    NSString *smax = sTmp[@"max"];
    NSString *smin = sTmp[@"min"];
    [self.wDict setValue:smax forKey:@"smax"];
    [self.wDict setValue:smin forKey:@"smin"];
    
    //日期
    NSString *sdate = sDict[@"date"];
    [self.wDict setValue:sdate forKey:@"sdate"];
    
    
    //第三天
    NSDictionary *tDict = dailyforecastArr[3];
    //天气详情
    NSDictionary *tCond = tDict[@"cond"];
    //白天
    NSString *ttxt_d = tCond[@"txt_d"];
    //晚上
    NSString *ttxt_n = tCond[@"txt_n"];
    [self.wDict setValue:ttxt_d forKey:@"ttxt_d"];
    [self.wDict setValue:ttxt_n forKey:@"ttxt_n"];
    
    //温度详细情
    NSDictionary *tTmp = tDict[@"tmp"];
    NSString *tmax = tTmp[@"max"];
    NSString *tmin = tTmp[@"min"];
    [self.wDict setValue:tmax forKey:@"tmax"];
    [self.wDict setValue:tmin forKey:@"tmin"];
    
    //日期
    NSString *tdate = tDict[@"date"];
    [self.wDict setValue:tdate forKey:@"tdate"];
    
    
    //生活指数
    NSDictionary *sugDict = dict[@"suggestion"];
    //穿衣指数
    NSDictionary *drsgDict = sugDict[@"drsg"];
    NSString *drsg = drsgDict[@"brf"];
    [self.wDict setValue:drsg forKey:@"drsg"];
    
    //紫外线指数
    NSDictionary *uvDict = sugDict[@"uv"];
    NSString *uv = uvDict[@"brf"];
    [self.wDict setValue:uv forKey:@"uv"];
    
    //洗车指数
    NSDictionary *cwDict = sugDict[@"cw"];
    NSString *cw = cwDict[@"brf"];
    [self.wDict setValue:cw forKey:@"cw"];
    
    //旅游指数
    NSDictionary *travDict = sugDict[@"trav"];
    NSString *trav = travDict[@"brf"];
    [self.wDict setValue:trav forKey:@"trav"];
    
    //感冒指数
    NSDictionary *fluDict = sugDict[@"flu"];
    NSString *flu = fluDict[@"brf"];
    [self.wDict setValue:flu forKey:@"flu"];
    
    //运动指数
    NSDictionary *sportDict = sugDict[@"sport"];
    NSString *sport = sportDict[@"brf"];
    [self.wDict setValue:sport forKey:@"sport"];
    
    //人体舒适度
    NSDictionary *comfDict = sugDict[@"comf"];
    NSString *comf = comfDict[@"brf"];
    [self.wDict setValue:comf forKey:@"comf"];
    
    

    
    
    
}

/**
 *  请求错误(失败)的时候调用(请求超时\断网\没有网, 一般指客户端错误)
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"连接失败%@",error);
}


@end
