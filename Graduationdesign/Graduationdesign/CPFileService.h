//
//  CPFileService.h
//  Graduationdesign
//
//  Created by cheng on 16/4/22.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPFileService : NSObject

+ (float)fileSizeAtPath:(NSString *)path;
+ (float)folderSizeAtPath:(NSString *)path;
+ (void)clearCache:(NSString *)path;

@end
