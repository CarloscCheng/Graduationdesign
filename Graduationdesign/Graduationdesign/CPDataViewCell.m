//
//  CPDataViewCell.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDataViewCell.h"
#import "CPData.h"
@interface CPDataViewCell()<UIActionSheetDelegate>
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *detail;
/**
 *  详细信息
 */
@property (weak, nonatomic) IBOutlet UILabel *subDetail;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIButton *imgButton;

/**
 *  分割线
 */
@property (weak,nonatomic) UIView *splitline;
- (IBAction)imgButtonAction;

/**
 *  当前用户头像名称(plist存储的图像名模拟服务器)
 */
@property (copy, nonatomic) NSString *userImagename;

/**
 *  存放用户大图头像和蒙版的view容器
 */
@property (weak, nonatomic) UIView *container;
@end

@implementation CPDataViewCell

//自定义cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"data";
    CPDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPDataViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setData:(CPData *)data
{
    //设置属性
    _data = data;
    
    self.detail.text = data.detail;
    self.subDetail.text = data.subdetail;
    
    //设置头像
    if ([data.detail isEqualToString:@"头像"]) {
    
        //设置头像数据
        NSString *imgpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *imagename = [imgpath stringByAppendingPathComponent:data.img];
        self.userImagename = data.img;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:imagename]) {
            [self.imgButton setBackgroundImage:[UIImage imageWithContentsOfFile:imagename] forState:UIControlStateNormal];
        }else{
            [self.imgButton setBackgroundImage:[UIImage imageNamed:data.img] forState:UIControlStateNormal];
        }
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imgButton.enabled = YES;
        self.userImagename = data.img;
        
        //修改半径，实现头像的圆形化
        [self.imgButton.layer setCornerRadius:CGRectGetHeight([self.imgButton bounds]) / 2];
        self.imgButton.layer.masksToBounds = YES;
    }else{
        self.imgButton.enabled = NO;
    }

    //设置cell的编辑属性
    if (([data.detail isEqualToString:@"手机号"]
         | [data.detail isEqualToString:@"邮箱"]
         | [data.detail isEqualToString:@"账号"])){
        //设置该cell不可被选择操作
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        //设置右边辅助按钮
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
}

#pragma mark 修改对应选择的信息
- (void)alterDataWith:(CPData *)data
{
    if ([data.detail isEqualToString:@"头像"]) {
        CPLog(@"修改头像");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterImage:)]) {
            [self.delegate dataViewCellChooseAlterImage:self];
        }
    }else if ([data.detail isEqualToString:@"姓名"]){
        CPLog(@"修改姓名");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterName:)]) {
            [self.delegate dataViewCellChooseAlterName:self];
        }
    }else if ([data.detail isEqualToString:@"性别"]){
        CPLog(@"修改性别");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterSex:)]) {
            [self.delegate dataViewCellChooseAlterSex:self];
        }
    }else if ([data.detail isEqualToString:@"出生年月"]){
        CPLog(@"修改出生年月");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterBirth:)]) {
            [self.delegate dataViewCellChooseAlterBirth:self];
        }
    }else if ([data.detail isEqualToString:@"修改密码"]){
        CPLog(@"修改修改密码");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterPwd:)]) {
            [self.delegate dataViewCellChooseAlterPwd:self];
        }
    }else if ([data.detail isEqualToString:@"修改权限"]){
        CPLog(@"修改修改权限");
        if ([self.delegate respondsToSelector:@selector(dataViewCellChooseAlterLimit:)]) {
            [self.delegate dataViewCellChooseAlterLimit:self];
        }
    }

}
//头像被点击
- (IBAction)imgButtonAction {
    CPLog(@"查看头像");
    //放大图像
    UIView *container = [[UIView alloc] initWithFrame:self.window.frame];
    container.backgroundColor = [UIColor whiteColor];
    self.container = container;
    
    UIButton *maskButton = [[UIButton alloc] initWithFrame:self.container.frame];
    maskButton.backgroundColor = [UIColor lightGrayColor];
    maskButton.alpha = 0.5;
    [maskButton addTarget:self action:@selector(dismissMask) forControlEvents:UIControlEventTouchUpInside];
    
    //设置头像数据
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imgpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *imagename = [imgpath stringByAppendingPathComponent:self.userImagename];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    if ([fileManager fileExistsAtPath:imagename]) {
        //传入服务器的是缩略图查看头像会加载大图
        imageview.image = [UIImage thumbnailWithImageWithoutScale:[UIImage imageWithContentsOfFile:imagename] size:CGSizeMake(320, 320)];
    }else{
        imageview.image = [UIImage imageNamed:@"user_default"];
    }
    
    imageview.frame = CGRectMake(0, 0, 0, 0);
    imageview.center = container.center;
    //动画效果
    [UIView animateWithDuration:0.3 animations:^{
        [self.container addSubview:maskButton];
        
        imageview.frame = CGRectMake(0, 0, self.container.width, self.container.width);
        imageview.centerY = self.container.centerY;
        
        [self.container addSubview:imageview];
        [self.window addSubview:self.container];
    }];

    
}

- (void)dismissMask
{
    //恢复原来的界面
    [self.container removeFromSuperview];
}

@end
