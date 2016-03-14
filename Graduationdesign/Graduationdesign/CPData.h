//
//  CPData.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  这是在个人资料中的资料模型

#import <Foundation/Foundation.h>

@interface CPData : NSObject

/**
 *  标题
 */
@property (nonatomic, copy) NSString *detail;
/**
 *  详细
 */
@property (nonatomic, copy) NSString *subdetail;
/**
 *  图片
 */
@property (nonatomic, copy) NSString *img;

/**
 *  判断当前属性是否为可以编辑属性
 */
@property (assign,nonatomic,getter = isSelected) BOOL selected;

+ (instancetype)dataWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
