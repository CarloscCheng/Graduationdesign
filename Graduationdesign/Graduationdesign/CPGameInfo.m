//
//  CPGameInfo.m
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameInfo.h"

@implementation CPGameInfo

- (instancetype)initGameInfoWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self; 
}

+ (instancetype)gameInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameInfoWithDict:dict];
}

@end

@implementation CPGameResult
//数组中需要转换的模型类 @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
+ (NSDictionary *)objectClassInArray{
    return @{@"relateGame" : [CPGameRelategame class], @"gallary" : [CPGameGallary class], @"relateNews" : [CPGameRelatenews class]};
}

- (instancetype)initGameResultWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)gameResultWithDict:(NSDictionary *)dict
{
     return [[self alloc] initGameResultWithDict:dict];
}
@end

@implementation CPGameRelategame

- (instancetype)initGameRelategameWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}
+ (instancetype)relategameWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameRelategameWithDict:dict];
}
@end

@implementation CPGameGallary

- (instancetype)initGameGallaryWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)gallaryWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameGallaryWithDict:dict];
}

@end

@implementation CPGameRelatenews

- (instancetype)initGameRelatenewsWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;

}
+ (instancetype)gameRelatenewsWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameRelatenewsWithDict:dict];
}
@end

@implementation CPGameDetail

- (instancetype)initGameDetailWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)gameDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameDetailWithDict:dict];
}
@end


@implementation CPGameSharetpl

@end


@implementation CPGameShareTplWxhy

@end


@implementation CPGameShareTplWxpyq

@end


@implementation CPShareTplWb

@end


@implementation CPGameVideo

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CPGameVideoList class]};
}

- (instancetype)initGameVideoWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;

}
+ (instancetype)gameVideoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameVideoWithDict:dict];
}

@end


@implementation CPGameVideoShow

- (instancetype)initGameVideoShowWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)gameVideoShowWithDict:(NSDictionary *)dict
{
   return [[self alloc] initGameVideoShowWithDict:dict];
}

@end

@implementation CPGameVideoList
- (instancetype)initGameVideoListWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)gameVideoListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameVideoListWithDict:dict];
}
@end


@implementation CPGameStrategy

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CPGameStrategyList class]};
}

- (instancetype)initGameStrategyWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)gameStrategyWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameStrategyWithDict:dict];
}
@end


@implementation CPGameStrategyList
- (instancetype)initGameStrategyListWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;

}
+ (instancetype)gameStrategyListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initGameStrategyListWithDict:dict];
}

@end



