//
//  CPDeviceList.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDeviceList.h"

@implementation CPDeviceList

- (instancetype)initInfoWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)infolistWithDict:(NSDictionary *)dict
{
    return [[self alloc] initInfoWithDict:dict];
}
@end