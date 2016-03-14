//
//  CPTopMenu.h
//  Graduationdesign
//
//  Created by chengpeng on 16-2-28.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPTopMenu;
@protocol CPTopMenuDelegate <NSObject>

@optional
- (void)topMenuisClicked:(UIView *)view WithArrowStatus:(BOOL)arrowUp;

@end

@interface CPTopMenu : UIView

+ (instancetype)topMenuWithView;

@property (weak,nonatomic) id<CPTopMenuDelegate> delegate;
@end
