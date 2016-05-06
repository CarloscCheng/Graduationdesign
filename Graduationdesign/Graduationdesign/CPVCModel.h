//
//  CPVCModel.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//  这是gallary点击跳转到的控制器的模型

#import <Foundation/Foundation.h>

@interface CPVCGameModel : NSObject

@property (nonatomic, strong) NSDictionary *result;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;

+ (instancetype)vcGameModelWithDict:(NSDictionary *)dict;
- (instancetype)initVcGameModelWithDict:(NSDictionary *)dict;
@end


@interface CPVCTopModel : NSObject

@property (nonatomic, copy) NSString *share_link;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) NSInteger has_more;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger next;
/**
 *  详细游戏列表
 */
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, copy) NSString *gameCount;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *video;

+ (instancetype)vcTopModelWithDict:(NSDictionary *)dict;
- (instancetype)initVcTopModelWithDict:(NSDictionary *)dict;
@end



@interface CPVCGameList : NSObject 

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic, copy) NSString *pre_price;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *crack;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *name; 


+ (instancetype)vcGameListWithDict:(NSDictionary *)dict;
- (instancetype)initVcGameListWithDict:(NSDictionary *)dict;
@end


