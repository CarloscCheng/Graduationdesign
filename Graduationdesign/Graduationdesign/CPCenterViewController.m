//
//  CPCenterViewController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPCenterViewController.h"
#import "CPDataViewController.h"
#import "CPLoginViewController.h"
#import "CPCenterView.h"
#import "CPHeaderView.h"
#import "CPDeviceViewController.h"
#import "CPNologinHeaderView.h"

//cell头脚间距
#define FOOTERHEIGHT 5
#define HEADERHEIGHT 5

@interface CPCenterViewController ()<CPCenterViewDelegate,UITableViewDelegate,CPDataViewControllerDelegate,CPLoginViewControllerDelegate>
/**
 *  头像所在view
 */
@property (strong, nonatomic) IBOutlet CPCenterView *centerView;

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userimg;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *username;
/**
 *  几个智能设备
 */
@property (weak, nonatomic) IBOutlet UILabel *numdevice;

/**
 *  当前控制器为centerview
 */
@property (weak, nonatomic) IBOutlet UIView *conView;

/**
 *  底部footer的高度
 */
@property (assign,nonatomic) CGFloat footerH;


/**
 *  headerView
 */
@property (strong,nonatomic) CPHeaderView *headerView;
@property (strong,nonatomic) CPDeviceViewController *deviceVC;

@end

@implementation CPCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置containerview里的tableview属性为不滑动
    [[self.conView.subviews lastObject] setScrollEnabled:NO];
    [[self.conView.subviews lastObject] setDelegate:self];
    [[self.conView.subviews lastObject] setContentInset:UIEdgeInsetsMake(HEADERHEIGHT, 0, 0, 0)];
    
    //设置当前控制器为centerview代理
    self.centerView.delegate = self;
    

    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"个人中心"];
    
#pragma mark（完成每次如果上次推出app的时候是登录状态自动刷新界面数据）
    //判断用户退出app的状态
    CPAppDelegate *appde = [[UIApplication sharedApplication] delegate];
//    CPLog(@"app login = %hhd",appde.iscCloseLogined);
    if(appde.iscCloseLogined){
        CPLog(@"自动登录了");
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         NSDictionary *login = [userDefaults objectForKey:@"lastlogin"];
        
        self.userimg.image = [UIImage imageNamed:login[@"userimg"]];
        self.username.text = login[@"username"];
        self.numdevice.text = login[@"numdevice"];
        _logined = [login[@"curStatus"] intValue];

    }
}


#pragma mark 头像view触摸代理事件
- (void)centerViewisTouched:(UIView *)Tview
{
    NSLog(@"is touched");
    //增加一个bool变量判断当前是否登录状态
    if (!self.isLogined) {
        //进入登录界面
        [self performSegueWithIdentifier:@"c2login" sender:nil];
    }else{
        //进入个人资料界面
        [self performSegueWithIdentifier:@"c2cdata" sender:nil];
    }
}

#warning 添加了segue一定要在这判断
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取目标控制起的vc类型代理
    NSLog(@"sender = %@---indetifier = %@",sender, segue.identifier);
    if ([segue.identifier isEqualToString:@"c2cdata"]) {
        
        CPDataViewController *datavc = segue.destinationViewController;
        //设置个人资料控制器代理为个人中心控制器
        datavc.delegate = self;
    }else if([segue.identifier isEqualToString:@"c2login"]){
        CPLoginViewController *loginvc = segue.destinationViewController;
        //如果点击进入的是登录界面则设置登录vc代理为当前vc
        loginvc.delegate = self;
    }

}
#pragma mark 个人资料控制器注销操作通知代理方法实现
- (void)dataViewLogoutisClicked:(CPDataViewController *)dataView
{
    NSLog(@"已经注销，回到个人中心控制器");
    //注销后设置默认用户图片
    self.userimg.image = [UIImage imageNamed:@"user_not_logged"];
    //用户昵称
    self.username.text = @"点击登录";
#warning 设备数应该为获取的网络中的设备个数
    //设备数
    self.numdevice.text = @"0个智能设备";
    
    //如果再次点击头像，应该跳转到登录、
    //设置bool为没有登录状态
    _logined = NO;
    
    CPHeaderView *headerview = [[CPHeaderView alloc] init];
    
    [headerview setAppLoginStatus:^BOOL{
        return _logined;
    }];
    
    //注销清楚信息
    //获取userdefault单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //存储到userfalut];
    [userDefaults removeObjectForKey:@"lastlogin"];
    [userDefaults synchronize];
    
    //调用view的block方法告诉我的设备用户为注销状态

}
#pragma mark 登录成功的代理方法实现
#warning 登录成功后的数据是自己模拟的，显示需求是要从网络中获取数据
- (void)loginViewControllerisLogined:(CPLoginViewController *)loginvc
{
    NSLog(@"个人中心收到登录成功通知");
    //用户已经登录
    _logined = YES;
    
    //调用view的block方法告诉我的设备用户为登录状态
    CPHeaderView *headerview = [[CPHeaderView alloc] init];

    [headerview setAppLoginStatus:^BOOL{
        return _logined;
    }];
    
    //设置登录成功后的用户数据
    self.userimg.image = [UIImage imageNamed:@"icon.jpg"];
    [self.userimg setAccessibilityIdentifier:@"icon.jpg"];
    self.username.text = @"程某人___";
    self.numdevice.text = @"10个智能设备";
    
#pragma mark （测试）登录成功存储登录信息
    
    //获取用户输入的信息
    NSString *userimg = [self.userimg accessibilityIdentifier];
    NSString *username = self.username.text;
    NSString *numdevice = self.numdevice.text;
    NSString *curStatus = @"1" ;
    

    //获取userdefault单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginDict = [NSDictionary dictionary];
    loginDict = @{@"userimg": userimg,@"username": username,@"numdevice": numdevice,@"curStatus": curStatus};
    
    //存储到userfalut];
    [userDefaults setObject:loginDict forKey:@"lastlogin"];
    [userDefaults synchronize];

    
    //设置的通知，名字叫helloname，object是一些参数，有时候发通知可能要随带的参数
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CPCenterViewController" object:nil];
    
}

#pragma mark tableview代理
//设置header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERHEIGHT;
}

//设置footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FOOTERHEIGHT;
}

@end
