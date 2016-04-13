//
//  CPUILineLabel.h
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CPLineType) {
    CPLineTypeNone = 0,//没有画线
    CPLineTypeUp = 1,// 上边画线
    CPLineTypeMiddle = 2,//中间画线
    CPLineTypeDown = 3,//下边画线
};

@interface CPUILineLabel : UILabel

@property (assign, nonatomic) CPLineType lineType;
@property (strong, nonatomic) UIColor * lineColor;

@end
