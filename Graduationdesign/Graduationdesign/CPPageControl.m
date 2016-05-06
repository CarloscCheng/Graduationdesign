//
//  CPPageControl.m
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPPageControl.h"

@implementation CPPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}

//- (void)setCurrentPage:(NSInteger)currentPage
//{
//    [super setCurrentPage:currentPage];
//    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
//        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
//        CGSize size;
//        size.height = 12;
//        size.width = 12;
//        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
//                                     size.width,size.height)];
//        
//        if (subviewIndex == currentPage) {
//            [subview setImage:[UIImage imageNamed:@"home_gallary_cur_page_dot"]];
//        } else {
//            [subview setImage:[UIImage imageNamed:@"home_gallary_page_dot"]];
//        }
//    }
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    activeImage = [UIImage imageNamed:@"home_gallary_cur_page_dot"];
    inactiveImage = [UIImage imageNamed:@"home_gallary_page_dot"];
    
    return self;
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

-(void)updateDots
{
    for (int i=0; i<[self.subviews count]; i++) {        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 7;     //自定义圆点的大小
        size.width = 7;      //自定义圆点的大小
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
        if (i==self.currentPage)dot.image=activeImage;
        else dot.image=inactiveImage;
    }
    
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    [self updateDots];
    
}


@end
