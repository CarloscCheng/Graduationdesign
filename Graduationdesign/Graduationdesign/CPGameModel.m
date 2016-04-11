//
//  CPGameModel.m
//  Graduationdesign
//
//  Created by cheng on 16/4/7.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameModel.h"

@implementation CPGameModel

+ (instancetype)gameModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameModelWithDict:dict];
}

- (instancetype)initGameModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end


@implementation CPSortModel

+ (instancetype)sortModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initSortModelWithDict:dict];
}

- (instancetype)initSortModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.注入所有属性
        self.next = [dict[@"next"] intValue];
        self.gallary = dict[@"gallary"];
        self.hotlist = dict[@"hot_list"];
        self.newlist = dict[@"new_list"];
    }
    return self;
    
}

+ (instancetype)sortModel
{
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:gameCacheName];
    NSData *gameData = [NSData dataWithContentsOfFile:cachefilename];
    
    NSDictionary *gameDataDict = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableLeaves error:nil];
    
    CPGameModel *gameModel = [CPGameModel gameModelWithDict:gameDataDict];
    CPSortModel *sortModel = [CPSortModel sortModelWithDict:gameModel.result];
    
    return sortModel;
}

@end


@implementation CPGallaryModel

+ (instancetype)gallaryModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGallaryModelWithDict:dict];
}


- (instancetype)initGallaryModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end

@implementation CPNewListModel

+ (instancetype)newListModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initNewListModelWithDict:dict];
}


- (instancetype)initNewListModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end

@implementation CPHotListModel

+ (instancetype)hotListModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initHotListModelWithDict:dict];
} 


- (instancetype)initHotListModelWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
