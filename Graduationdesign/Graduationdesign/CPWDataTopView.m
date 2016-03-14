//
//  CPWDataTopView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-7.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//
#import "CPWDataTopView.h"
#import "CPWeatherConnect.h"

//日期的字体
#define CPDATEFONT [UIFont systemFontOfSize:11.0]
//预报字体
#define CPFORECASTFONT [UIFont systemFontOfSize:11.0]
//温度字体
#define CPTMPFONT [UIFont systemFontOfSize:10.0]
//星期的字体尺寸
#define CPWEEKSIZE [NSString sizeWithText:@"星期" font:CPDATEFONT maxSize:CPMAXSIZE]



#define CPTEXTCOLOR [UIColor clearColor]
@interface CPWDataTopView()

/**
 *  放置预报label的view（第一天）
 */
@property (weak,nonatomic) UIView *fView;
/**
 *  日期(星期)
 */
@property (weak,nonatomic) UILabel *fDate;
@property (copy,nonatomic) NSString *fDatestr;
/**
 *  天气预报详情
 */
@property (weak,nonatomic) UILabel *fForecast;
@property (copy,nonatomic) NSString *fForecaststr;
/**
 *  温度
 */
@property (weak,nonatomic) UILabel *fTmp;
@property (copy,nonatomic) NSString *fTmpstr;
/**
 *  分割线
 */
@property (weak,nonatomic) UIView *fpadding;

/**
 *  放置预报label的view（第二天）
 */
@property (weak,nonatomic) UIView *sView;
@property (weak,nonatomic) UILabel *sDate;
@property (copy,nonatomic) NSString *sDatestr;
@property (weak,nonatomic) UILabel *sForecast;
@property (copy,nonatomic) NSString *sForecaststr;
@property (weak,nonatomic) UILabel *sTmp;
@property (copy,nonatomic) NSString *sTmpstr;
@property (weak,nonatomic) UIView *spadding;
/**
 *  放置预报label的view（第三天）
 */
@property (weak,nonatomic) UIView *tView;
@property (weak,nonatomic) UILabel *tDate;
@property (copy,nonatomic) NSString *tDatestr;
@property (weak,nonatomic) UILabel *tForecast;
@property (copy,nonatomic) NSString *tForecaststr;
@property (weak,nonatomic) UILabel *tTmp;
@property (copy,nonatomic) NSString *tTmpstr;

@end

@implementation CPWDataTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialization code
        //获取数据
        [[[CPWeatherConnect alloc] init] setWeatherDataBlock:^(NSDictionary *data) {
            //第一天的预报数据
            NSString *ymd = data[@"fdate"]; //yyyy-mm-dd
            NSDate *ymddate = [NSDate convertDateFromString:ymd];
            self.fDatestr = [NSString weekdayStringFromDate:ymddate];
            NSString *fForecastd = data[@"ftxt_d"];
            NSString *fForecastn = data[@"ftxt_n"];
//            CPLog(@"============%@-=============%@",fForecastd,fForecastn);
            if ([fForecastd isEqualToString:fForecastn]) {
                self.fForecaststr = [NSString stringWithFormat:@"%@",fForecastd];
            }else{
                self.fForecaststr = [NSString stringWithFormat:@"%@转%@",fForecastd,fForecastn];
            }
            NSString *fTmpmax = data[@"fmax"];
            NSString *fTmpmin = data[@"fmin"];
            self.fTmpstr = [NSString stringWithFormat:@"%@℃/%@℃",fTmpmax,fTmpmin];
            
            //第二天的预报数据
            NSString *symd = data[@"sdate"]; //yyyy-mm-dd
            NSDate *symddate = [NSDate convertDateFromString:symd];
            self.sDatestr = [NSString weekdayStringFromDate:symddate];
            NSString *sForecastd = data[@"stxt_d"];
            NSString *sForecastn = data[@"stxt_n"];

            if ([sForecastd isEqualToString:sForecastn]) {
                self.sForecaststr = [NSString stringWithFormat:@"%@",sForecastd];
            }else{
                self.sForecaststr = [NSString stringWithFormat:@"%@转%@",sForecastd,sForecastn];
            }
            NSString *sTmpmax = data[@"smax"];
            NSString *sTmpmin = data[@"smin"];
            self.sTmpstr = [NSString stringWithFormat:@"%@℃/%@℃",sTmpmax,sTmpmin];
            
            //第三天天的预报数据
            NSString *tymd = data[@"tdate"]; //yyyy-mm-dd
            NSDate *tymddate = [NSDate convertDateFromString:tymd];
            self.tDatestr = [NSString weekdayStringFromDate:tymddate];
            NSString *tForecastd = data[@"ttxt_d"];
            NSString *tForecastn = data[@"ttxt_n"];
            
            if ([tForecastd isEqualToString:tForecastn]) {
                self.tForecaststr = [NSString stringWithFormat:@"%@",tForecastd];
            }else{
                self.tForecaststr = [NSString stringWithFormat:@"%@转%@",tForecastd,tForecastn];
            }
            NSString *tTmpmax = data[@"tmax"];
            NSString *tTmpmin = data[@"tmin"];
            self.tTmpstr = [NSString stringWithFormat:@"%@℃/%@℃",tTmpmax,tTmpmin];
        }];

