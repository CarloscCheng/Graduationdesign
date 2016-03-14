//
//  CPWDataMiddleView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-7.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPWDataMiddleView.h"
#import "CPWeatherConnect.h"
#include "CPAreaIDModel.h"


#define TMPSIZE [NSString sizeWithText:@"温度℃" font:[UIFont systemFontOfSize:9.0] maxSize:CPMAXSIZE]

@interface CPWDataMiddleView()
//背景的效果图（由一个r：200圆，4个r：150圆，4个旋转了pi_4的r：150的圆组成）
/**
 *  旋转前的view容器
 */
@property (weak,nonatomic) UIView *beforeTransView;
/**
 *  用于作r：200的圆
 */
@property (weak,nonatomic) UIView *beforeCircleView_200;
@property (weak,nonatomic) UIView *beforeCircleView_150_0;
@property (weak,nonatomic) UIView *beforeCircleView_150_1;
@property (weak,nonatomic) UIView *beforeCircleView_150_2;
@property (weak,nonatomic) UIView *beforeCircleView_150_3;

@property (weak,nonatomic) UIColor *beforeViewcolor_200;
@property (weak,nonatomic) UIColor *beforeViewcolor_150;

/**
 *  用于作r：150的圆(旋转后)的背景色
 */
@property (weak,nonatomic) UIColor *afterViewcolor_150;

/**
 *  地点和定位图标的view容器
 */
@property (weak,nonatomic) UIView *locationView;

/**
 *  省份城市
 */
@property (weak,nonatomic) UILabel *locationLabel;
@property (copy,nonatomic) NSString *locationLabelstr;

/**
 *  左边的view(显示温度和详情的label)
 */
@property (weak,nonatomic) UIView *leftView;
/**
 *  左边的温度标题
 */
@property (weak,nonatomic) UILabel *leftTitle;
/**
 *  左边的温度详情
 */
@property (weak,nonatomic) UILabel *leftDetail;
@property (copy,nonatomic) NSString *leftDetailstr;

/**
 *  右边的view(显示pm2.0和空气质量和详情的label)
 */
@property (weak,nonatomic) UIView *rightView;
/**
 *  右边的空气质量标题
 */
@property (weak,nonatomic) UILabel *rightTitle;
@property (copy,nonatomic) NSString *rightTitlestr;
/**
 *  右边的空气质量详情
 */
@property (weak,nonatomic) UILabel *rightDetail;
@property (copy,nonatomic) NSString *rightDetailstr;
@property (copy,nonatomic) NSString *rightDetaillongstr;

/**
 *  底部的view(存放天气，天气图标，风力等label)
 */
@property (weak,nonatomic) UIView *bottmoView;
/**
 *  天气信息
 */
@property (weak,nonatomic) UILabel *condDetail;
@property (copy,nonatomic) NSString *condDetailstr;

/**
 *  风力信息
 */
@property (weak,nonatomic) UILabel *windDetail;
@property (copy,nonatomic) NSString *windDetailstr;

@end
@implementation CPWDataMiddleView

