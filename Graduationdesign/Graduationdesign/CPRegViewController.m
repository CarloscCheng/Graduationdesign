//
//  CPRegViewController.m
//  Graduationdesign
//
//  Created by cheng on 16/3/17.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPRegViewController.h"
#import "CPAuthcodeView.h"
#import "CPCodeShowView.h"
#import "Toast.h"

#import <SMS_SDK/SMSSDK.h>

//提醒字体大小
#define CPTIPSFONT [UIFont systemFontOfSize:10.0]

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define NUMBERS @"0123456789"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
#define NUMBERSPERIOD @"0123456789."

@interface CPRegViewController()<CPCodeShowViewDelegate,UITextFieldDelegate>
{
    CPAuthcodeView *authcodeView;
}
/**
 *  获取验证码的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

//从注册页面返回登录界面
- (IBAction)backLogin:(id)sender;

/**
 *  注册的手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
/**
 *  sms code
 */
@property (weak, nonatomic) IBOutlet UITextField *smsCode;
/**
 *  password
 */
@property (weak, nonatomic) IBOutlet UITextField *pwdStr;

//注册按钮的属性
@property (weak, nonatomic) IBOutlet UIButton *regBtn;

//注册
- (IBAction)regAction;

@property (weak, nonatomic) CPCodeShowView *codeShowView;

//蒙板
@property (weak, nonatomic) UIButton *maskButton;

//发送验证码
- (IBAction)sendCode;
@property (weak, nonatomic) IBOutlet UIButton *sencodeBtn;

/**
 *  号码数组
 */
@property (strong, nonatomic) NSMutableArray *phoneArray;

@end

@implementation CPRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"新用户注册"];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.smsCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdStr];
    
    //btn
    self.regBtn.alpha = 0.3;
    self.regBtn.enabled = NO;
    
    //uitextfield delegate
    self.phoneNumber.delegate = self;
    self.smsCode.delegate = self;
    self.pwdStr.delegate = self;
    

    //查找服务器数据判断账号是否已经注册过（plist模拟服务器数据）
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"PersonlData.plist"];

    //读文件
    NSMutableArray *regArr = [NSMutableArray arrayWithContentsOfFile:filename];
    
    //获取服务器注册用户的信息
    self.phoneArray = [NSMutableArray array];
    for (NSDictionary *dict in regArr) {
        //获取服务器所有注册手机号
        [self.phoneArray addObject:dict[@"phonenumber"]];
        CPLog(@"所有的号码:%@",self.phoneArray);
    }
}

- (void)test
{
    //验证短信验证码
    //    NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [SMSSDK commitVerificationCode:self.smsCode.text phoneNumber:phone zone:@"86" result:^(NSError *error) {
    //        if (!error) {
    //            CPLog(@"验证成功");
    //
    //            //弹出验证输入界面，输入正确注册成功
    //            UIButton *maskButton = [[UIButton alloc] initWithFrame:self.view.window.frame];
    //            maskButton.backgroundColor = [UIColor lightGrayColor];
    //            maskButton.alpha = 0.8;
    //            self.maskButton = maskButton;
    //            [maskButton addTarget:self action:@selector(dismissCodeView) forControlEvents:UIControlEventTouchUpInside];
    //
    //            [self.view.window addSubview:maskButton];
    //
    //            //弹出验证码界面view
    //            //codeshowview
    //            CPCodeShowView *codeShowView = [CPCodeShowView codeviewCreate];
    //            self.codeShowView = codeShowView;
    //            self.codeShowView.delegate = self;
    //
    //            [UIView animateWithDuration:0.2 animations:^{
    //                [self.view endEditing:YES];
    //                self.codeShowView.center = self.view.window.center;
    //                [self.view.window addSubview:self.codeShowView];
    //            }];
    //
    //        }else{
    //            CPLog(@"错误信息:%@",error);
    //        
    //        }
    //    }];
}
#pragma mark 用户注册
- (IBAction)regAction
{
    //判断密码是否合法
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    for (int i = 0; i<[self.pwdStr.text length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self.pwdStr.text substringWithRange:NSMakeRange(i, 1)];
        CPLog(@"string is %@",s);
        NSString *filtered = [[s componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if (![s isEqualToString:filtered]) {
            CPLog(@"密码不合法");
        }
    }
    
    [MBProgressHUD showMessage:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


    //弹出验证输入界面，输入正确注册成功
    UIButton *maskButton = [[UIButton alloc] initWithFrame:self.view.window.frame];
    maskButton.backgroundColor = [UIColor lightGrayColor];
    maskButton.alpha = 0.8;
    self.maskButton = maskButton;
    [maskButton addTarget:self action:@selector(dismissCodeView) forControlEvents:UIControlEventTouchUpInside];

    [self.view.window addSubview:maskButton];

    //弹出验证码界面view
    //codeshowview
    CPCodeShowView *codeShowView = [CPCodeShowView codeviewCreate];
    self.codeShowView = codeShowView;
    self.codeShowView.delegate = self;

    [UIView animateWithDuration:0.2 animations:^{
        [self.view endEditing:YES];
        self.codeShowView.center = self.view.window.center;
        [self.view.window addSubview:self.codeShowView];
        [MBProgressHUD hideHUD];
    }];
    
    });
}


#pragma mark codeshowvew的代理
- (void)codeShowViewWithKeyBoardHeight:(float)height withShowKeyBoard:(BOOL)show
{
    CPLog(@"=======%f",height);
    //调整codeview的高度
    [UIView animateWithDuration:0.1 animations:^{
        if (show) {
            self.codeShowView.centerY = (self.view.window.height - height) * 0.6;
        }else{
            self.codeShowView.centerY = height * 0.5;
        }
 
    }];
}

#pragma mark 验证码校验
- (void)codeShowViewWithOk:(BOOL)ok
{
    if (!ok) {
        //验证码不正确
    }else{
        
#pragma mark 有问题
        [MBProgressHUD showMessage:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([self.phoneArray containsObject:phone]) {
                //已经注册
                CPLog(@"该号码已经注册");
                //移除codeview
                [UIView animateWithDuration:0.1 animations:^{
                    [self dismissCodeView];
                    [MBProgressHUD hideHUD];
                } completion:^(BOOL finished) {
                    //显示提示界面
                    [Toast toast:@"该手机号已被注册"];
                }];
                
            }else{
                //还没有注册,模拟写入plist为传递数据到服务器
                CPLog(@"准备注册");
                [self regDataToServer];
            }
        });
        
    }
}
#pragma mark 输入框发生改变的时候
- (void)textChange
{
    //判断手机号码格式是否正确
    NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length) {
        //手机号不为空
        if ([self checkTel:phone]) {
            //手机号码格式正确，发送验证码可用
            self.sencodeBtn.enabled = YES;
            self.sencodeBtn.alpha = 1.0;
            
            self.regBtn.enabled = (self.smsCode.text.length && self.pwdStr.text.length);
            self.regBtn.alpha = (self.smsCode.text.length && self.pwdStr.text.length) ? 1.0 : 0.3;
        }else{
            //手机号码格式不正确，发送验证码不可用
            self.sencodeBtn.enabled = NO;
            self.sencodeBtn.alpha = 0.3;
            
            //注册框不可用
            self.regBtn.enabled = NO;
            self.regBtn.alpha = 0.3;
        }
        
    }else{
        //手机号为空
        self.sencodeBtn.enabled = NO;
        self.sencodeBtn.alpha = 0.3;
        
        //注册框不可用
        self.regBtn.enabled = NO;
        self.regBtn.alpha = 0.3;
    }
}


