//
//  CPGameDetailCellFooterView.m
//  Graduationdesign
//
//  Created by cheng on 16/4/14.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameDetailCellFooterView.h"

@interface CPGameDetailCellFooterView()

@property (nonatomic, strong) UIButton *showhideButton;

@property (nonatomic, strong) UIImageView *imageView;

@end

static BOOL show;
static NSString *buttonText = @"展开";
static int plus_minus = 1;

@implementation CPGameDetailCellFooterView

- (instancetype)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
        
        self.showhideButton = ({
            CGSize btSize = [NSString sizeWithText:@"收起" font:[UIFont systemFontOfSize:10.0] maxSize:CPMAXSIZE];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btSize.width + 10, self.height)];
//            button.backgroundColor = [UIColor redColor];
            button.centerY = view.centerY;
//            button.x = view.frame.size.width - button.width - 8;
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:10.0];
            
            //保存上次的状态防止刷新一直显示固定数值
            [button setTitle:buttonText forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showorHideAction) forControlEvents:UIControlEventTouchUpInside];
            button;
        }); 
    
        self.imageView =({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.showhideButton.x + self.showhideButton.width - 3, 0, 12, 12)];
//            imageView.backgroundColor = [UIColor redColor];
            imageView.centerY = view.centerY;
            imageView.transform = CGAffineTransformMakeRotation(plus_minus * -M_PI_2);
            imageView.image = [UIImage imageNamed:@"back_pressed"];
            imageView;
        });
        view.width = self.imageView.width + 3 + self.showhideButton.width;
        view.x = self.width - view.width;
//        view.backgroundColor = [UIColor blueColor];
        
        [view addSubviews:@[self.showhideButton,
                            self.imageView]];
        
        [self addSubview:view];
    }
    return self;
}

+ (instancetype)gameDetailCellFooterView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
}


- (void)setCellSection:(NSUInteger)cellSection
{
    _cellSection = cellSection;
    if (cellSection != 1) {
        //内容概要
        self.height = 0;
    }
}

#pragma mark 点击展开关闭
- (void)showorHideAction {
    show = !show;

    if (!show) {
        [self.showhideButton setTitle:@"展开" forState:UIControlStateNormal]; 
        self.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        buttonText = @"展开";
        plus_minus = 1;
    }else {
        [self.showhideButton setTitle:@"收起" forState:UIControlStateNormal];
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        buttonText = @"收起";
        plus_minus = -1;
    }
 
    if ([self.delegate respondsToSelector:@selector(gameDetailCellFooterViewShowOrHideButtonClick:show:)]) {
    [self.delegate gameDetailCellFooterViewShowOrHideButtonClick:self show:show];
    CPLog(@"展开关闭%d",show);
    } 

}

@end
