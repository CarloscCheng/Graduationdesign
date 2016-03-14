//
//  CPCellFrame.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-25.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CPDeviceGroup;
@interface CPCellFrame : NSObject


@property (nonatomic,assign,readonly) CGFloat cellH;

/**
 *  我的设备页面的模型
 */
@property (nonatomic, strong) CPDeviceGroup *cGroup;

@end
