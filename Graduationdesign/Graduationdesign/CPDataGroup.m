//
//  CPDataGroup.m
//  Graduationdesign
//
//  Created by cheng on 16/3/24.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPDataGroup.h"
#import "CPData.h"

@implementation CPDataGroup

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        // 2.特殊处理info详细信息的属性
        NSMutableArray *infoArray = [NSMutableArray array];
        for (NSDictionary *dict in self.otherdata) {
            
            CPData *data = [CPData dataWithDict:dict];
            [infoArray addObject:data];
        }
        self.otherdata = infoArray;
    }
    return self;
}

+ (instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
