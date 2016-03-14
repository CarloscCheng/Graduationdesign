//
//  NSDate+CPExtension.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-6.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "NSDate+CPExtension.h"
@implementation NSDate (CPExtension)

+ (instancetype)convertDateFromString:(NSString*)dateStr
{
    //转化为星期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *olddate=[formatter dateFromString:dateStr];
 
    //系统差了8个小时时差的秒数
    long long int sec = 8 * 60 * 60;
    
    return [NSDate dateWithTimeInterval:sec sinceDate:olddate];
}

@end
