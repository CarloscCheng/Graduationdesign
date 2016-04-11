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
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation CPNologinHeaderView

+ (instancetype)viewWithNologinView
{
    CPNologinHeaderView *tipsView = [[CPNologinHeaderView alloc] init];
    // 从xib中加载cell
    tipsView = [[[NSBundle mainBundle] loadNibNamed:@"CPNologinHeaderView" owner:nil options:nil] lastObject];
    
    [tipsView.closeBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    return tipsView;
}

#pragma mark 关闭tips提醒
//关闭tips提醒
- (IBAction)closeTips:(id)sender
{
    CPLog(@"close tips");
    if ([self.delegate respondsToSelector:@selector(nologinViewisClickClose:)]) {
        [self.delegate nologinViewisClickClose:self];
    }
}

#pragma mark 点击tios登录
//点击登录tips
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CPLog(@"touch tips");
    if ([self.delegate respondsToSelector:@selector(nologinViewisClicked:)]) {
        [self.delegate nologinViewisClicked:self]; 
    }
}
@end
