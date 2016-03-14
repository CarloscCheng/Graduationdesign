//
//  CPAreaIDModel.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-5.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//
//  区域areaid详细信息model,详细区域信息见http://www.heweather.com/documents/cn-city-list

#import <Foundation/Foundation.h>

@interface CPAreaIDModel : NSObject

@property (strong,nonatomic) NSDictionary *areaidDict;
/**
 *  城市名称
 */
@property (copy,nonatomic) NSString *NAMECN;
@property (copy,nonatomic) NSString *NAMEEN;
/**
 *  城市areaid
 */
@property (copy,nonatomic) NSString *AREAID;
/**
 *  省份
 */
@property (copy,nonatomic) NSString *PROVCN;
@property (copy,nonatomic) NSString *PROCEN;
/**
 *  地区
 */
@property (copy,nonatomic) NSString *DISTRICTEN;
@property (copy,nonatomic) NSString *DISTRICTCN;



/**
 *  初始化模型
 *
 *  @param cityname 需要查找的areid的城市
 *
 *  @return 返回areaid模型
 */
+ (instancetype)areaIdWithStr:(NSString *)cityname;
- (instancetype)initAreaIdWithStr:(NSString *)cityname;
@end
