//
//  CPCitiesModel.h
//  test
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCitiesModel : NSObject



@property (copy,nonatomic) NSString *Areaname;
@property (copy,nonatomic) NSArray *Areas;



+ (instancetype)cityWithDict:(NSDictionary *)dict;
- (instancetype)initCityWithDict:(NSDictionary *)dict;

@end
