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
    CPLog(@"CPTabBarController viewDidLoad%@",self.viewControllers);
}

@end