- (instancetype)init
{
    if (self = [super init]) {
        //获取数据
        [[[CPWeatherConnect alloc] init]setWeatherDataBlock:^(NSDictionary *data) {
            int pm10_value = [data[@"pm10"] intValue];
            [self setBackgroundColorWithPmValue:pm10_value];
            
            //获取省份城市名称
            NSString *cityname = data[@"city"];
            CPAreaIDModel *areaidmodel = [CPAreaIDModel areaIdWithStr:cityname];
            NSString *provicename = areaidmodel.PROVCN;
            if ([provicename isEqualToString:cityname]) {
                self.locationLabelstr = cityname;
            }else{
                self.locationLabelstr = [NSString stringWithFormat:@"%@·%@",provicename,cityname];
            }
            
            //获取温度信息
            NSString *tmpmax = data[@"max"];
            NSString *tmpmin = data[@"min"];
            self.leftDetailstr = [NSString stringWithFormat:@"%@/%@",tmpmax,tmpmin];
            
            //获取pm信息
            NSString *pm25 = data[@"pm25"];
            self.rightTitlestr = [NSString stringWithFormat:@"PM2.5:%@",pm25];
            
            NSString *qlty = data[@"qlty"];
            self.rightDetailstr = qlty;
            self.rightDetaillongstr = [NSString stringWithFormat:@"空气%@",qlty];
            
            //获取天气信息和风力信息
            NSString *cond = data[@"condstr"];
            self.condDetailstr = cond;
            
            NSString *winddir = data[@"dir"];
            //风力
            NSString *windspd = data[@"sc"];
            self.windDetailstr = [NSString stringWithFormat:@"%@%@",winddir,windspd];
            
        }];
        
        //旋转前的背景容器view及子view初始化
        UIView *beforeTransView = [[UIView alloc] init];
        self.beforeTransView = beforeTransView;
        [self addSubview:beforeTransView];
        
        UIView *beforeCircleView_150_0 = [[UIView alloc] init];
        self.beforeCircleView_150_0 = beforeCircleView_150_0;
        [beforeTransView addSubview:beforeCircleView_150_0];
        
        UIView *beforeCircleView_150_1 = [[UIView alloc] init];
        self.beforeCircleView_150_1 = beforeCircleView_150_1;
        [beforeTransView addSubview:beforeCircleView_150_1];
        
        UIView *beforeCircleView_150_2 = [[UIView alloc] init];
        self.beforeCircleView_150_2 = beforeCircleView_150_2;
        [beforeTransView addSubview:beforeCircleView_150_2];
        
        UIView *beforeCircleView_150_3 = [[UIView alloc] init];
        self.beforeCircleView_150_3 = beforeCircleView_150_3;
        [beforeTransView addSubview:beforeCircleView_150_3];
        
        UIView *beforeCircleView_200 = [[UIView alloc] init];
        self.beforeCircleView_200 = beforeCircleView_200;
        [beforeTransView addSubview:beforeCircleView_200];
        
        
#warning 一个重大的bug，把旋转的view放在这里初始化，旋转之后会出现意想不到的错误
        //旋转后的背景容器view及子view初始化
        
        
        //地点和定位图标的view容器
        UIView *locationView = [[UIView alloc] init];
        self.locationView = locationView;
//        self.locationView.backgroundColor = [UIColor redColor];
        [self.beforeTransView addSubview:self.locationView];
        
        UILabel *locationLabel = [[UILabel alloc] init];
        locationLabel.font = [UIFont systemFontOfSize:9.0];
        self.locationLabel = locationLabel;
        self.locationLabel.textColor = [UIColor whiteColor];
        [locationView addSubview:locationLabel];
        
        
        //左边的view
        UIView *leftView = [[UIView alloc] init];
        self.leftView = leftView;
        [self.beforeTransView addSubview:leftView];
        
        UILabel *leftTitle = [[UILabel alloc] init];
        self.leftTitle = leftTitle;
        self.leftTitle.textColor = [UIColor whiteColor];
        self.leftTitle.font = [UIFont systemFontOfSize:9.0];
        [leftView addSubview:leftTitle];

        UILabel *leftDetail = [[UILabel alloc] init];
        self.leftDetail = leftDetail;
        self.leftDetail.textColor = [UIColor whiteColor];
        leftDetail.font = [UIFont systemFontOfSize:25.0];
        [leftView addSubview:leftDetail];
        
        //右边的view
        UIView *rightView = [[UIView alloc] init];
        self.rightView = rightView;
        [self.beforeTransView addSubview:rightView];
        
        UILabel *rightTitle = [[UILabel alloc] init];
        self.rightTitle = rightTitle;
        self.rightTitle.textColor = [UIColor whiteColor];
        self.rightTitle.font = [UIFont systemFontOfSize:9.0];
        [rightView addSubview:rightTitle];
        
        UILabel *rightDetail = [[UILabel alloc] init];
        self.rightDetail = rightDetail;
        self.rightDetail.textColor = [UIColor whiteColor];
        rightDetail.font = [UIFont systemFontOfSize:20.0];
        [rightView addSubview:rightDetail];
        
        
        //底部的view
        UIView *bottomView = [[UIView alloc] init];
        self.bottmoView = bottomView;
        [self.beforeTransView addSubview:bottomView];
        
        UILabel *condDetail = [[UILabel alloc] init];
        condDetail.font = [UIFont systemFontOfSize:9.0];
        condDetail.textColor = [UIColor whiteColor];
        self.condDetail = condDetail;
        [bottomView addSubview:condDetail];
        
        UILabel *windDeail = [[UILabel alloc] init];
        windDeail.font = [UIFont systemFontOfSize:9.0];
        windDeail.textColor = [UIColor whiteColor];
        self.windDetail = windDeail;
        [bottomView addSubview:windDeail];
        
    }
    return self;
}


