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

@interface CPAddressView()<UITableViewDataSource,UITableViewDelegate>

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

- (void)buttonClicked
{
    CPLog(@"button clicked");
    [self removeFromSuperview];
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
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"定位功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alter show];
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



@end
