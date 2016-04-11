//
//  CPFeedBackViewController.m
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPFeedBackViewController.h"
#import "CPTextView.h"

@interface CPFeedBackViewController ()<UITextViewDelegate>
- (IBAction)back:(id)sender;
/**
 *  反馈联系方式
 */
@property (weak, nonatomic) IBOutlet UITextField *feedBackContact;
/**
 *  反馈详情所在的view
 */
@property (weak, nonatomic) IBOutlet UIView *textViewView;
/**
 *  提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) UITextView *myTextView;

- (IBAction)sunMit;

@end

@implementation CPFeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"反馈"];
    
    self.feedBackContact.font = [UIFont systemFontOfSize:10.0];
    
    CPTextView *textview = [[CPTextView alloc] initWithFrame:self.textViewView.bounds];
    textview.myPlaceholder = @"想跟我们说些什么呢?";
    textview.myPlaceholderColor = [UIColor lightGrayColor];
    [textview setFont:[UIFont systemFontOfSize:10.0]];
    
    textview.layer.backgroundColor = [[UIColor clearColor] CGColor];
    textview.layer.borderColor = [[UIColor lightGrayColor] CGColor];//[[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
    textview.layer.borderWidth = 0.5;
    textview.layer.cornerRadius = 3.0f;
    [textview.layer setMasksToBounds:YES];
    
    textview.delegate = self;
    
    [self.textViewView addSubview:textview];
    
    //return 类型
    textview.returnKeyType = UIReturnKeyDone;
    
    self.myTextView = textview;
    
    //提交按钮圆角
    self.submitBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.submitBtn.layer.borderWidth = 0.5;
    self.submitBtn.layer.cornerRadius = 3.0f;
    [self.submitBtn.layer setMasksToBounds:YES];
    
    self.submitBtn.enabled = NO;
    [self.submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.feedBackContact];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self.myTextView];

    

}


#pragma mark 返回
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 提交
- (IBAction)sunMit
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textChange
{
    //设置按钮是否能被点击
    if (!(self.feedBackContact.text.length && self.myTextView.text.length)) {
        self.submitBtn.enabled = NO;
        [self.submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        self.submitBtn.enabled = YES;
        [self.submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.feedBackContact];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.myTextView];
}

#pragma mark <UITextView>的代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

