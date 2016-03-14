//
//  CPAdressModel.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPAdressModel.h"
#import "CPCitiesModel.h"
@implementation CPAdressModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理info详细信息的属性
        NSMutableArray *infoArray = [NSMutableArray array];
        for (NSDictionary *dict in self.Cities) {
            CPCitiesModel *cities = [CPCitiesModel cityWithDict:dict];
            [infoArray addObject:cities];
        }
        self.Cities = infoArray;
    }
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
