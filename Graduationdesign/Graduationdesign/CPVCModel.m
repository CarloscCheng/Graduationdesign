//
//  CPVCModel.m
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPVCModel.h"


@implementation CPVCGameModel

+ (instancetype)vcGameModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initVcGameModelWithDict:dict];
}

- (instancetype)initVcGameModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end

@implementation CPVCTopModel

+ (instancetype)vcTopModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initVcTopModelWithDict:dict];
}

- (instancetype)initVcTopModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        [self setValuesForKeysWithDictionary:dict];
        
        // 2.特殊处理list详细信息的属性
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSDictionary *dict in self.list) {
            CPVCGameList *listmodel = [CPVCGameList vcGameListWithDict:dict];
            [listArray addObject:listmodel];
        }
        self.list = listArray;
    }
    return self;

}
@end

@implementation CPVCGameList

+ (instancetype)vcGameListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initVcGameListWithDict:dict];
}

- (instancetype)initVcGameListWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end



