//
//  CPAuthcodeView.h
//  Graduationdesign
//
//  Created by cheng on 16/3/18.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAuthcodeView : UIView


@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

//刷新验证码
- (void)refreshAuthcode;
@end
