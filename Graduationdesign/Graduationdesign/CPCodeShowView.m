//
//  CPCodeShowView.m
//  Graduationdesign
//
//  Created by cheng on 16/3/19.
//  Copyright © 2016年 chengpeng. All rights reserved.
//
#import "CPCodeShowView.h"
#import "CPAuthcodeView.h"

@interface CPCodeShowView()

- (IBAction)changeCode;
- (IBAction)okBtn;

//图片验证码输入textfield
@property (weak, nonatomic) IBOutlet UITextField *inputCode;
/**
 *  图片验证码所在view
 */
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) CPAuthcodeView *authcodeView;
/**
 *  提示
 */
@property (weak, nonatomic) IBOutlet UILabel *detailStr;

@property (weak, nonatomic) IBOutlet UIButton *changeCodebtn;

@end

@implementation CPCodeShowView

+ (instancetype)codeviewCreate
{
    CPCodeShowView *codeshowview = [[[NSBundle mainBundle] loadNibNamed:@"CPCodeShowView" owner:nil options:nil] lastObject];
    
    //验证码界面
    CPAuthcodeView *authcodeView = [[CPAuthcodeView alloc] initWithFrame:CGRectMake(0, 0, codeshowview.codeView.width, codeshowview.codeView.height)];
    codeshowview.authcodeView = authcodeView;

    [codeshowview.codeView addSubview:authcodeView];
    
    return codeshowview;
}

- (void)layoutSubviews
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //成为第一响应者
//    [self.inputCode becomeFirstResponder];
}

- (IBAction)changeCode
{
    [self.authcodeView refreshAuthcode];
}

- (IBAction)okBtn
{
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CPLog(@"height=%d",height);
    
    if ([self.delegate respondsToSelector:@selector(codeShowViewWithKeyBoardHeight:withShowKeyBoard:)]) {
        [self.delegate codeShowViewWithKeyBoardHeight:height withShowKeyBoard:YES];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.origin.y;
    if ([self.delegate respondsToSelector:@selector(codeShowViewWithKeyBoardHeight:withShowKeyBoard:)]) {
        [self.delegate codeShowViewWithKeyBoardHeight:height withShowKeyBoard:NO];
    }
}

- (void)dealloc
{
    CPLog(@"codeshow is dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
