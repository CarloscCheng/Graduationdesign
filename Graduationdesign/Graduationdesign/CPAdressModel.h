//
//  CPAdressModel.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPAdressModel : NSObject


@property (strong,nonatomic) NSArray *Cities;
@property (copy,nonatomic) NSString *State;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
