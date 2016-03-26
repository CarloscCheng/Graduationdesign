//
//  ViewToast.h
//  yizhong
//
//  Created by 张超 on 15/8/26.
//  Copyright (c) 2015年 feibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : NSObject

+ (void) toast:(NSString*)msg;
+ (void) toast:(NSString*)msg duration:(NSTimeInterval)duration;

@end