- (void)layoutSubviews
{
    //设置背景view
    [self setBackgroundView];
    
    //设置定位地点等信息
    [self setLocationData];
    
    //中间信息
    [self setMiddleViewData];
    
    //底部的信息
    //天气字体尺寸
    CGSize condSize = [NSString sizeWithText:self.condDetailstr font:self.condDetail.font maxSize:CPMAXSIZE];
    //图标
    UIImageView *condicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"std_home_icon_sun_white"]];
    condicon.frame = CGRectMake(0, 0, condSize.height, condSize.height);
    [self.bottmoView addSubview:condicon];
    
    //天气
    self.condDetail.text = self.condDetailstr;
    self.condDetail.frame = CGRectMake(condSize.height + 3, 0, condSize.width, condSize.height);
    
    //风力
    CGSize windSize = [NSString sizeWithText:self.windDetailstr font:self.windDetail.font maxSize:CPMAXSIZE];
    self.windDetail.text = self.windDetailstr;
    self.windDetail.frame = CGRectMake(condSize.height + 3 + condSize.width + 3, 0, windSize.width, windSize.height);

    self.bottmoView.frame = CGRectMake(0, self.beforeTransView.width - self.beforeTransView.height / 5, self.windDetail.x + windSize.width, condSize.height);
//    self.bottmoView.backgroundColor = [UIColor redColor];
    self.bottmoView.centerX = self.locationView.centerX;

    
}

#pragma mark 根据pm10设置不同的背景颜色
- (void)setBackgroundColorWithPmValue:(int)pm10_value
{
    //设置不同的背景颜色
    if (pm10_value < 50 || pm10_value == 50) {
        //优秀
        self.beforeViewcolor_200 = CP_RGB(65, 151, 242);
        self.beforeViewcolor_150 = CP_RGBA(65, 151, 242, 0.3);
        self.afterViewcolor_150 = CP_RGBA(65, 151, 242, 0.2);
        
    }else if((pm10_value > 51 && pm10_value < 100) || pm10_value == 100){
        //良好
        self.beforeViewcolor_200 = CP_RGB(196, 190, 7);
        self.beforeViewcolor_150 = CP_RGBA(196, 190, 7, 0.3);
        self.afterViewcolor_150 = CP_RGBA(196, 190, 7, 0.2);
        
    }else if((pm10_value > 101 && pm10_value < 150) || pm10_value == 150){
        //轻度污染
        self.beforeViewcolor_200 = CP_RGB(223, 125, 7);
        self.beforeViewcolor_150 = CP_RGBA(223, 125, 7, 0.3);
        self.afterViewcolor_150 = CP_RGBA(223, 125, 7, 0.2);
        
    }else if ((pm10_value > 151 && pm10_value < 200) || pm10_value == 200){
        //中度污染
        self.beforeViewcolor_200 = CP_RGB(239, 54, 43);
        self.beforeViewcolor_150 = CP_RGBA(239, 54, 43, 0.3);
        self.afterViewcolor_150 = CP_RGBA(239, 54, 43, 0.2);
    }else if ((pm10_value > 201 && pm10_value < 300) || pm10_value == 300){
        //重度污染
        self.beforeViewcolor_200 = CP_RGB(255, 28, 113);
        self.beforeViewcolor_150 = CP_RGBA(255, 28, 113, 0.3);
        self.afterViewcolor_150 = CP_RGBA(255, 28, 113, 0.2);
    }else if (pm10_value > 300){
        //严重污染
        self.beforeViewcolor_200 = CP_RGB(88, 11, 64);
        self.beforeViewcolor_150 = CP_RGBA(88, 11, 64, 0.3);
        self.afterViewcolor_150 = CP_RGBA(88, 11, 64, 0.2);
    }
}


