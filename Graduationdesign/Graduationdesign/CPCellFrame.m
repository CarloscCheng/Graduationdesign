//
//  CPCellFrame.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  每个cell的frame模型

#import "CPCellFrame.h"
#import "CPDeviceGroup.h"

@implementation CPCellFrame

//设置frame
- (void)setCGroup:(CPDeviceGroup *)cGroup
{
    _cGroup = cGroup;
    if ([cGroup.infotitle isEqualToString:@"生活信息"]) {
        _cellH = 110;
    }else if([cGroup.infotitle isEqualToString:@"体验馆"]){
        _cellH = 80;
    }else if([cGroup.infotitle isEqualToString:@"智能设备列表"]){
        _cellH = 0;
    }else if([cGroup.infotitle isEqualToString:@"智能家庭论坛"]){
        _cellH = 80;
    }
} 

@end
