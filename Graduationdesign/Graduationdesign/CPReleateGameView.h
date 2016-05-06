//
//  CPReleateGameView.h
//  Graduationdesign
//
//  Created by cheng on 16/4/15.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGameCellFrame;

@interface CPReleateGameView : UIView

@property (nonatomic, strong) CPGameCellFrame *gamecellFrame;

+ (instancetype)releateGame;
@end
