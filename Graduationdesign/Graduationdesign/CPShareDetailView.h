//
//  CPShareDetailView.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-9.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//  放置分享按钮的view

#import <UIKit/UIKit.h>

@interface CPShareDetailView : UIView

+ (instancetype)shareDetailViewCreate;

//获取分享图片block
@property (copy, nonatomic) void (^shareImageBlock)(UIImage *);

- (void)transmitImage:(UIImage *)img;
@end
