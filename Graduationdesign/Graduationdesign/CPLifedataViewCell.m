//
//  CPLifedataViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPLifedataViewCell.h"
#import "CPDeviceGroup.h"
#import "CPDeviceList.h"
#import "CPWeatherConnect.h"



@interface CPLifedataViewCell()

/**
 *  天气状况描述
 */
@property (copy,nonatomic) NSString *condstr;
/**
 *  空气质量类别
 */
@property (copy,nonatomic) NSString *qlty;
/**
 *  PM10 1小时平均值(ug/m³)
 */
@property (copy,nonatomic) NSString *pm10;

/**
 *  PM2.5 1小时平均值(ug/m³)
 */
@property (copy,nonatomic) NSString *pm25;
/**
 *  最高温度
 */
@property (copy,nonatomic) NSString *max;

/**
 *  最低温度
 */
@property (copy,nonatomic) NSString *min;

@end

@implementation CPLifedataViewCell

//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"device";
    CPLifedataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPLifedataViewCell" owner:nil options:nil] lastObject];
        NSLog(@"---init life data");
    }
    return cell;
}

#pragma mark 根据不同列设置不同的cell信息
//设置天气数据
- (void)setcellData:(CPDeviceGroup *)group withIndex:(NSIndexPath *)indexPath
{
    //设置动画
    //[UIView beginAnimations:nil context:nil];
    CPWeatherConnect *connect = [[CPWeatherConnect alloc] init];
    [connect setWeatherDataBlock:^(NSDictionary *dict) {
        self.condstr = dict[@"condstr"];
        self.max = dict[@"max"];
        self.min = dict[@"min"];
        self.pm10 = dict[@"pm10"];
        self.pm25 = dict[@"pm25"];
        self.qlty = dict[@"qlty"];
    }];
    CPLog(@"设置天气");
    switch (indexPath.row) {
        case 0:
            [self setLifeDataForOne];
            break;
        case 1:
            [self setLifeDataForTwo];
            break;
        case 2:
            [self setLifeDataForThree];
        default:
            break;
    }
    //提交动画
    //[UIView commitAnimations];
}


#pragma mark 生活信息每一行的cell详细信息设置
- (void)setLifeDataForOne
{
    //设置背景view
    UIView *view = [[UIView alloc] init];
    
    //设置天气图标
    UIImageView *wimg = [[UIImageView alloc] init];
    
    //设置标题
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:11.0];
    title.textColor = [UIColor whiteColor];
    
    //设置详细信息
    UILabel *detail = [[UILabel alloc] init];
    detail.font = [UIFont systemFontOfSize:20.0];
    detail.textColor = [UIColor whiteColor];
    
    //设置竖线分割线
    UIView *whitepadding = [[UIView alloc] init];
    whitepadding.backgroundColor = [UIColor whiteColor];
    
    //空气质量标题
    UILabel *qltytitle = [[UILabel alloc] init];
    qltytitle.font = [UIFont systemFontOfSize:10.0];
    //空气质量详情
    UILabel *qltydetail = [[UILabel alloc] init];

    view.frame = CGRectMake(10, 10, 300, 100);
    
    //设置天气图标位置
    wimg.frame = CGRectMake(25, 20, 20, 20);
    wimg.image = [UIImage imageNamed:@"std_home_icon_overcast_white"];
    [view addSubview:wimg];
    
    //设置标题位置
    title.frame = CGRectMake(50, 20, 200, 20);
    //实时更新
    title.text = self.condstr;
    [view addSubview:title];
    
    //设置详细信息位置
    detail.frame = CGRectMake(25, 50, 215, 30);
    detail.text = [NSString stringWithFormat:@"%@°/ %@°",self.max,self.min];
    [view addSubview:detail];
    
    //设置竖线分割线
    whitepadding.frame = CGRectMake(160, 20, 1, 60);
    whitepadding.alpha = 0.3;
    [view addSubview:whitepadding];
    
    //空气质量标题
    qltytitle.frame = CGRectMake(190, 25, 100, 10);
    qltytitle.textColor = [UIColor whiteColor];
    qltytitle.text = [NSString stringWithFormat:@"空气质量 (PM2.5:%@)",self.pm25];//@"空气质量 (PM2.5:39)";
    [view addSubview:qltytitle];
    
    //空气质量详情
    qltydetail.frame = CGRectMake(190, 50, 80, 30);