#pragma mark 旋转前后的背景view的设置
- (void)setBackgroundView
{
#pragma mark 旋转前的背景容器view及子view数据设置
    CPLog(@"=====%f$$$%f$$$$%f$$$$5=%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    self.beforeTransView.frame = CGRectMake(0, 0, 200, 200);
    self.beforeTransView.centerX = self.centerX;
    
    //设置圆
    self.beforeCircleView_200.frame = CGRectMake(0, 0, 200, 200);
    self.beforeCircleView_200.backgroundColor = self.beforeViewcolor_200;
    self.beforeCircleView_200.layer.cornerRadius = self.beforeCircleView_200.width / 2;
    self.beforeCircleView_200.clipsToBounds = YES;
    
    //设置150圆
    self.beforeCircleView_150_0.frame = CGRectMake(0, 0, 150, 150);
    self.beforeCircleView_150_0.backgroundColor = self.beforeViewcolor_150;
    self.beforeCircleView_150_0.layer.cornerRadius = self.beforeCircleView_150_0.width / 2;
    self.beforeCircleView_150_0.clipsToBounds = YES;
    
    self.beforeCircleView_150_1.frame = CGRectMake(0, 50, 150, 150);
    self.beforeCircleView_150_1.backgroundColor = self.beforeViewcolor_150;
    self.beforeCircleView_150_1.layer.cornerRadius = self.beforeCircleView_150_1.width / 2;
    self.beforeCircleView_150_1.clipsToBounds = YES;
    
    self.beforeCircleView_150_2.frame = CGRectMake(50, 0, 150, 150);
    self.beforeCircleView_150_2.backgroundColor = self.beforeViewcolor_150;
    self.beforeCircleView_150_2.layer.cornerRadius = self.beforeCircleView_150_2.width / 2;
    self.beforeCircleView_150_2.clipsToBounds = YES;
    
    self.beforeCircleView_150_3.frame = CGRectMake(50, 50, 150, 150);
    self.beforeCircleView_150_3.backgroundColor = self.beforeViewcolor_150;
    self.beforeCircleView_150_3.layer.cornerRadius = self.beforeCircleView_150_3.width / 2;
    self.beforeCircleView_150_3.clipsToBounds = YES;
    
    
#pragma mark 旋转后的背景容器view及子view数据设置
    UIView *afterTransView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    afterTransView = afterTransView;
    afterTransView.centerX = self.centerX;
    //    afterTransView.backgroundColor = [UIColor redColor];
    [self addSubview:afterTransView];
    [self sendSubviewToBack:afterTransView];
    
    //设置150圆
    UIView *afterCircleView_150_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [afterTransView addSubview:afterCircleView_150_0];
    afterCircleView_150_0.backgroundColor = self.afterViewcolor_150;
    afterCircleView_150_0.layer.cornerRadius = afterCircleView_150_0.width / 2;
    afterCircleView_150_0.clipsToBounds = YES;
    
    UIView *afterCircleView_150_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 150, 150)];
    [afterTransView addSubview:afterCircleView_150_1];
    afterCircleView_150_1.backgroundColor = self.afterViewcolor_150;
    afterCircleView_150_1.layer.cornerRadius = afterCircleView_150_1.width / 2;
    afterCircleView_150_1.clipsToBounds = YES;
    
    UIView *afterCircleView_150_2 = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 150, 150)];
    afterCircleView_150_2 = afterCircleView_150_2;
    [afterTransView addSubview:afterCircleView_150_2];
    afterCircleView_150_2.backgroundColor = self.afterViewcolor_150;
    afterCircleView_150_2.layer.cornerRadius = afterCircleView_150_2.width / 2;
    afterCircleView_150_2.clipsToBounds = YES;
    
    UIView *afterCircleView_150_3 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 150, 150)];
    afterCircleView_150_3 = afterCircleView_150_3;
    [afterTransView addSubview:afterCircleView_150_3];
    afterCircleView_150_3.backgroundColor = self.afterViewcolor_150;
    afterCircleView_150_3.layer.cornerRadius = afterCircleView_150_3.width / 2;
    afterCircleView_150_3.clipsToBounds = YES;
    
    //旋转角度
    afterTransView.transform = CGAffineTransformMakeRotation(M_PI_4);
}

