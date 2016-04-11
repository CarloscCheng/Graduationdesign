//
//  CPDataViewController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDataViewController.h"
#import "CPDataViewCell.h"
#import "CPDataGroup.h"
#import "CPData.h"
#import "CPDataHeader.h"

@interface CPDataViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,CPDataViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *dataArray;
/**
 *  注销按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logout;

/**
 *  详细资料tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *myDataTabView;
/**
 *  用户的手机号(只读)
 */
@property(readonly, nonatomic) NSString *loginPhone;
/**
 *  选择上传的图片名称
 */
@property (copy, nonatomic) NSString *imageName;
/**
 *  日期选择器
 */
@property (weak, nonatomic) UIView *containter;
/**
 *  选择的日期
 */
@property (copy, nonatomic) NSString *selectDateStr;

- (IBAction)back:(id)sender;
- (IBAction)logoutAction;
@end

@implementation CPDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置注销按钮圆角半径
    [self.logout.layer setCornerRadius:10.0];
    //设置边框
    [self.logout.layer setBorderWidth:0.5];
    
    //边框颜色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 203/255, 203/255, 203/255, 0.3});
    [self.logout.layer setBorderColor:colorref];
    
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"个人资料"];
    
}

//返回
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 注销操作，注销后个人中心数据刷新没，头像用户名清除
//注销
- (IBAction)logoutAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否注销当前登录?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
}

#pragma mark 获取手机号
- (void)transmitPhone:(NSString *)phone
{
    _loginPhone = phone;
}

#pragma mark 设置懒加载
//数据的懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        // 初始化
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"PersonlData.plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:filename];
        
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *tgArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            if([dict[@"phonenumber"] isEqualToString:self.loginPhone])
            {
                // 3.1.创建模型对象
                CPDataGroup *datagroup = [CPDataGroup groupWithDict:dict];
            
                // 3.2.添加模型对象到数组中
                [tgArray addObject:datagroup];
            }
        }
        
        // 4.赋值
        _dataArray = tgArray;
    }
    return _dataArray;
}

#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CPDataGroup *datagroup = self.dataArray[section];
    return datagroup.otherdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    CPDataViewCell *cell = [CPDataViewCell cellWithTableView:tableView];

    // 2.给cell传递模型数据
    CPDataGroup *datagroup = self.dataArray[indexPath.section];
    
    cell.data = datagroup.otherdata[indexPath.row];
    
    return cell;
}

#pragma mark tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CPDataViewCell cellWithTableView:tableView].frame.size.height;
}

#pragma mark 哪一个cell被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转等其他操作
    [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.01];

    //点击cell完成相应的操作
    CPDataGroup *datagroup = self.dataArray[indexPath.section];
    
    CPDataViewCell *cell = [CPDataViewCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell alterDataWith:datagroup.otherdata[indexPath.row]];

}

#pragma mark 去除选定时一直高亮的效果
- (void)delectCell:(id)sender
{
    [self.myDataTabView deselectRowAtIndexPath:[self.myDataTabView indexPathForSelectedRow] animated:YES];
}

#pragma mark- dataviewcell的代理方法
#pragma mark 修改头像
- (void)dataViewCellChooseAlterImage:(UITableViewCell *)tableviewcell
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"修改头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册选取",@"拍摄",nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark 修改昵称
- (void)dataViewCellChooseAlterName:(NSString *)oldName
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alterView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alterView textFieldAtIndex:0] setText:oldName];
    [alterView show];
}

