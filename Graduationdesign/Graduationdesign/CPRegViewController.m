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

#import <SMS_SDK/SMSSDK.h>

//提醒字体大小
#define CPTIPSFONT [UIFont systemFontOfSize:10.0]

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
 *  phone textfield
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

@end

@implementation CPRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"新用户注册"];
    
//    [self.getCodeBtn.layer setBorderWidth:1.0]; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1/255.0, 1/255.0, 1/255.0, 0.3 });
//    [self.getCodeBtn.layer setBorderColor:colorref];//边框颜色
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.smsCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdStr];
    
    //btn
    self.regBtn.alpha = 0.3;
    self.regBtn.enabled = NO;
    
    //uitextfield delegate
    self.phoneNumber.delegate = self;
    
}

- (IBAction)regAction
{
    //验证短信验证码
//    NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [SMSSDK commitVerificationCode:self.smsCode.text phoneNumber:phone zone:@"86" result:^(NSError *error) {
//        if (!error) {
//            NSLog(@"验证成功");
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
//            NSLog(@"错误信息:%@",error);
//        
//        }
//    }];

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
    }];
    
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


- (void)codeShowViewWithOk:(BOOL)ok
{
    if (!ok) {
        [self.codeShowView endEditing:YES];
    }
}
#pragma mark 输入框发生改变的时候
- (void)textChange
{
    //设置按钮是否能被点击
    if (!(self.phoneNumber.text.length & self.smsCode.text.length & self.pwdStr.text.length)){
        self.regBtn.enabled = NO;
        self.regBtn.alpha = 0.3;
    }else{
        self.regBtn.enabled = YES;
        self.regBtn.alpha = 1.0;
    }
    
    //电话号码判断
    if (!self.phoneNumber.text.length) {
        self.sencodeBtn.enabled = NO;
        self.sencodeBtn.alpha = 0.3;
    }else{
        NSString *phone = [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([self checkTel:phone]) {
            //格式正确
            self.sencodeBtn.enabled = YES;
            self.sencodeBtn.alpha = 1.0;
        }
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

- (void)test
{
    //    CPLog(@"%@,%@",self.phoneNumber.text,self.verificationCode.text);
    //    [self performSegueWithIdentifier:@"getCode" sender:self];
    //    if (self.phoneNumber.isFirstResponder) {
    //        if (self.phoneNumber != nil) {
    //            if ([self checkTel:self.phoneNumber.text]) {
    //                //手机号码格式正确
    //                if (self.verificationCode.text != nil) {
    //                    //判断输入的是否为验证图片中显示的验证码（不区分大小写）
    //                    if([self.verificationCode.text compare:authcodeView.authCodeStr options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    //                    {
    //                        CPLog(@"验证码正确");
    //                        //next
    //
    //                    }else{
    //                        CPLog(@"验证码错误");
    //                        //刷新验证码
    //                    }
    //                }else{
    //                    //验证码为空
    //                    CPLog(@"验证码错误");
    //                }
    //
    //            }else{
    //                //手机号码格式错误
    //                CPLog(@"手机号码格式错误");
    //
    //            }
    //        }else{
    //            //手机号为空
    //            CPLog(@"手机号为空");
    //        }
    //    }
    
    //    if (self.verificationCode.isFirstResponder) {
    //        if (self.verificationCode.text != nil) {
    //            //判断输入的是否为验证图片中显示的验证码（不区分大小写）
    //            if([self.verificationCode.text compare:authcodeView.authCodeStr options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    //            {
    //                CPLog(@"验证码正确");
    //                if (self.phoneNumber != nil) {
    //                    if ([self checkTel:self.phoneNumber.text]) {
    //                        //手机号码格式正确
    //
    //
    //                    }else{
    //                        //手机号码格式错误
    //                    }
    //                }else{
    //                    //手机号为空
    //                }
    //            }else{
    //                CPLog(@"验证码错误");
    //                //刷新验证码
    //                [authcodeView refreshAuthcode];
    //            }
    //        }else{
    //            //验证码为空
    //        }
    //    }

}


- (IBAction)backLogin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark UITextFieldDelegate的代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    CPLog(@"textField=%@",textField);
    CPLog(@"---%@,%ld",textField.text,range.location);
    if (range.location == 3 || range.location == 8) {
        string = @" ";
        textField.text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    return (strLength <= 13);

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
                NSLog(@"获取验证码成功");
            } else {
                NSLog(@"错误信息：%@",error);
            }
        }];
        //计时
        [self.sencodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"重新发送" mainColor:[UIColor whiteColor] countColor:[UIColor whiteColor]];
        CPLog(@"注册手机号:%@",phone);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
