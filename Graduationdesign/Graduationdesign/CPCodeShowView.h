//
//  CPCodeShowView.h
//  Graduationdesign
//
//  Created by cheng on 16/3/19.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPCodeShowViewDelegate <NSObject>

@optional
- (void)codeShowViewWithKeyBoardHeight:(float)height withShowKeyBoard:(BOOL)show;

@end

@interface CPCodeShowView : UIView


@property (weak, nonatomic) id<CPCodeShowViewDelegate> delegate;

+ (instancetype)codeviewCreate;
@end
