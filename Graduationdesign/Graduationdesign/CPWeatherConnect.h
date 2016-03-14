//
//  CPWeatherConnect.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-1.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//
//  天气数据的网络连接借口,选用api为https://api.heweather.com/x3/weather?cityid=&key

#import <Foundation/Foundation.h>
@class CPWeatherConnect;
@protocol CPWeatherConnectDelegate <NSObject>

@optional
- (void)weatherDidFinshedRefresh:(CPWeatherConnect *)weatherconnect;

@end

@interface CPWeatherConnect : NSObject


/**
 *  下拉刷新天气
 */
- (void)startRefreshWeatherData;

/**
 *  根据城市ID查询天气
 *
 *  @param areaid 城市id
 */
- (void)refreshWeatherDataWithAreaid:(NSString *)areaid;


@property (strong,nonatomic) void (^weatherDataBlock)(NSDictionary *dict);

//天气刷新成功，通知刷新表格
@property (weak,nonatomic) id<CPWeatherConnectDelegate> delegate;
@end
