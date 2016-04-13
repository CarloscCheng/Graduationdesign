//
//  CPUILineLabel.m
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPUILineLabel.h"

@implementation CPUILineLabel

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGSize textSize = [NSString sizeWithText:self.text font:self.font maxSize:CPMAXSIZE];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect = CGRectZero;
    CGFloat origin_x = 0.0;
    CGFloat origin_y = 0.0;
    
    if ([self textAlignment] == NSTextAlignmentRight) {
        
        origin_x = rect.size.width - strikeWidth;
        
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        
        origin_x = (rect.size.width - strikeWidth)/2 ;
        
    } else {
        
        origin_x = 0;
    }
    
    
    if (self.lineType == CPLineTypeUp) {
        
        origin_y =  2;
    }
    
    if (self.lineType == CPLineTypeMiddle) {
        
        origin_y =  rect.size.height/2;
    }
    
    if (self.lineType == CPLineTypeDown) {//下画线
        
        origin_y = rect.size.height - 2;
    }
    
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, 1);
    
    if (self.lineType != CPLineTypeNone) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        CGColorRef color = [self.lineColor CGColor];
        int numComponents = (int)CGColorGetNumberOfComponents(color);
        
        if(numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            
            CGContextSetRGBFillColor(context, R, G, B, 1.0);
            
        }
        CGContextFillRect(context, lineRect);
    }
}

- (void)dealloc{
    self.lineColor = nil;
}
@end
