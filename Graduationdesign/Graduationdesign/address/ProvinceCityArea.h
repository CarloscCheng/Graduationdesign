//
//  ProvinceCityArea.h
//  yizhong
//
//  Created by tk on 16/1/6.
//  Copyright © 2016年 feibo. All rights reserved.
//

#import <Foundation/Foundation.h>

// Town 为省市区的city，因重名定义为Town

@interface Town : NSObject

@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSMutableArray *arrayAreas;

@end

@interface ProvinceCityArea : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSMutableArray *arrayCitys;

@end