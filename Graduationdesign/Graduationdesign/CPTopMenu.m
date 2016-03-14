//
//  CPTopMenu.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-28.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPTopMenu.h"

@interface CPTopMenu()

@property (weak,nonatomic) UIImageView *arrowImgV;
/**
 *  默认时候是箭头向下的,即还没有点击这个头部菜单（showUp 为 0）
 */
@property (assign,nonatomic,getter = isShowUp) BOOL showUp;

@end

@implementation CPTopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CPLog(@"top menu init");
        //在这里加载frame定制控件没用
    }
    return self;
}

//自定义我的设备的top
+ (instancetype)topMenuWithView
{
    CPTopMenu *topView = [[CPTopMenu alloc] init];
    topView.frame = CGRectMake(0, 0, 80, 30);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    label.font = MYITTMFONTSIZE;
    label.text = @"全部设备";
    
    UIImageView *imagview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"std_home_icon_drop_down_arrow"]];
    topView.arrowImgV = imagview;
    label.center = topView.center;
    imagview.bounds = topView.bounds;
    imagview.frame = CGRectMake(65, 12, 8, 5);
    topView.contentMode = UIViewContentModeCenter;
    [topView addSubview:imagview];
    [topView addSubview:label];
    
    return topView;
}


- (void)layoutSubviews
{
    CPLog(@"layoutsub");
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CPLog(@"点击了头部");
    if (!_showUp) {
         self.arrowImgV.transform = CGAffineTransformMakeRotation(M_PI);
        _showUp = YES;
    }else
    {
        self.arrowImgV.transform = CGAffineTransformMakeRotation(0);
        _showUp = NO;
    }
    
    //头部被点击通知显示菜单
    if ([self.delegate respondsToSelector:@selector(topMenuisClicked: WithArrowStatus:)]) {
        [self.delegate topMenuisClicked:self WithArrowStatus:_showUp];
    }
}


@end
