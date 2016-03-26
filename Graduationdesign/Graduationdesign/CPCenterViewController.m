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
#import "CPData.h"

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
/**
 *  devicevc
 */
@property (strong,nonatomic) CPDeviceViewController *deviceVC;
/**
 *  登录的手机号
 */
@property (copy, nonatomic) NSString *loginPhonenumber;
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
    
    //头像圆角
    [self.userimg.layer setCornerRadius:CGRectGetHeight([self.userimg bounds]) / 2];
    self.userimg.layer.masksToBounds = YES;
    
    //判断用户退出app的状态
    CPAppDelegate *appde = [[UIApplication sharedApplication] delegate];
    if(appde.iscCloseLogined){
        CPLog(@"已经登录过了");
        [self refreshCenterViewData];
    }
}

#pragma mark 头像view触摸代理事件
- (void)centerViewisTouched:(UIView *)Tview
{
    CPLog(@"is touched");
    //增加一个bool变量判断当前是否登录状态
    if (!self.isLogined) {
        //进入登录界面
        [self performSegueWithIdentifier:@"c2login" sender:nil];
    }else{
        //进入个人资料界面
        [self performSegueWithIdentifier:@"c2cdata" sender:nil];
    }
}

#pragma mark 添加segue进行判断
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取目标控制起的vc类型代理
    if ([segue.identifier isEqualToString:@"c2cdata"]) {
        //跳转到个人资料界面
        CPDataViewController *datavc = segue.destinationViewController;
        datavc.delegate = self;
        [datavc transmitPhone:self.loginPhonenumber];
        CPLog(@"用户手机号:%@",self.loginPhonenumber);
    }else if([segue.identifier isEqualToString:@"c2login"]){
        //跳转到登录界面
        CPLoginViewController *loginvc = segue.destinationViewController;
        loginvc.delegate = self;
    }

}
#pragma mark- 个人资料控制器代理方法实现
#pragma mark 注销
- (void)dataViewLogoutisClicked:(CPDataViewController *)dataView
{
    //注销后设置界面默认数据
    self.userimg.image = [UIImage imageNamed:@"user_not_logged"];
    self.username.text = @"点击登录";
    self.numdevice.text = @"0个智能设备";
    
    //设置bool为没有登录状态
    _logined = NO;
    
    CPHeaderView *headerview = [[CPHeaderView alloc] init];
    [headerview setAppLoginStatus:^BOOL{
        return _logined;
    }];
    
    //注销清除信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //存储到userfalut];
    [userDefaults removeObjectForKey:@"lastLogin"];
    [userDefaults synchronize];
}

#pragma mark 修改资料
- (void)dataViewHeaderPhotoIsAltered:(NSString *)alterImageName
{
    CPLog(@"修改的图片:%@",alterImageName);
    NSString *imgpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    //模拟加载网络路径的图像
    NSString *imagename = [imgpath stringByAppendingPathComponent:alterImageName];
    self.userimg.image = [UIImage thumbnailWithImageWithoutScale:[UIImage imageWithContentsOfFile:imagename] size:CGSizeMake(self.userimg.width, self.userimg.height)];
    
    //获取用户登录的信息并存储
    [self saveDataToUserDefaults:alterImageName];
    
}

#pragma mark- 登录成功的代理方法实现（登录成功后的数据是自己模拟的，显示需求是要从网络中获取数据）
- (void)loginViewControllerisLogined:(CPLoginViewController *)loginvc WithUserInfo:(NSArray *)userinfo
{
    CPLog(@"个人中心收到登录成功通知");
    //用户已经登录
    _logined = YES;
    
    //调用view的block方法告诉我的设备用户为登录状态
    CPHeaderView *headerview = [[CPHeaderView alloc] init];

    [headerview setAppLoginStatus:^BOOL{
        return _logined;
    }];
    
    //赋值模型获取登录用户的信息
    for (NSDictionary *dict in userinfo){
        CPData *data = [CPData dataWithDict:dict];
        if ([data.detail isEqualToString:@"头像"]) {
            //设置头像数据
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *imgpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
            //模拟加载网络路径的图像
            NSString *imagename = [imgpath stringByAppendingPathComponent:data.img];
            if ([fileManager fileExistsAtPath:imagename]) {
                self.userimg.image = [UIImage thumbnailWithImageWithoutScale:[UIImage imageWithContentsOfFile:imagename] size:CGSizeMake(self.userimg.width, self.userimg.height)];
            }else{
                self.userimg.image = [UIImage imageNamed:data.img];
            }
            [self.userimg setAccessibilityIdentifier:data.img];
            
        }else if([data.detail isEqualToString:@"姓名"]){
            self.username.text = data.subdetail;
        }else if([data.detail isEqualToString:@"手机号"]){
            //记录登录的用户手机号
            self.loginPhonenumber = data.subdetail;
        }
    }
    //在线的设备数量
    self.numdevice.text = @"10个智能设备";
    
    //获取UserDefaults单例存储数据
    [self saveDataToUserDefaults:[self.userimg accessibilityIdentifier]];
    
    //设置通知
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

#pragma mark 刷新个人中心的界面数据
- (void)refreshCenterViewData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *login = [userDefaults objectForKey:@"lastLogin"];
    
    //设置头像数据
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imgpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *imagename = [imgpath stringByAppendingPathComponent:login[@"userImg"]];
    if ([fileManager fileExistsAtPath:imagename]) {
        self.userimg.image = [UIImage thumbnailWithImageWithoutScale:[UIImage imageWithContentsOfFile:imagename] size:CGSizeMake(self.userimg.width, self.userimg.height)];
    }else{
        self.userimg.image = [UIImage imageNamed:login[@"userImg"]];
    }
    self.username.text = login[@"userName"];
    self.numdevice.text = login[@"numDevice"];
    _logined = [login[@"curStatus"] intValue];
    self.loginPhonenumber = login[@"loginPhone"];
    CPLog(@"登录的手机号是%@",self.loginPhonenumber);
}

#pragma mark 存储数据到userDefaults
- (void)saveDataToUserDefaults:(NSString *)alterImg
{
    //获取用户登录的信息并存储
    NSString *userimg = alterImg;
    NSString *username = self.username.text;
    NSString *numdevice = self.numdevice.text;
    NSString *curStatus = @"1";
    
    //获取userdefault单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginDict = [NSDictionary dictionary];
    loginDict = @{@"userImg": userimg,@"userName": username,@"numDevice": numdevice,@"curStatus": curStatus,@"loginPhone": self.loginPhonenumber};
    
    //存储到userfalut];
    [userDefaults setObject:loginDict forKey:@"lastLogin"];
    [userDefaults synchronize];
}
@end
