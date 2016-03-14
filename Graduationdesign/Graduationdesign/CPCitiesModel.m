//
//  CPCitiesModel.m
//  test
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPCitiesModel.h"


@implementation CPCitiesModel

- (instancetype)initCityWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cityWithDict:(NSDictionary *)dict
{
    return [[self alloc] initCityWithDict:dict];
}


@end
