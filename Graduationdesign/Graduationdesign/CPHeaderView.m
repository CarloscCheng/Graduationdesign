//
//  CPHeaderView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPHeaderView.h"
#import "CPDeviceGroup.h"
#import "CPWeatherConnect.h"
#import "CPAddressView.h"
#import "CPAdressModel.h"
#import "CPAreaIDModel.h"

#warning 这里判断登录不能保证程序退出再运行还会记住登录情况，需优化
static BOOL login;

@interface CPHeaderView()<CPAddressViewDelegate>
/**
 *  headerView内部的view控件
 */
@property (weak,nonatomic) UIView *hView;

/**
 *  view中的标签
 */
@property (weak,nonatomic) UILabel *infoTitle;

/**
 *  view最右边的导航图片
 */
@property (weak,nonatomic) UIImageView *rightView;

/**
 *  城市
 */
@property (copy,nonatomic) NSString *city;
/**
 *  省份
 */
@property (copy,nonatomic) NSString *provice;

/**
 *  天气状况描述
 */
@property (copy,nonatomic) NSString *condstr;
/**
 *  空气质量类别
 */
@property (copy,nonatomic) NSString *qlty;
/**
 *  PM2.5 1小时平均值(ug/m³)
 */
@property (copy,nonatomic) NSString *pm25;
/**
 *  pm10
 */
@property (copy,nonatomic) NSString *pm10;
/**
 *  最高温度
 */
@property (copy,nonatomic) NSString *max;
/**
 *  最低温度
 */
@property (copy,nonatomic) NSString *min;


@property (strong,nonatomic) CPAddressView *addressview;

@end

@implementation CPHeaderView

+ (instancetype)headerViewCreate;
{
    CPHeaderView *header = [[CPHeaderView alloc] init];
    
    //添加view
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    //添加label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(10, 15, 160, 12);
    
    //添加分割线
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    padding.backgroundColor = [UIColor lightGrayColor];
    padding.alpha = 0.3;
    
    //添加右边导航图片
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crop"]];
    //        rightView.backgroundColor = [UIColor redColor];
    header.rightView = rightView;
    
    //添加控件
    [view addSubview:rightView];
    [view addSubview:padding];
    [view addSubview:label];
    header.infoTitle = label;
    [header addSubview:view];
    header.hView = view;
    
    return header;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.hView.frame = CGRectMake(0, 0, 320, 44);
    self.rightView.frame = CGRectMake(280, 7, 30, 30);

}

- (void)setAppLoginStatus:(loginStatusBlock)block
{
    login = block();
    CPLog(@"======&&&&&&&&&&&&&%hhd",login);
}

//内部view的触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //在这里判断如果app用户登录则进入下一步，否则提示登录

    
    // 1.修改组模型的标记(状态取反)
    NSLog(@"opened = %d",self.group.opened);
    self.group.opened = !self.group.isOpened;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidTouchView:)]) {
        [self.delegate headerViewDidTouchView:self];
    }
}

- (void)setGroup:(CPDeviceGroup *)group
{
    _group = group;
    self.infoTitle.text = group.infotitle;
    
    //设置生活信息cell的标题
    if ([group.infotitle isEqualToString:@"生活信息"]) {
        [[[CPWeatherConnect alloc] init] setWeatherDataBlock:^(NSDictionary *dict) {
            self.city = dict[@"city"];
            self.condstr = dict[@"condstr"];
            self.max = dict[@"max"];
            self.min = dict[@"min"];
            self.pm25 = dict[@"pm25"];
            self.qlty = dict[@"qlty"];
            self.pm10 = dict[@"pm10"];
        }];
        
        if (!self.group.opened) {
            //只对生活信息处设置，优化代码性能
            [self setLifeDataCloseCellTitle];
        }else
        {
            [self setLifeDataOpenCellTitle];
        }
    }
    
    // 3.重新设置左边箭头的状态
    [self didMoveToSuperview];
    
}

- (void)setLifeDataOpenCellTitle
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 100, 40)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(ChosenPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.hView addSubview:button];

    UILabel *placelabel = [[UILabel alloc] init];
    placelabel.textColor = [UIColor lightGrayColor];
    placelabel.font = [UIFont systemFontOfSize:10];

    //获取cityid模型
    CPAreaIDModel *areaidmodel = [CPAreaIDModel areaIdWithStr:self.city];
    
    //得到当前省份
    if ([areaidmodel.PROVCN isEqualToString:self.city]) {
        placelabel.text = [NSString stringWithFormat:@"%@", self.city];//@"北京";
    }else
    {
        placelabel.text = [NSString stringWithFormat:@"%@·%@", areaidmodel.PROVCN, self.city];//@"福建 福州";
    }


    //字体长度
    CGSize labelSize = [NSString sizeWithText:placelabel.text font:placelabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    placelabel.frame = CGRectMake(60, 16, labelSize.width, 10);
    
    [self.hView addSubview:placelabel];
}


