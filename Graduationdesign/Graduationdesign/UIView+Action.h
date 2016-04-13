//
//  UIView+Action.h
//  Ballache
//
//  Created by Linxp on 14-7-8.
//  Copyright (c) 2014年 Feibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Action)

- (void)addSubviews:(NSArray *)subViews;
- (void)clearBackground;

@end

@interface UIView (Size)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@end