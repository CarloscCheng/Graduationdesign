//
//  CPGameInfo.h
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CPGameResult,CPGameDetail,CPGameSharetpl,CPGameShareTplWxhy,CPGameShareTplWxpyq,CPShareTplWb,CPGameVideo,CPGameVideoShow,CPGameVideoList,CPGameStrategy,CPGameStrategyList,CPGameRelategame,CPGameGallary,CPGameRelatenews;

@interface CPGameInfo : NSObject

@property (nonatomic, strong) CPGameResult *result;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger code;


- (instancetype)initGameInfoWithDict:(NSDictionary *)dict;
+ (instancetype)gameInfoWithDict:(NSDictionary *)dict;
 
@end

@interface CPGameResult : NSObject

@property (nonatomic, strong) CPGameDetail *detail; 

@property (nonatomic, strong) NSArray<CPGameRelategame *> *relateGame;

@property (nonatomic, strong) NSArray<CPGameRelatenews *> *relateNews;

@property (nonatomic, strong) NSArray<CPGameGallary *> *gallary;

@property (nonatomic, strong) CPGameSharetpl *shareTpl;

@property (nonatomic, strong) CPGameStrategy *strategy;

@property (nonatomic, strong) CPGameVideo *video;

- (instancetype)initGameResultWithDict:(NSDictionary *)dict;
+ (instancetype)gameResultWithDict:(NSDictionary *)dict;
@end

@interface CPGameDetail : NSObject
 
@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *short_link;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, copy) NSString *abstract;

@property (nonatomic, assign) BOOL inhouseInfo;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *size;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *downNum;

@property (nonatomic, copy) NSString *developer;

@property (nonatomic, copy) NSString *downloadUrl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *updateTime;


- (instancetype)initGameDetailWithDict:(NSDictionary *)dict;
+ (instancetype)gameDetailWithDict:(NSDictionary *)dict;

@end

@interface CPGameSharetpl : NSObject

@property (nonatomic, strong) CPGameShareTplWxhy *wxhy;

@property (nonatomic, strong) CPGameShareTplWxpyq *wxpyq;

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) CPShareTplWb *wb;

@end

@interface CPGameShareTplWxhy : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@end

@interface CPGameShareTplWxpyq : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@end

@interface CPShareTplWb : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

@end

@interface CPGameVideo : NSObject

@property (nonatomic, strong) CPGameVideoShow *show;

@property (nonatomic, strong) NSArray<CPGameVideoList *> *list;


- (instancetype)initGameVideoWithDict:(NSDictionary *)dict;
+ (instancetype)gameVideoWithDict:(NSDictionary *)dict;
@end

@interface CPGameVideoShow : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *img;

- (instancetype)initGameVideoShowWithDict:(NSDictionary *)dict;
+ (instancetype)gameVideoShowWithDict:(NSDictionary *)dict;

@end

@interface CPGameVideoList : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *created;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *img;

- (instancetype)initGameVideoListWithDict:(NSDictionary *)dict;
+ (instancetype)gameVideoListWithDict:(NSDictionary *)dict;

@end


@interface CPGameStrategy : NSObject

@property (nonatomic, assign) NSInteger more;

@property (nonatomic, strong) NSArray<CPGameStrategyList *> *list;

- (instancetype)initGameStrategyWithDict:(NSDictionary *)dict;
+ (instancetype)gameStrategyWithDict:(NSDictionary *)dict;

@end

@interface CPGameStrategyList : NSObject 

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *updateNum;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger isDir;

- (instancetype)initGameStrategyListWithDict:(NSDictionary *)dict;
+ (instancetype)gameStrategyListWithDict:(NSDictionary *)dict;

@end


@interface CPGameRelategame : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *platform;

- (instancetype)initGameRelategameWithDict:(NSDictionary *)dict;
+ (instancetype)relategameWithDict:(NSDictionary *)dict;

@end

@interface CPGameGallary : NSObject

@property (nonatomic, copy) NSString *src;

@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) NSString *height;

- (instancetype)initGameGallaryWithDict:(NSDictionary *)dict;
+ (instancetype)gallaryWithDict:(NSDictionary *)dict;

@end

@interface CPGameRelatenews : NSObject

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *url;

- (instancetype)initGameRelatenewsWithDict:(NSDictionary *)dict;
+ (instancetype)gameRelatenewsWithDict:(NSDictionary *)dict;

@end

