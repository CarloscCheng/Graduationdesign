//
//  CPDeviceGroup.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDeviceGroup.h"
#import "CPDeviceList.h"

@implementation CPDeviceGroup

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理info详细信息的属性
        NSMutableArray *infoArray = [NSMutableArray array];
        for (NSDictionary *dict in self.info) {
            CPDeviceList *infolist = [CPDeviceList infolistWithDict:dict];
            [infoArray addObject:infolist];
        }
        self.info = infoArray;
    }
    return self;
}

@end
