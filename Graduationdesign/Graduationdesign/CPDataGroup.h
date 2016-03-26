//
//  CPDataGroup.h
//  Graduationdesign
//
//  Created by cheng on 16/3/24.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDataGroup : NSObject
/**
 *  电话号码(唯一标识)
 */
@property (copy,nonatomic) NSString *phonenumber;

/**
 *  用户登录密码
 */
@property (copy,nonatomic) NSString *password;

/**
 *  除了电话号码外其他的信息
 */
@property (nonatomic, strong) NSArray *otherdata;


+ (instancetype)groupWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
