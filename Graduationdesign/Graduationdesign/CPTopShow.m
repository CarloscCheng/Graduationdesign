//
//  CPTopShow.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-28.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPTopShow.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@interface CPTopShow()

@property (weak,nonatomic) UIView *contentView;

/**
 *  最底部的遮盖 ：屏蔽除菜单以外控件的事件
 */
@property (nonatomic, weak) UIButton *cover;
@property (weak,nonatomic) UIView *tview;

@end

@implementation CPTopShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /** 添加菜单内部的2个子控件 **/
        // 添加一个遮盖按钮
//        UIButton *cover = [[UIButton alloc] init];
//        cover.backgroundColor = [UIColor clearColor];
//        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:cover];
//        self.cover = cover;
        UIView *tv = [[UIView alloc] init];
        tv.backgroundColor = [UIColor clearColor];
        [self addSubview:tv];
        self.tview = tv;
        
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init]) {
        self.contentView = contentView;
    }
    return self;
}

+ (instancetype)topMenuWithContentView:(UIView *)contentView
{
    return [[self alloc] initWithContentView:contentView];
}

#pragma mark - 内部方法
- (void)coverClick
{
    [self dismiss];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //加载蒙盖
    self.tview.frame = CGRectMake(0, 64, 320, self.bounds.size.height);
}


#pragma mark - 公共方法
- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        self.tview.backgroundColor = [UIColor blackColor];
        self.tview.alpha = 0.3;
    } else {
        self.tview.backgroundColor = [UIColor blueColor];
        self.tview.alpha = 1.0;
    }
}


#pragma mark 代理
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)showInRect:(CGRect)rect
{
    // 添加菜单整体到窗口身上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    

    // 设置容器里面内容的frame
    CGFloat topMargin = 12;
    CGFloat leftMargin = 5;
    CGFloat rightMargin = 5;
    CGFloat bottomMargin = 8;

    
    self.contentView.y = topMargin;
    self.contentView.x = leftMargin;
    self.contentView.width = leftMargin - rightMargin;
    self.contentView.height = topMargin - bottomMargin;
    
    [self addSubview:self.contentView];
    
}


@end
