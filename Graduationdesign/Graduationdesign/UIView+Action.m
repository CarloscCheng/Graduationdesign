//
//  UIView+Action.m
//  Ballache
//
//  Created by Linxp on 14-7-8.
//  Copyright (c) 2014年 Feibo. All rights reserved.
//

#import "UIView+Action.h"

@implementation UIView (Action)

- (void)addSubviews:(NSArray *)subViews
{
    for (UIView *v in subViews) {
        NSAssert([v isKindOfClass:[UIView class]], @"the elements must be a view!");
        [self addSubview:v];
    }
}

- (void)clearBackground
{
    [self setBackgroundColor:[UIColor clearColor]];
}

@end

@implementation UIView (Size)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point;
{
    CGRect rect = self.frame;
    
    rect.origin = point;
    self.frame = rect;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    
    rect.size = size;
    self.frame = rect;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    [self setOrigin:CGPointMake(x, self.y)];
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    [self setOrigin:CGPointMake(self.x, y)];
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    [self setSize:CGSizeMake(width, self.height)];
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    [self setSize:CGSizeMake(self.width, height)];
}

@end