#pragma mark 取消显示验证码界面
- (void)dismissCodeView
{
    //移除codeview
    //先关闭键盘
    [self.codeShowView endEditing:YES];
    
    [self.maskButton removeFromSuperview];
    self.maskButton = nil;
    
    [self.codeShowView removeFromSuperview];
    self.codeShowView = nil;

}

#pragma mark 判断手机号是否正确
//手机号码正则表达式
- (BOOL)checkTel:(NSString *)str
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        return NO;
    }
    return YES;
}

#pragma mark UITextFieldDelegate的代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL return_bool;
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (self.phoneNumber.isFirstResponder) {
#warning 不进行判断会导致遇到空格的时候删除不掉
        if (textField.text.length == range.location) {
            //输入数据
            if (range.location == 3 || range.location == 8) {
                string = @" ";
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            }
//            CPLog(@"输入数据");
        }else{
            //删除数据
//            CPLog(@"删除数据");
        }
        
        return_bool = (strLength <= 13);
        
    }else if (self.smsCode.isFirstResponder){
        return_bool = (strLength <= 6);
    
    }else if(self.pwdStr.isFirstResponder) {
        return_bool = (strLength <= 32);
    }
    
    return return_bool;
}

#pragma mark 发送验证码
- (IBAction)sendCode
{
    NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([self checkTel:phone])
    {
        //发送验证码
        self.sencodeBtn.alpha = 0.3;
        //调用smssdk获取验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                CPLog(@"获取验证码成功");
            } else {
                CPLog(@"错误信息：%@",error);
            }
        }];
        
        //计时
        [self.sencodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"重新发送" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        CPLog(@"注册手机号:%@",phone);
    }
}

#pragma mark 隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark 返回
- (IBAction)backLogin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



#pragma mark 注册信息记录
- (void)regDataToServer
{
    //手机号
    NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //密码
    NSString *pwd = self.pwdStr.text;
    
    //存储数据
    NSDictionary *regDict = @{@"otherdata": @[@{@"detail": @"头像" , @"img": @""},
                                              @{@"detail": @"姓名" , @"subdetail": phone},
                                              @{@"detail": @"性别" , @"subdetail": @"男"},
                                              @{@"detail": @"出生年月" , @"subdetail": @"2001/1/1"},
                                              @{@"detail": @"手机号" , @"subdetail": phone},
                                              @{@"detail": @"账号" , @"subdetail": @"123456"},
                                              @{@"detail": @"邮箱" , @"subdetail": @"未绑定"},
                                              @{@"detail": @"修改密码"},
                                              @{@"detail": @"修改权限"}],
                              @"phonenumber": phone,
                              @"password": pwd};
    
    
    //写入数据
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"PersonlData.plist"];
    
    //读文件
    NSMutableArray *regArr = [NSMutableArray arrayWithContentsOfFile:filename];
    if(!regArr)
    {
        //第一次更新数据
        [@[regDict] writeToFile:filename atomically:YES];
    }else{
        //在原来的文件上增加
        [regArr addObject:regDict];
        [regArr writeToFile:filename atomically:YES];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        [self dismissCodeView];
    } completion:^(BOOL finished) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"注册成功"];
    }];
}

@end
