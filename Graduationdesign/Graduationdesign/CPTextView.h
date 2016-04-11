//
//  CPTextView.h
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTextView : UITextView

/**
 *  Placeholder文字
 */
@property (nonatomic, copy) NSString *myPlaceholder;
/**
 *  Placeholder文字颜色
 */
@property(nonatomic,strong) UIColor *myPlaceholderColor;
@end
