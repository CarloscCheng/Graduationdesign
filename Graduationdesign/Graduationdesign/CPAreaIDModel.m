//
//  CPAreaIDModel.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-5.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPAreaIDModel.h"

@implementation CPAreaIDModel

- (instancetype)initAreaIdWithStr:(NSString *)cityname
{
    if (self = [super init]) {
        self.NAMECN = self.areaidDict[cityname][@"NAMECN"];
        self.NAMEEN = self.areaidDict[cityname][@"NAMEEN"];
        self.AREAID = self.areaidDict[cityname][@"AREAID"];
        self.PROVCN = self.areaidDict[cityname][@"PROVCN"];
        self.PROCEN = self.areaidDict[cityname][@"PROCEN"];
        self.DISTRICTEN = self.areaidDict[cityname][@"DISTRICTEN"];
        self.DISTRICTCN = self.areaidDict[cityname][@"DISTRICTCN"];
    }
    return self;
}

+ (instancetype)areaIdWithStr:(NSString *)cityname
{
    return [[self alloc] initAreaIdWithStr:cityname];
}

- (NSDictionary *)areaidDict
{
    if (_areaidDict == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AreaID" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        _areaidDict = dict;
    }
    return _areaidDict;
}


@end
