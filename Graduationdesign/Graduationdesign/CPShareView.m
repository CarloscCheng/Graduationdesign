//
//  CPShareView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-9.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPShareView.h"
#import "CPShareDetailView.h"

@interface CPShareView()

//蒙板
@property (weak,nonatomic) UIButton *mybutton;

//带有分享按钮的view
@property (weak,nonatomic) CPShareDetailView *sharedetailView;
@end


@implementation CPShareView

- (instancetype)init
{
    if (self = [super init]) {
        //添加一个蒙板
        UIButton *mybutton = [[UIButton alloc] init];
        mybutton.backgroundColor = [UIColor lightGrayColor];
        mybutton.alpha = 0.5;
        self.mybutton = mybutton;
        [self addSubview:mybutton];
        
        //添加点击事件
        [mybutton addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
        
        CPShareDetailView *sharedetailView = [[CPShareDetailView alloc] init];
        self.sharedetailView = sharedetailView;
        [self addSubview:sharedetailView];
    }
    return self;

}

- (void)layoutSubviews
{
    self.frame = self.window.frame;
//    self.backgroundColor = [UIColor redColor];
    self.sharedetailView.frame = CGRectMake(0, CPWINDOWHEIGHT - 90, CPWINDOWWIDTH, 90);
    self.mybutton.frame = self.window.frame;
}

- (void)cancelShare
{
    CPLog(@"取消分享");
    [self removeFromSuperview];
}
@end