#pragma mark 修改性别
- (void)dataViewCellChooseAlterSex:(UITableViewCell *)tableviewcell
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"性别修改"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark 修改生日
- (void)dataViewCellChooseAlterBirth:(UITableViewCell *)tableviewcell
{
    //添加一个时间选择器
    UIView *containter = [[UIView alloc] initWithFrame:self.view.window.frame];
    self.containter = containter;
    //背部阴影
    UIButton *maskbutton = [[UIButton alloc] initWithFrame:containter.frame];
    maskbutton.backgroundColor = [UIColor lightGrayColor];
    maskbutton.alpha = 0.5;
    [containter addSubview:maskbutton];
    
    [maskbutton addTarget:self action:@selector(disMissDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    //装datepickerview的view
    UIView *datepickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containter.width, 200)];
    datepickerView.backgroundColor = [UIColor whiteColor];
    datepickerView.y = containter.height - datepickerView.height;

    //时间选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.alpha = 0.95;
    [datepickerView addSubview:datePicker];
    [containter addSubview:datepickerView];
    
    //自定义的toolbar
    UIView *toobarview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containter.width, 32)];
    toobarview.backgroundColor = [UIColor whiteColor];
    toobarview.y = datepickerView.y - toobarview.height;
    
    //分割线
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, toobarview.height, toobarview.width, 1)];
    padding.backgroundColor = [UIColor lightGrayColor];
    padding.alpha = 0.3;
    [toobarview addSubview:padding];
    
    //添加取消按钮
    CGSize fontSize = [NSString sizeWithText:@"确认" font:[UIFont systemFontOfSize:11.0] maxSize:CPMAXSIZE];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, fontSize.width, fontSize.height)];
    cancelButton.centerY = toobarview.centerY - toobarview.y;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [toobarview addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelDateChoose) forControlEvents:UIControlEventTouchUpInside];
    
    //添加确认按钮
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(toobarview.width - 20 - fontSize.width, 0, fontSize.width, fontSize.height)];
    okButton.centerY = toobarview.centerY - toobarview.y;
    [okButton setTitle:@"确认" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [okButton setTitleColor:CP_RGB(255, 0, 0) forState:UIControlStateNormal];
    okButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [toobarview addSubview:okButton];
    
    [containter addSubview:toobarview];
    [okButton addTarget:self action:@selector(confirmDateChoose) forControlEvents:UIControlEventTouchUpInside];
    
    //添加
    [self.view.window addSubview:containter];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark- 日期选择
- (void)dateChanged:(id)sender
{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    self.selectDateStr = [self dateTransformToDateStrWith:date];
    
    CPLog(@"===%@",self.selectDateStr);
}
#pragma mark 取消
- (void)cancelDateChoose
{
    CPLog(@"取消");
    [self.containter removeFromSuperview];
}
#pragma mark 确认
- (void)confirmDateChoose
{
    CPLog(@"确认");
    if (!self.selectDateStr) {
        //为当前日期
        self.selectDateStr = [self dateTransformToDateStrWith:[NSDate date]];
        CPLog(@"datestr=%@",self.selectDateStr);
    }
    
    //更新用户数据
    NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"PersonlData.plist"];
    NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filename];
    NSMutableArray *newOtherdataArr = [NSMutableArray array];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *dict in dictArray) {
        if([dict[@"phonenumber"] isEqualToString:self.loginPhone]){
            //找到当前用户的信息
            NSMutableArray *array = dict[@"otherdata"];
            for (NSMutableDictionary *alterdict in array){
                if ([alterdict[@"detail"] isEqualToString:CPDATA_BIRTH_DETAIL]) {
                    [alterdict setValue:self.selectDateStr forKey:@"subdetail"];
                }
                [newOtherdataArr addObject:alterdict];
            }
            [newDict setValue:newOtherdataArr forKey:@"otherdata"];
        }
    }
    //在原来的文件上增加
    [dictArray writeToFile:filename atomically:YES];
    
    //更新数据
    self.dataArray = nil;
    [self.myDataTabView reloadData];
    
    //移除日期选择器
    self.selectDateStr = nil;
    [self.containter removeFromSuperview];
    
}
#pragma mark 关闭日期选择器
- (void)disMissDatePicker
{
    [self.containter removeFromSuperview];
}

#pragma mark 转换成当地时间,(系统差了8个小时时差的秒数)
- (NSString *)dateTransformToDateStrWith:(NSDate *)defaultDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    return [dateFormatter stringFromDate:defaultDate];
}