//    qltydetail.backgroundColor = [UIColor redColor];
    qltydetail.textColor = [UIColor whiteColor];
    qltydetail.textAlignment = NSTextAlignmentCenter;
    qltydetail.font = [UIFont systemFontOfSize:16.0];
    qltydetail.text = self.qlty;
    [view addSubview:qltydetail];
    
    //添加点击事件
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    button.backgroundColor = [UIColor clearColor];
    //防止控件顺序加载不一样掩盖住了button
    [button addTarget:self action:@selector(oneCellIsTouched) forControlEvents:UIControlEventTouchUpInside];
    [view bringSubviewToFront:button];
    [view addSubview:button];
    
    //不同的背景颜色,此处要根据天气质量来变化颜色后面做
#warning 修复了一个根据pm2.5判断空气质量的小错误
    int pmValue = [self.pm10 intValue];
    if (pmValue < 50 || pmValue == 50) {
        //优秀
        view.backgroundColor = [UIColor colorWithRed:65.0/255 green:151.0/255 blue:242.0/255 alpha:1.0];
    }else if((pmValue > 51 && pmValue < 100) || pmValue == 100){
        //良好
        view.backgroundColor = [UIColor colorWithRed:196.0/255 green:190.0/255 blue:7.0/255 alpha:1.0];
    }else if((pmValue > 101 && pmValue < 150) || pmValue == 150){
        //轻度污染
        view.backgroundColor = [UIColor colorWithRed:223.0/255 green:125.0/255 blue:7.0/255 alpha:1.0];
    }else if ((pmValue > 151 && pmValue < 200) || pmValue == 200){
        //中度污染
        view.backgroundColor = [UIColor colorWithRed:239.0/255 green:54.0/255 blue:43.0/255 alpha:1.0];
    }else if ((pmValue > 201 && pmValue < 300) || pmValue == 300){
        //重度污染
        view.backgroundColor = [UIColor colorWithRed:255.0/255 green:28.0/255 blue:113.0/255 alpha:1.0];
    }else if (pmValue > 300){
        //严重污染
        view.backgroundColor = [UIColor colorWithRed:88.0/255 green:11.0/255 blue:64.0/255 alpha:1.0];
    }

    [self.contentView addSubview:view];
    
}

- (void)setLifeDataForTwo
{
    //设置背景view
    UIView *view = [[UIView alloc] init];

    //设置标题
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:10.0];
    title.textColor = [UIColor whiteColor];
    
    //设置详细信息
    UILabel *detail = [[UILabel alloc] init];
    detail.font = [UIFont systemFontOfSize:20.0];
    detail.textColor = [UIColor whiteColor];
    
    //设置竖线分割线
    UIView *whitepadding = [[UIView alloc] init];
    whitepadding.backgroundColor = [UIColor whiteColor];

    view.frame = CGRectMake(10, 5, 300, 100);
    
    //设置标题位置
    title.frame = CGRectMake(25, 20, 200, 20);
    title.text = @"室外PM10/PM2.5";
    [view addSubview:title];
    
    //设置详细信息位置
    detail.frame = CGRectMake(25, 50, 215, 30);
    detail.text = [NSString stringWithFormat:@"%@/%@",self.pm10,self.pm25];
    [view addSubview:detail];
    
    //设置竖线分割线
    whitepadding.frame = CGRectMake(160, 20, 1, 60);
    whitepadding.alpha = 0.3;
    [view addSubview:whitepadding];
    
    //广告部分
    UIView *adview = [[UIView alloc] initWithFrame:CGRectMake(190, 25, 3, 10)];
    adview.backgroundColor = [UIColor whiteColor];
    adview.alpha = 0.5;
    [view addSubview:adview];
    UILabel *adtitel = [[UILabel alloc] initWithFrame:CGRectMake(196, 25, 100, 10)];
    adtitel.font = [UIFont systemFontOfSize:10.0];
    adtitel.text = @"小米空气净化器";
    adtitel.textColor = [UIColor whiteColor];
    [view addSubview:adtitel];
    
    //广告详情
    UILabel *addetail = [[UILabel alloc] initWithFrame:CGRectMake(190, 45, 100, 30)];
    addetail.textColor = [UIColor whiteColor];
    addetail.font = [UIFont systemFontOfSize:9.0];
    //自动折行设置
    addetail.numberOfLines = 0;
    addetail.text = @"来自周围13000+台设备的平均数据";
    [view addSubview:addetail];
    
    //添加点击事件
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    button.backgroundColor = [UIColor clearColor];
    //防止控件顺序加载不一样掩盖住了button
    [button addTarget:self action:@selector(twoCellIsTouched) forControlEvents:UIControlEventTouchUpInside];
    [view bringSubviewToFront:button];
    [view addSubview:button];
    
    //不同的背景颜色
    view.backgroundColor = [UIColor colorWithRed:30.0/255 green:195.0/255 blue:139.0/255 alpha:1.0];
    [self.contentView addSubview:view];
}

