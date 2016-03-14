//
//  NSDictionary+CPDictToPlist.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-1.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CPDictToPlist)
/**
 *  把字典存储到plist文件中
 *
 *  @param filePath  文件路径，nil写入到默认路径中
 *  @param plistname 要保存的plist文件名
 */
- (void)dictToPlistWithPlistName:(NSString *)plistname;
+ (id)dictFromPlistWithPlistName:(NSString *)plistname;
@end
