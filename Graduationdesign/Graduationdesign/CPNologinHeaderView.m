//
//  CPNologinHeaderView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-27.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPNologinHeaderView.h"


@interface CPNologinHeaderView()

//用户没有登录点击叉关闭提醒
- (IBAction)closeTips:(id)sender;

@end

@implementation CPNologinHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        CPNologinHeaderView *view = [[CPNologinHeaderView alloc] init];
//        self.nologinview = view;
    }
    return self;
}

+ (instancetype)viewWithNologinView
{
    // 从xib中加载cell
    CPNologinHeaderView *tipsView = [[CPNologinHeaderView alloc] init];
    tipsView = [[[NSBundle mainBundle] loadNibNamed:@"CPNologinHeaderView" owner:nil options:nil] lastObject];
    return tipsView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"tips view is layout");
    
    
}

- (IBAction)closeTips:(id)sender
{
    NSLog(@"close tips");
//    [self didMoveToSuperview];
}

//点击登录tips
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch tips");
    if ([self.delegate respondsToSelector:@selector(tipsViewisClicked:)]) {
        [self.delegate tipsViewisClicked:self];
    }
}
@end