- (void)setLifeDataForThree
{
    //设置背景view
    UIView *view = [[UIView alloc] init];
    
    //设置标题
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:11.0];
    title.textColor = [UIColor whiteColor];
    
    //设置详细信息
    UILabel *detail = [[UILabel alloc] init];
    detail.font = [UIFont systemFontOfSize:20.0];
    detail.textColor = [UIColor whiteColor];
    
    //最后一个cell下边的分割线
    UIView *padding = [[UIView alloc] init];
    
    //设置竖线分割线
    UIView *whitepadding = [[UIView alloc] init];
    whitepadding.backgroundColor = [UIColor whiteColor];

    //设置标题位置
    view.frame = CGRectMake(10, 0, 300, 100);
    
    title.frame = CGRectMake(25, 20, 200, 20);
    title.text = @"净化前/后(TDS)";
    [view addSubview:title];
    
    //设置详细信息位置
    detail.frame = CGRectMake(25, 50, 215, 30);
    detail.text = @"268/11";
    [view addSubview:detail];
    
    //设置竖线分割线
    whitepadding.frame = CGRectMake(160, 20, 1, 60);
    whitepadding.alpha = 0.3;
    [view addSubview:whitepadding];
    
    //广告部分
    UIView *adview = [[UIView alloc] initWithFrame:CGRectMake(190, 25, 3, 10)];
    adview.backgroundColor = [UIColor whiteColor];
    adview.alpha = 0.5;
    [view addSubview:adview];
    UILabel *adtitel = [[UILabel alloc] initWithFrame:CGRectMake(196, 25, 100, 10)];
    adtitel.font = [UIFont systemFontOfSize:10.0];
    adtitel.text = @"小米净水器";
    adtitel.textColor = [UIColor whiteColor];
    [view addSubview:adtitel];
    
    //广告详情
    UILabel *addetail = [[UILabel alloc] initWithFrame:CGRectMake(190, 45, 100, 30)];
    addetail.textColor = [UIColor whiteColor];
    addetail.font = [UIFont systemFontOfSize:9.0];
    //自动折行设置
    addetail.numberOfLines = 0;
    addetail.text = @"来自周围500+台设备的平均数据";
    [view addSubview:addetail];
    
    
    //添加点击事件
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    button.backgroundColor = [UIColor clearColor];
    //防止控件顺序加载不一样掩盖住了button
    [button addTarget:self action:@selector(threeCellIsTouched) forControlEvents:UIControlEventTouchUpInside];
    [view bringSubviewToFront:button];
    [view addSubview:button];
    

    //不同的背景颜色
    view.backgroundColor = [UIColor colorWithRed:202.0/255 green:144.0/255 blue:255.0/255 alpha:1.0];
    [self.contentView addSubview:view];
    //下方的黑色分割线
    [self.contentView addSubview:view];
    padding.frame = CGRectMake(0, 109, 320, 1);
    padding.backgroundColor = [UIColor lightGrayColor];
    padding.alpha = 0.3;
    [self.contentView addSubview:padding];

}

#pragma mark 点击不同的cell的view触发的事件
- (void)oneCellIsTouched
{
    CPLog(@"one is touched");
    //改变属性值
    //设置的通知，名字叫helloname，object是一些参数，有时候发通知可能要随带的参数
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CPLifedataViewCell" object:nil];
}


- (void)twoCellIsTouched
{
    CPLog(@"two is touched");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"敬请期待!" message:@"拼命开发中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)threeCellIsTouched
{
    CPLog(@"three is touched");
    CPLog(@"two is touched");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"敬请期待!" message:@"拼命开发中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    CPLog(@"selected");
    // Configure the view for the selected state
}

@end
