//
//  CPAddressView.h
//  Graduationdesign
//
//  Created by chengpeng on 16-3-3.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPAddressView;
@class CPAdressModel;

@protocol CPAddressViewDelegate <NSObject>

@optional
- (void)addressViewCityNameIsChoosed:(CPAdressModel *)addressmodel;
@end

@interface CPAddressView : UIView


@property (weak,nonatomic) id<CPAddressViewDelegate> delegate;

@end
