//
//  CPALoginView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-26.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPALoginView.h"

@implementation CPALoginView

- (void)layoutSubviews
{
    self.layer.borderWidth = 1;
    //设置view圆角半径
    [self.layer setCornerRadius:10.0];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

@end
