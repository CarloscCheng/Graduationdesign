//
//  YZAddressPicker.h
//  yizhong
//
//  Created by tk on 16/1/6.
//  Copyright © 2016年 feibo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROVINCE @"province"
#define CITY @"city"
#define AREA @"area"

@interface YZAddressPicker : UIPickerView

//省市区
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, assign) BOOL isHidden;

- (void)show;

- (void)hide;

@end