#pragma mark 设置定位地点等信息
- (void)setLocationData
{
    //省份城市尺寸
    CGSize locationSize = [NSString sizeWithText:self.locationLabelstr font:self.locationLabel.font maxSize:CPMAXSIZE];
    //定位图标
    UIImageView *locationicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_white"]];
    locationicon.frame = CGRectMake(0, 0, locationSize.height, locationSize.height);
    [self.locationView addSubview:locationicon];
    
    //省份城市
    self.locationLabel.frame = CGRectMake(locationSize.height, 0, locationSize.width, locationSize.height);
//    self.locationLabel.backgroundColor = [UIColor blueColor];
    self.locationLabel.text = self.locationLabelstr;
    
    //地点定位图标容器view
    self.locationView.frame = CGRectMake(0, self.beforeTransView.height / 8, locationicon.width + self.locationLabel.width, locationSize.height);
    self.locationView.centerX = self.beforeTransView.centerX - self.beforeTransView.x;
}

#pragma mark 设置中间的左边view信息数据
- (void)setMiddleViewData
{
    //设置中间的左边view信息数据
    //温度标题
    self.leftTitle.frame = CGRectMake(10, 0, TMPSIZE.width, TMPSIZE.height);
    self.leftTitle.text = @"温度℃";
    
    //温度详情
    CGSize ldetailSize = [NSString sizeWithText:self.leftDetailstr font:self.leftDetail.font maxSize:CPMAXSIZE];
    self.leftDetail.frame = CGRectMake(10, self.leftTitle.height, ldetailSize.width, ldetailSize.height);
    //    self.leftDetail.backgroundColor = [UIColor blueColor];
    self.leftDetail.text = self.leftDetailstr;
    
    
    //分割线
    CGFloat leftviewH = self.leftTitle.height + self.leftDetail.height;
    CPLog(@"=====&&&&&&&&&%f",leftviewH);
    UIView *lpadding = [[UIView alloc] initWithFrame:CGRectMake(self.leftView.width, 3, 1,leftviewH - 6)];
    lpadding.alpha = 0.5;
    //    lpadding.centerY = self.leftView.centerY - self.leftView.y;
    lpadding.backgroundColor = [UIColor whiteColor];
    [self.leftView addSubview:lpadding];
    
    //view的尺寸
    self.leftView.frame = CGRectMake(0, 0, self.beforeTransView.width * 0.5, leftviewH);
    self.leftView.centerY = self.beforeTransView.centerY;
    
    
    //设置中间的右边边view信息数据
    self.rightView.frame = CGRectMake(self.leftView.width, 0, self.beforeTransView.width * 0.5, leftviewH);
    self.rightView.centerY = self.beforeTransView.centerY;
    //    self.rightView.backgroundColor = [UIColor blueColor];
    
    
    //标题
    CGSize righttitleSize = [NSString sizeWithText:self.rightTitlestr font:self.rightTitle.font maxSize:CPMAXSIZE];
    
    self.rightTitle.frame = CGRectMake(10, 0, righttitleSize.width, righttitleSize.height);
    //    self.rightTitle.backgroundColor = [UIColor redColor];
    self.rightTitle.text = self.rightTitlestr;
    
    //详细信息
    CGSize rightdetailSize = [NSString sizeWithText:self.rightDetaillongstr font:self.rightDetail.font maxSize:CPMAXSIZE];
    
    self.rightDetail.frame = CGRectMake(10, 0, rightdetailSize.width, rightdetailSize.height);
    self.rightDetail.centerY = self.leftDetail.centerY;
    if (rightdetailSize.width < self.rightView.width) {
        self.rightDetail.text = self.rightDetaillongstr;
    }else{
        self.rightDetail.text = self.rightDetailstr;
    }

}
@end
