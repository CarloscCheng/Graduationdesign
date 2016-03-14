//
//  CPDeviceGroup.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-24.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  一组包含一个cell信息

#import <Foundation/Foundation.h>

@interface CPDeviceGroup : NSObject


//cell标题
@property (copy,nonatomic) NSString *infotitle;
/**
 *  数组中装的都是device详细的list模型,每个cell展开之后里面的具体内容
 */
@property (nonatomic, strong) NSArray *info;
/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
