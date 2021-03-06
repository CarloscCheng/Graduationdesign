//
//  CPLoginViewController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-26.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPHeaderView.h"

#import <SMS_SDK/SMSSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "CPDataHeader.h"

@interface CPLoginViewController ()<CPLoginViewControllerDelegate>
/**
 *  登陆帐号
 */
@property (weak, nonatomic) IBOutlet UITextField *loginname;
/**
 *  登录密码
 */
@property (weak, nonatomic) IBOutlet UITextField *loginpwd;
/**
 *  新用户注册
 */
- (IBAction)newUserReg;
/**
 *  忘记密码
 */
@property (weak, nonatomic) IBOutlet UIButton *misspwd;
/**
 *  登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *login;
/**
 *  登录事件
 */
- (IBAction)loginAction;

//密码
- (IBAction)showpwd:(id)sender;

/**
 *  默认密码是否可见,默认为不可见
 */
@property (nonatomic, assign, getter = isShow) BOOL show;

- (IBAction)back:(id)sender;

//微信登录
- (IBAction)weChatLogin;
- (IBAction)weiboLogin;

@end

@implementation CPLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置登录按钮圆角半径
    [self.login.layer setCornerRadius:10.0];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.loginname];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.loginpwd];
 
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"帐号登录"];
}

#pragma mark 文本内容变化时候收到通知
- (void)textChange
{
    //设置按钮是否能被点击
    self.login.enabled = (self.loginname.text.length && self.loginpwd.text.length);
    //设置能否被点击时候的不同按钮颜色
    self.login.alpha = (self.loginname.text.length && self.loginpwd.text.length) ? 1.0 : 0.3;
    
}

#pragma mark 显示／不显示密码
- (IBAction)showpwd:(id)sender
{
    if (!self.isShow) {
        //当前不可见则改为可见
        [sender setImage:[UIImage imageNamed:@"login_password_on"] forState:UIControlStateNormal];
        self.show = YES;
        //密码改为明文
        self.loginpwd.secureTextEntry = NO;
        
#warning 如果不重新赋值字符串，密码从暗文改为明文时出现字体缩在一起
        //改变光标位置
        self.loginpwd.text = self.loginpwd.text;

    }else
    {
        [sender setImage:[UIImage imageNamed:@"login_password_off"] forState:UIControlStateNormal];
        self.show = NO;
        //密码改为密文
        self.loginpwd.secureTextEntry = YES;
    }
}


#pragma mark 返回
- (IBAction)back:(id)sender
{
    //收回键盘
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 登录
- (IBAction)loginAction
{
    //写入数据
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"PersonlData.plist"];
    
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:filename];
    
    //获取服务器注册用户的信息
    NSMutableArray *phoneArray = [NSMutableArray array];
    NSArray *userInfo = [NSArray array];
    
    //用户密码
    NSString *password = [[NSString alloc] init];
    for (NSDictionary *dict in dictArray) {
        
        [phoneArray addObject:dict[@"phonenumber"]];
        if([dict[@"phonenumber"] isEqualToString:self.loginname.text])
        {
            userInfo = dict[@"otherdata"];
            password = dict[@"password"];
        }
    }

    //登录校验
    if (![phoneArray containsObject:self.loginname.text]) {
        // 帐号不存在
        [MBProgressHUD showError:@"帐号不存在"];
        return;
    }
    
    if (![self.loginpwd.text isEqualToString:password]) {
        // 密码错误
        [MBProgressHUD showError:@"密码错误"];
        return;
    }
    
    // 显示一个蒙版(遮盖)
    [MBProgressHUD showMessage:@"正在登录中...."];
    
    // 发送网络请求
    // 模拟(1秒后执行跳转)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 移除遮盖
        [MBProgressHUD hideHUD];
        //隐藏键盘
        [self.view endEditing:YES];

        //回到个人中心，加载用户资料
        [self.navigationController popViewControllerAnimated:YES];
        
        //告诉个人资料的代理是不是收到登录成功的信息
        if ([self.delegate respondsToSelector:@selector(loginViewControllerisLogined:WithUserInfo:AndThirdParty:)]) {
            [self.delegate loginViewControllerisLogined:self WithUserInfo:userInfo AndThirdParty:NO];
        }
        
    
    });
}

#pragma mark 微博授权登录
- (IBAction)weiboLogin
{
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       associateHandler (user.uid, user, user);
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                       if ([self.delegate respondsToSelector:@selector(loginViewControllerisLogined:WithUserInfo:AndThirdParty:)]) {
                                           [self.delegate loginViewControllerisLogined:self WithUserInfo:@[user.rawData] AndThirdParty:YES];
                                       }
                                       
                                       NSDictionary *regDict = @{@"otherdata": @[@{@"detail": CPDATA_HEADIMG_DETAIL , @"img": @""},
                                                                                 @{@"detail": CPDATA_NAME_DETAIL , @"subdetail": user.rawData[@"name"]},
                                                                                 @{@"detail": CPDATA_SEX_DETAIL , @"subdetail": @"男"},
                                                                                 @{@"detail": CPDATA_BIRTH_DETAIL , @"subdetail": @"2001/1/1"},
                                                                                 @{@"detail": CPDATA_PHONE_DETAIL , @"subdetail": @"未绑定"},
                                                                                 @{@"detail": CPDATA_ACCOUNT_DETAIL , @"subdetail": @"未绑定"},
                                                                                 @{@"detail": CPDATA_MAIL_DETAIL , @"subdetail": @"未绑定"},
                                                                                 @{@"detail": CPDATA_ALTERPWD_DETAIL},
                                                                                 @{@"detail": CPDATA_ALTERLIMIT_DETAIL}],
                                                                 @"phonenumber": user.rawData[@"name"],
                                                                 @"password": @""};
                                       
                                       
                                       //写入数据
                                       NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                                       NSString *path=[paths objectAtIndex:0];
                                       NSString *filename=[path stringByAppendingPathComponent:@"PersonlData.plist"];
                                       
                                       //读文件
                                       NSMutableArray *regArr = [NSMutableArray arrayWithContentsOfFile:filename];
                                       
                                       BOOL thirdExit = false;
                                       for (NSDictionary *dict in regArr) {
                                           if([dict[@"phonenumber"] isEqualToString:user.rawData[@"name"]])
                                           {
                                               thirdExit = YES;
                                           }
                                       }
                                       
                                       if (thirdExit) return ;
                                       
                                       if(!regArr)
                                       {
                                           //第一次更新数据
                                           [@[regDict] writeToFile:filename atomically:YES];
                                       }else{
                                           //在原来的文件上增加
                                           [regArr addObject:regDict];
                                           [regArr writeToFile:filename atomically:YES];
                                       }
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        CPLog(@"授权登录成功");
                                        //可以显示mbprocess
                                    }else{
                                        CPLog(@"授权登录失败");
                                    }
                                }];
}

#pragma mark 微信授权登录
- (IBAction)weChatLogin{
}

#pragma mark 新用户注册
- (IBAction)newUserReg
{
    CPLog(@"注册用户");
    [self performSegueWithIdentifier:@"login2reg" sender:nil];
}

#pragma mark dealloc
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
