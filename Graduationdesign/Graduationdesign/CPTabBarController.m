//
//  CPTabBarController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPNewfeaturesController.h"

@interface CPTabBarController ()
@property (weak, nonatomic) IBOutlet UITabBar *tarBar;

@end

@implementation CPTabBarController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CPLog(@"tabbar didload");
    NSLog(@"=====");
    __block CPTabBarController *tabc = self;
    [self setMyTabBarBlock:^(CPTabBarController *tabbar) {
        tabbar.viewControllers = tabc.tabBar.subviews;
    }];
}



- (void)viewDidLayoutSubviews
{
    CPLog(@"=====did aooear");

}



//实现tabbar切换的动画效果
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//    CATransition* animation = [CATransition animation];
//    [animation setDuration:0.01f];
//    /* The name of the transition. Current legal transition types include
//     * `fade', `moveIn', `push' and `reveal'. Defaults to `fade'. */
////    [animation setType:kCATransitionFade];
////    [animation setType:kCATransitionReveal];
//    [animation setType:kCATransitionMoveIn];
////    [animation setType:kCATransitionPush];
//    
//    /* An optional subtype for the transition. E.g. used to specify the
//     * transition direction for motion-based transitions, in which case
//     * the legal values are `fromLeft', `fromRight', `fromTop' and
//     * `fromBottom'. */
//    [animation setSubtype:kCATransitionFromBottom]
//    ;
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [[self.view layer] addAnimation:animation forKey:@"switchView"];
//}


@end
