//
//  CPTimeFreeModel.m
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPTimeFreeModel.h"

@implementation CPTimeFreeModel

+ (instancetype)timeFreeModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initTimeFreeModelWithDict:dict];
}

- (instancetype)initTimeFreeModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end


@implementation CPResultModel

+ (instancetype)resultModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initResultModelWithDict:dict];
}
- (instancetype)initResultModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理list详细信息的属性
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSDictionary *dict in self.list) {
            CPTimeFreeListModel *listmodel = [CPTimeFreeListModel timeFreeListModelWithDict:dict];
            [listArray addObject:listmodel];
        }
        self.list = listArray;
    }
    return self;
}

@end

@implementation CPTimeFreeListModel

+ (instancetype)timeFreeListModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initTimeFreeListModelWithDict:dict];
}
- (instancetype)initTimeFreeListModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end