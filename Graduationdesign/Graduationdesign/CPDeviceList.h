//
//  CPDeviceList.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  我的设备这一页的每个cell下的详细信息

#import <Foundation/Foundation.h>

@interface CPDeviceList : NSObject

//智能设备列表
@property (copy,nonatomic) NSString *deviceicon;
@property (copy,nonatomic) NSString *devicename;

//体验馆
@property (copy,nonatomic) NSString *icon;
@property (copy,nonatomic) NSString *name;

//智能家庭论坛
@property (copy,nonatomic) NSString *blogicon;
@property (copy,nonatomic) NSString *blogtitle;
@property (copy,nonatomic) NSString *blogdetail;


+ (instancetype)infolistWithDict:(NSDictionary *)dict;
- (instancetype)initInfoWithDict:(NSDictionary *)dict;

@end
