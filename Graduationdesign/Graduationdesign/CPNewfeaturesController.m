//
//  CPNewfeaturesController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-28.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPNewfeaturesController.h"
#import "CPTabBarController.h"

@interface CPNewfeaturesController ()
- (IBAction)btnok;

@end

@implementation CPNewfeaturesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnok
{
    CPLog(@"btnok");
    CPTabBarController *vc = [[CPTabBarController alloc] init];
//    vc.myTabBarBlock(vc);
    
    self.view.window.rootViewController = vc;
}
@end