- (void)setLifeDataCloseCellTitle
{
    //获取数据
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 58, 40)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(ChosenPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.hView addSubview:button];
    
    //小分割线
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(60, 14, 1, 16)];
    padding.backgroundColor = [UIColor lightGrayColor];
    padding.alpha = 0.3;
    [self.hView addSubview:padding];
    
    //小天气图标
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"std_home_icon_overcast_black"]];
    imageview.frame = CGRectMake(66, 17, 10, 10);
    [self.hView addSubview:imageview];
    
    
    //小天气详情
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10];
    label.text = [NSString stringWithFormat:@"%@ %@℃~%@℃",self.condstr,self.max,self.min];//@"晴 16℃~5℃";
    //字体长度
    CGSize labelSize = [NSString sizeWithText:label.text font:label.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
//    label.frame = CGRectMake(82, 17, 100, 10);
    label.frame = CGRectMake(82, 17, labelSize.width, 10);
    [self.hView addSubview:label];
    
    //小空气质量详情
    UILabel *airvlabel = [[UILabel alloc] init];
    airvlabel.textColor = [UIColor whiteColor];
    airvlabel.textAlignment = NSTextAlignmentCenter;
    airvlabel.text = [NSString stringWithFormat:@"空气%@%@",self.qlty,self.pm25];//@"空气良41";
    airvlabel.font = [UIFont systemFontOfSize:10];
    
    //字体长度
    CGSize airvlabelSize = [NSString sizeWithText:airvlabel.text font:airvlabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    //airlabel中心x坐标
    CGFloat airvPadding = 6;
    CGFloat airvlabelH = 20;
    CGFloat airvlabelW = airvlabelSize.width + airvPadding;
    CGFloat airvlabelX = label.frame.origin.x + labelSize.width + airvPadding;
    CGFloat airvlabelY = label.center.y - airvlabelH * 0.5;
    airvlabel.frame = CGRectMake(airvlabelX, airvlabelY, airvlabelW, airvlabelH);

    //不同的背景颜色,此处要根据天气质量来变化颜色后面做
    int pmValue = [self.pm10 intValue];
    //不同的背景颜色,此处要根据天气质量来变化颜色后面做
    if (pmValue < 50 || pmValue == 50) {
        //优秀
        airvlabel.backgroundColor = [UIColor colorWithRed:65.0/255 green:151.0/255 blue:242.0/255 alpha:1.0];
    }else if((pmValue > 50 && pmValue < 100) || pmValue == 100){
        //良好
        airvlabel.backgroundColor = [UIColor colorWithRed:196.0/255 green:190.0/255 blue:7.0/255 alpha:1.0];
    }else if((pmValue > 100 && pmValue < 150) || pmValue == 150){
        //轻度污染
        airvlabel.backgroundColor = [UIColor colorWithRed:223.0/255 green:125.0/255 blue:7.0/255 alpha:1.0];
    }else if ((pmValue > 150 && pmValue < 200) || pmValue == 200){
        //中度污染
        airvlabel.backgroundColor = [UIColor colorWithRed:239.0/255 green:54.0/255 blue:43.0/255 alpha:1.0];
    }else if ((pmValue > 200 && pmValue < 300) || pmValue == 300){
        //重度污染
        airvlabel.backgroundColor = [UIColor colorWithRed:255.0/255 green:28.0/255 blue:113.0/255 alpha:1.0];
    }else if (pmValue > 300){
        //严重污染
        airvlabel.backgroundColor = [UIColor colorWithRed:88.0/255 green:11.0/255 blue:64.0/255 alpha:1.0];
    }
    [self.hView addSubview:airvlabel];
}



#pragma mark 点击生活信息处弹出地理位置选择
- (void)ChosenPosition
{
    CPLog(@"ChosePosition");
    self.addressview = [[CPAddressView alloc] init];
    self.addressview.delegate = self;
    [self.window addSubview:self.addressview];
}

#pragma adressview代理
- (void)addressViewCityNameIsChoosed:(CPAdressModel *)addressmodel
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidChooseCity:)]) {
        [self.delegate headerViewDidChooseCity:self];
    }
    CPLog(@"$$$$$$$$$$%@",addressmodel.State);
    self.provice = addressmodel.State;
}

//一个控件被添加到父控件中就会调用
- (void)didMoveToSuperview
{
    //改变图片
    if (self.group.opened){
        self.rightView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        self.rightView.transform = CGAffineTransformMakeRotation(0);
    }
}


@end
