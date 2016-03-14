//
//  NSString+CPExtension.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-6.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "NSString+CPExtension.h"

@implementation NSString (CPExtension)


/**
 *  根据date获取星期
 *
 *  @param inputDate 输入date
 *
 *  @return 返回星期字符串
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

/**
 *  汉字转拼音
 *
 *  @param 中文
 *
 *  @return 返回转换后的拼音
 */
+ (instancetype)characterToSpelling:(NSString *)str
{
    NSString *spellStr = [[NSString alloc] init];
    //汉字转拼音
    if ([str length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            CPLog(@"pinyin: %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            CPLog(@"pinyin: %@", ms);
            //去除空格
            NSString *str = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
            spellStr = [str stringByReplacingOccurrencesOfString:@"shi" withString:@""];
            
        }
    }
    return spellStr;
}


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