#pragma mark 第一天初始化设置
        UIView *fView = [[UIView alloc] init];
        self.fView = fView;
        [self addSubview:fView];
//        fView.backgroundColor = [UIColor redColor];
        
        //星期
        UILabel *fDate = [[UILabel alloc] init];
        fDate.font = CPDATEFONT;
        fDate.textColor = [UIColor lightGrayColor];
        self.fDate = fDate;
        [fView addSubview:fDate];
        
        //预报
        UILabel *fForecast = [[UILabel alloc] init];
        self.fForecast = fForecast;
        self.fForecast.textColor = [UIColor blackColor];
        self.fForecast.font = CPFORECASTFONT;
        [fView addSubview:fForecast];
        
        //温度
        UILabel *fTmp = [[UILabel alloc] init];
        fTmp.font = CPTMPFONT;
        fTmp.textColor = [UIColor lightGrayColor];
        self.fTmp = fTmp;
        [fView addSubview:fTmp];
        
        //竖分割线
        UIView *fpadding = [[UIView alloc] init];
        fpadding.backgroundColor = [UIColor lightGrayColor];
        fpadding.alpha = 0.3;
        self.fpadding = fpadding;
        [fView addSubview:fpadding];

#pragma mark 第二天初始化设置
        UIView *sView = [[UIView alloc] init];
        self.sView = sView;
        [self addSubview:sView];
//        sView.backgroundColor = [UIColor blueColor];
        
        //星期
        UILabel *sDate = [[UILabel alloc] init];
        sDate.font = CPDATEFONT;
        sDate.textColor = [UIColor lightGrayColor];
        self.sDate = sDate;
        [sView addSubview:sDate];
        
        //预报
        UILabel *sForecast = [[UILabel alloc] init];
        self.sForecast = sForecast;
        self.sForecast.textColor = [UIColor blackColor];
        self.sForecast.font = CPFORECASTFONT;
        [sView addSubview:sForecast];
        
        //温度
        UILabel *sTmp = [[UILabel alloc] init];
        sTmp.font = CPTMPFONT;
        sTmp.textColor = [UIColor lightGrayColor];
        self.sTmp = sTmp;
        [sView addSubview:sTmp];
        
        //竖分割线
        UIView *spadding = [[UIView alloc] init];
        spadding.backgroundColor = [UIColor lightGrayColor];
        spadding.alpha = 0.3;
        self.spadding = spadding;
        [sView addSubview:spadding];
        
#pragma mark 第三天初始化设置
        UIView *tView = [[UIView alloc] init];
        self.tView = tView;
        [self addSubview:tView];
//        tView.backgroundColor = [UIColor yellowColor];
        
        //星期
        UILabel *tDate = [[UILabel alloc] init];
        tDate.font = CPDATEFONT;
        tDate.textColor = [UIColor lightGrayColor];
        self.tDate = tDate;
        [tView addSubview:tDate];
        
        //预报
        UILabel *tForecast = [[UILabel alloc] init];
        self.tForecast = tForecast;
        self.tForecast.font = CPFORECASTFONT;
        self.tForecast.textColor = [UIColor blackColor];
        [tView addSubview:tForecast];
        
        //温度
        UILabel *tTmp = [[UILabel alloc] init];
        tTmp.font = CPTMPFONT;
        tTmp.textColor = [UIColor lightGrayColor];
        self.tTmp = tTmp;
        [tView addSubview:tTmp];
        
    }
    return self;
}

