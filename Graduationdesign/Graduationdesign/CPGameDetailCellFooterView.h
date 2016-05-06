//
//  CPGameDetailCellFooterView.h
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameDetailCellFooterView;

@protocol CPGameDetailCellFooterViewDelegate <NSObject>

@optional
- (void)gameDetailCellFooterViewShowOrHideButtonClick:(CPGameDetailCellFooterView *)view show:(BOOL)show;

@end

@interface CPGameDetailCellFooterView : UIView


+ (instancetype)gameDetailCellFooterView;

@property (nonatomic, assign) NSUInteger cellSection;
@property (nonatomic, weak) id<CPGameDetailCellFooterViewDelegate> delegate;
@end
