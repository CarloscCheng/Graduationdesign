//
//  CPTimeFreeModel.h
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTimeFreeModel : NSObject

@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;

+ (instancetype)timeFreeModelWithDict:(NSDictionary *)dict;
- (instancetype)initTimeFreeModelWithDict:(NSDictionary *)dict;

@end

@interface CPResultModel : NSObject

@property (nonatomic, assign) NSInteger has_more;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *next;
@property (nonatomic, assign) NSInteger count;


+ (instancetype)resultModelWithDict:(NSDictionary *)dict;
- (instancetype)initResultModelWithDict:(NSDictionary *)dict;

@end

@interface CPTimeFreeListModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic, copy) NSString *pre_price;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger is_today_updated;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *name;


+ (instancetype)timeFreeListModelWithDict:(NSDictionary *)dict;
- (instancetype)initTimeFreeListModelWithDict:(NSDictionary *)dict;
@end