#pragma mark-  UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"是否注销当前登录?"]) {
        if (buttonIndex != 0) return;
        
        //告诉代理实现对应方法
        if ([self.delegate respondsToSelector:@selector(dataViewLogoutisClicked:)]) {
            [self.delegate dataViewLogoutisClicked:self];
        }
        
        //更改了actionSheet在pop当前界面之后才消失的小bug
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            CPLog(@"navigationController = %@",self.navigationController);
        });
    }else if ([actionSheet.title isEqualToString:@"修改头像"]){
        switch (buttonIndex) {
            case 0://本地相簿
            {
                BOOL supportPhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
                if (supportPhotoLibrary) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    UIAlertView *photoAlertview = [[UIAlertView alloc] initWithTitle:@"错误" message:@"相册不被支持!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [photoAlertview show];
                }
            }
                break;
            case 1://照相机
            {
                BOOL supportCarma = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
                if (supportCarma) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    UIAlertView *carmeraAlertview = [[UIAlertView alloc] initWithTitle:@"错误" message:@"相机不被支持!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [carmeraAlertview show];
                }

            }
                break;
            default:
                break;
        }
        
    }else if ([actionSheet.title isEqualToString:@"性别修改"]){
        //忽略取消按钮
        if (buttonIndex != 2) {
            //更新用户信息
            NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"PersonlData.plist"];
            NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filename];
            
            //保存更新后的数组
            NSMutableArray *newOtherdataArr = [NSMutableArray array];
            NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
            for (NSMutableDictionary *dict in dictArray) {
                if([dict[@"phonenumber"] isEqualToString:self.loginPhone]){
                    NSMutableArray *array = dict[@"otherdata"];
                    for (NSMutableDictionary *alterdict in array){
                        if ([alterdict[@"detail"] isEqualToString:CPDATA_SEX_DETAIL]) {
                            [alterdict setValue:[actionSheet buttonTitleAtIndex:buttonIndex] forKey:@"subdetail"];
                        }
                        [newOtherdataArr addObject:alterdict];
                    }
                    [newDict setValue:newOtherdataArr forKey:@"otherdata"];
                }
            }
            //在原来的文件上增加
            [dictArray writeToFile:filename atomically:YES];
            
            //更新数据
            self.dataArray = nil;
            [self.myDataTabView reloadData];
        }
    }
}
#pragma mark UIAlertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"修改昵称"]) {
        if (buttonIndex == 0) return;
        
        //得到输入框
        UITextField *alertField = [alertView textFieldAtIndex:0];
        
        //更新用户信息
        NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"PersonlData.plist"];
        NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filename];
        
        //保存更新后的数组
        NSMutableArray *newOtherdataArr = [NSMutableArray array];
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        for (NSMutableDictionary *dict in dictArray) {
            if([dict[@"phonenumber"] isEqualToString:self.loginPhone]){
                //找到当前用户的信息
                NSMutableArray *array = dict[@"otherdata"];
                for (NSMutableDictionary *alterdict in array){
                    if ([alterdict[@"detail"] isEqualToString:CPDATA_NAME_DETAIL]) {
                        //找到要修改的昵称的字典处
                        [alterdict setValue:alertField.text forKey:@"subdetail"];
                    }
                    [newOtherdataArr addObject:alterdict];
                }
                [newDict setValue:newOtherdataArr forKey:@"otherdata"];
            }
        }
        //在原来的文件上增加
        [dictArray writeToFile:filename atomically:YES];
        
        //更新数据
        self.dataArray = nil;
        [self.myDataTabView reloadData];
        
        //更新个人中心界面数据
        if ([self.delegate respondsToSelector:@selector(dataViewHeaderNameIsAltered:)]) {
            [self.delegate dataViewHeaderNameIsAltered:alertField.text];
        }
    
    }
}
#pragma mark 改变alertview的大小
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if ([alertView.title isEqualToString:@"修改昵称"]) {
        CPLog(@"frame = %f,%f,%f,%f",alertView.x, alertView.y, alertView.width, alertView.height);
    }

}
#pragma mark 设置按钮可不可用
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    BOOL shouldEnable;
    if ([alertView.title isEqualToString:@"修改昵称"]) {
        if([alertView textFieldAtIndex:0].text.length != 0){
            shouldEnable = YES;
        }else{
            shouldEnable = NO;
        }
    }
    return shouldEnable;
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取图片名称
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        self.imageName = fileName;
        CPLog(@"fileName : %@",fileName);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    //保存图片
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage])
    {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存头像
- (void)saveImage:(UIImage *)image
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:self.imageName];
    
    BOOL success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //缩小图片尺寸
    UIImage *smallImage=[UIImage scaleFromImage:image toSize:CGSizeMake(320, 320)];
//    UIImage *smallImage = [UIImage thumbnailWithImageWithoutScale:image size:CGSizeMake(320, 320)];
    
    //写入文件
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    //更新用户信息
    NSString *filename=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"PersonlData.plist"];
    NSMutableArray *dictArray = [NSMutableArray arrayWithContentsOfFile:filename];

    //保存更新后的数组
    NSMutableArray *newOtherdataArr = [NSMutableArray array];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *dict in dictArray) {
        if([dict[@"phonenumber"] isEqualToString:self.loginPhone]){
            //找到当前用户的信息
            NSMutableArray *array = dict[@"otherdata"];
            CPLog(@"arrayt=%@",array);
            for (NSMutableDictionary *alterdict in array){
                if ([alterdict[@"detail"] isEqualToString:CPDATA_HEADIMG_DETAIL]) {
                    //找到要修改的头像字典处
                    [alterdict setValue:self.imageName forKey:@"img"];
                }
                [newOtherdataArr addObject:alterdict];
            }
            [newDict setValue:newOtherdataArr forKey:@"otherdata"];
        }
    }
    //在原来的文件上增加
    [dictArray writeToFile:filename atomically:YES];
    
    //更新数据
    self.dataArray = nil;
    [self.myDataTabView reloadData];
    
    //更新个人中心界面数据
    if ([self.delegate respondsToSelector:@selector(dataViewHeaderPhotoIsAltered:)]) {
        [self.delegate dataViewHeaderPhotoIsAltered:self.imageName];
    }
}
@end