- (void)layoutSubviews
{
//    self.frame = CGRectMake(0, 0, CPWINDOWWIDTH, 64);
#pragma mark 第一天具体参数设置
    self.fView.frame = CGRectMake(0, 0, CPAVERWIDTH, self.height);
    //分割线
    self.fpadding.frame = CGRectMake(self.fView.width, 0, 1, 44);
    self.fpadding.centerY = self.fView.centerY;
    
    // 星期
    self.fDate.frame = CGRectMake(0, self.fpadding.y, CPWEEKSIZE.width, CPWEEKSIZE.height);
    self.fDate.backgroundColor = CPTEXTCOLOR;
    self.fDate.centerX = self.fView.centerX;

    self.fDate.text = self.fDatestr;
    
    //预报详情
    //预报字体尺寸
    CGSize fforecastSize = [NSString sizeWithText:self.fForecaststr font:CPFORECASTFONT maxSize:CPMAXSIZE];
    
    //预报label尺寸
    self.fForecast.frame = CGRectMake(0, 0, fforecastSize.width, fforecastSize.height);
    self.fForecast.backgroundColor = CPTEXTCOLOR;
    self.fForecast.center = self.fView.center;
    
    //set
    self.fForecast.text = self.fForecaststr;

    //温度详情
    //温度字体尺寸
    CGSize fftmpsize = [NSString sizeWithText:self.fTmpstr font:CPTMPFONT maxSize:CPMAXSIZE];
    CGFloat ftmpY = self.fpadding.y + self.fpadding.height - fftmpsize.height;
    self.fTmp.frame = CGRectMake(0, ftmpY, fftmpsize.width, fftmpsize.height);
    self.fTmp.backgroundColor = CPTEXTCOLOR;
    self.fTmp.centerX = self.fView.centerX;
    //set
    self.fTmp.text = self.fTmpstr;
    
    
#pragma mark 第二天具体参数设置
    self.sView.frame = CGRectMake(CPAVERWIDTH, 0, CPAVERWIDTH, self.height);
    //分割线
    self.spadding.frame = CGRectMake(self.sView.width, 0, 1, 44);
    self.spadding.centerY= self.sView.centerY;
//    self.spadding.backgroundColor = CPTEXTCOLOR;
    
    //星期
    self.sDate.frame = CGRectMake(0, self.spadding.y, CPWEEKSIZE.width, CPWEEKSIZE.height);
    self.sDate.centerX = self.sView.centerX - CPAVERWIDTH;
//    CPLog(@"self.centx===%f,self.sview.centx=%f,sel.sdate.centx=%f",self.centerX,self.sView.centerX,self.sDate.centerX);
//    self.sDate.backgroundColor = [UIColor blueColor];
    self.sDate.text = self.sDatestr;
    
    //预报详情
    //预报字体尺寸
    CGSize sforecastSize = [NSString sizeWithText:self.sForecaststr font:CPFORECASTFONT maxSize:CPMAXSIZE];
    
    //预报label尺寸
    self.sForecast.frame = CGRectMake(0, 0, sforecastSize.width, sforecastSize.height);
    self.sForecast.backgroundColor = CPTEXTCOLOR;
    self.sForecast.centerY = self.sView.centerY;
    self.sForecast.centerX = self.sView.centerX - CPAVERWIDTH;
    
    //set
    self.sForecast.text = self.sForecaststr;
    
    //温度详情
    //温度字体尺寸
    CGSize sftmpsize = [NSString sizeWithText:self.sTmpstr font:CPTMPFONT maxSize:CPMAXSIZE];
    CGFloat stmpY = self.spadding.y + self.spadding.height - sftmpsize.height;
    self.sTmp.frame = CGRectMake(0, stmpY, sftmpsize.width, sftmpsize.height);
    self.sTmp.backgroundColor = CPTEXTCOLOR;
    self.sTmp.centerX = self.sView.centerX - CPAVERWIDTH;
    //set
    self.sTmp.text = self.sTmpstr;
    
    
    
#pragma mark 第三天具体参数设置
    self.tView.frame = CGRectMake(CPAVERWIDTH * 2, 0, CPAVERWIDTH, self.height);
    
    //星期
    self.tDate.frame = CGRectMake(0, self.spadding.y, CPWEEKSIZE.width, CPWEEKSIZE.height);
    self.tDate.centerX = self.tView.centerX - 2 * CPAVERWIDTH;
//    self.tDate.backgroundColor = CPTEXTCOLOR;
    self.tDate.text = self.tDatestr;
    
    //预报详情
    //预报字体尺寸
    CGSize tforecastSize = [NSString sizeWithText:self.tForecaststr font:CPFORECASTFONT maxSize:CPMAXSIZE];
    
    //预报label尺寸
    self.tForecast.frame = CGRectMake(0, 0, tforecastSize.width, tforecastSize.height);
    self.tForecast.backgroundColor = CPTEXTCOLOR;
    self.tForecast.centerY = self.tView.centerY;
    self.tForecast.centerX = self.tView.centerX - 2 * CPAVERWIDTH;
    
    //set
    self.tForecast.text = self.tForecaststr;
    
    //温度详情
    //温度字体尺寸
    CGSize tftmpsize = [NSString sizeWithText:self.tTmpstr font:CPTMPFONT maxSize:CPMAXSIZE];
    CGFloat ttmpY = self.spadding.y + self.spadding.height - tftmpsize.height;
    self.tTmp.frame = CGRectMake(0, ttmpY, tftmpsize.width, tftmpsize.height);
    self.tTmp.backgroundColor = CPTEXTCOLOR;
    self.tTmp.centerX = self.tView.centerX - 2 * CPAVERWIDTH;
    //set
    self.tTmp.text = self.tTmpstr;

}





@end
