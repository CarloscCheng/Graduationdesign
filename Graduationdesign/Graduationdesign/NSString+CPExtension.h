//
//  NSString+CPExtension.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-6.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CPExtension)


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (instancetype)characterToSpelling:(NSString *)str;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
