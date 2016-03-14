//
//  ProvinceCityArea.m
//  yizhong
//
//  Created by tk on 16/1/6.
//  Copyright © 2016年 feibo. All rights reserved.
//

#import "ProvinceCityArea.h"

@implementation ProvinceCityArea

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrayCitys = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation Town

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrayAreas = [[NSMutableArray alloc] init];
    }
    return self;
}

@end