//
//  YZAddressPicker.m
//  yizhong
//
//  Created by tk on 16/1/6.
//  Copyright © 2016年 feibo. All rights reserved.
//

#import "YZAddressPicker.h"
#import "ProvinceCityArea.h"

#define DEFAULT_PROVINCE 7

@interface YZAddressPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayProvince;
@property (nonatomic, strong) NSMutableArray *arrayCitys;
@property (nonatomic, strong) NSMutableArray *arrayAreas;

@end

@implementation YZAddressPicker

//FB_LOG_DEALLOC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
    }
    [self setAlpha:0];
    [self setIsHidden:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@" "/*DOWNLOAD_CITY_FILE_NAME*/];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    if (!data || data.count <= 0) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    
    NSArray *keys = [data allKeys];
    self.arrayProvince = [[NSMutableArray alloc] init];
    
    for (NSString *key in keys) {
        NSMutableDictionary *dic = [data objectForKey:key];
        ProvinceCityArea *province = [[ProvinceCityArea alloc] init];
        for (NSString *k in [dic allKeys]) {
            //添加省
            province.province = k;
            NSMutableDictionary *d = [dic objectForKey:k];
            
            for (NSString *k1 in [d allKeys]) {
                NSMutableDictionary *result = [d objectForKey:k1];
                Town *city = [[Town alloc] init];
                for (NSString *k2 in [result allKeys]) {
                    //添加市
                    city.city = k2;
                    //添加区
                    city.arrayAreas = [result objectForKey:k2];
                }
                [province.arrayCitys addObject:city];
            }
        }
        [self.arrayProvince addObject:province];
    }
    for (NSInteger i = 0 ; i < self.arrayProvince.count; i++) {
        ProvinceCityArea *p = [self.arrayProvince objectAtIndex:i];
        NSRange range = [p.province rangeOfString:@"北京"];
        if (range.length != 0) {
            //找到了对应的省市了，移动到第一个
            ProvinceCityArea *tmp = [self.arrayProvince objectAtIndex:0];
            [self.arrayProvince replaceObjectAtIndex:0 withObject:p];
            [self.arrayProvince replaceObjectAtIndex:i withObject:tmp];
            
            break;
        }
    }
    
    ProvinceCityArea *p = (ProvinceCityArea *)[self.arrayProvince objectAtIndex:0];
    self.arrayCitys = p.arrayCitys;
    self.arrayAreas = ((Town *) [self.arrayCitys objectAtIndex:0]).arrayAreas;
    
    self.dic = [[NSMutableDictionary alloc] initWithDictionary:@{PROVINCE:p.province,CITY:((Town *)[self.arrayCitys objectAtIndex:0]).city,AREA:[self.arrayAreas objectAtIndex:0]}];
    
    return self;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    switch (component) {
        case 0:{
            count = self.arrayProvince.count;
            break;
        }
        case 1:{
            count = self.arrayCitys.count;
            break;
        }
        case 2:{
            count = self.arrayAreas.count;
            break;
        }
    }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            ProvinceCityArea *p = [self.arrayProvince objectAtIndex:row];
            return p.province;
        }
        case 1:{
            return ((Town *)[self.arrayCitys objectAtIndex:row]).city;
        }
        case 2:{
            return [self.arrayAreas objectAtIndex:row];
        }
    }
    return @"";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            ProvinceCityArea *p = [self.arrayProvince objectAtIndex:row];
            self.arrayCitys = p.arrayCitys;
            self.arrayAreas = ((Town *) [self.arrayCitys objectAtIndex:0]).arrayAreas;
            
            [self.dic setValue:p.province forKey:PROVINCE];
            [self.dic setValue:((Town *)[self.arrayCitys objectAtIndex:0]).city forKey:CITY];
            [self.dic setValue:[self.arrayAreas objectAtIndex:0] forKey:AREA];
            self.dic = self.dic;
            
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            break;
        }
        case 1:{
            Town *city = [self.arrayCitys objectAtIndex:row];
            self.arrayAreas = city.arrayAreas;
            
            [self.dic setValue:((Town *)[self.arrayCitys objectAtIndex:row]).city forKey:CITY];
            [self.dic setValue:[self.arrayAreas objectAtIndex:0] forKey:AREA];
            self.dic = self.dic;
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            break;
        }
        case 2:{
            [self.dic setValue:[self.arrayAreas objectAtIndex:row] forKey:AREA];
            self.dic = self.dic;
            break;
        }
        default:
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor blueColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:10.0]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)show {
    
//    @weakify(self);
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
//        @strongify(self);
        self.alpha = 1;
        self.isHidden = NO;
        self.dic = self.dic;
        
    }];
}

- (void)hide {
    
//    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
//        @strongify(self);
        self.alpha = 0;
        self.isHidden = YES;
    }];
}
@end
