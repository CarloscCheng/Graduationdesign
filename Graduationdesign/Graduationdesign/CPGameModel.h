//
//  CPGameModel.h
//  Graduationdesign
//
//  Created by cheng on 16/4/7.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPGameModel : NSObject

@property (nonatomic, strong) NSDictionary *result;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger code;

+ (instancetype)gameModelWithDict:(NSDictionary *)dict;
- (instancetype)initGameModelWithDict:(NSDictionary *)dict;
@end

@interface CPSortModel : NSObject

@property (nonatomic, strong) NSArray *gallary;
@property (nonatomic, strong) NSArray *newlist;
@property (nonatomic, strong) NSArray *hotlist;
@property (nonatomic, assign) NSInteger next;

+ (instancetype)sortModelWithDict:(NSDictionary *)dict;
- (instancetype)initSortModelWithDict:(NSDictionary *)dict;

+ (instancetype)sortModel;


@end


@interface CPGallaryModel : NSObject

@property (nonatomic, assign) NSInteger hasVideo;
@property (nonatomic, copy) NSString *relate_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *url;

+ (instancetype)gallaryModelWithDict:(NSDictionary *)dict;
- (instancetype)initGallaryModelWithDict:(NSDictionary *)dict;

@end

@interface CPHotListModel : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger price_status;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) NSInteger hasVideo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

+ (instancetype)hotListModelWithDict:(NSDictionary *)dict;
- (instancetype)initHotListModelWithDict:(NSDictionary *)dict;

@end

@interface CPNewListModel : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger price_status;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) NSInteger hasVideo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;


+ (instancetype)newListModelWithDict:(NSDictionary *)dict;
- (instancetype)initNewListModelWithDict:(NSDictionary *)dict;
@end