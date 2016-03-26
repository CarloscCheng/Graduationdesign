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

@interface CPDataViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,CPDataViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) NSMutableArray *dataArray;
//点击返回按钮
- (IBAction)back:(id)sender;
/**
 *  注销按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logout;

/**
 *  详细资料tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *myDataTabView;

- (IBAction)logoutAction;

/**
 *  用户的手机号(只读)
 */
@property(readonly, nonatomic) NSString *loginPhone;

/**
 *  选择上传的图片名称
 */
@property (copy, nonatomic) NSString *imageName;


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
    [self performSelector:@selector(delectCell:) withObject:nil afterDelay:0.3];

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

#pragma mark dataviewcell的代理方法
- (void)dataViewCellChooseAlterImage:(UITableViewCell *)tableviewcell
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"修改头像"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"图片库",nil];
    
    [actionSheet showInView:self.view];
}
- (void)dataViewCellChooseAlterName:(UITableViewCell *)tableviewcell
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"修改姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alterView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alterView show];
}

- (void)dataViewCellChooseAlterSex:(UITableViewCell *)tableviewcell
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"修改性别"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
    
    [actionSheet showInView:self.view];
}

- (void)dataViewCellChooseAlterBirth:(UITableViewCell *)tableviewcell
{
    //添加一个时间选择器
//    UIDatePicker *date = [[UIDatePicker alloc] init];
//    [date setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
//    date.datePickerMode = UIDatePickerModeDate;
//    [self.view addSubview:date];
}
#pragma mark actionsheet代理方法
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
            case 0://照相机
            {
                BOOL supportCarma = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
                if (supportCarma) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"错误" message:@"相机不被支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alertview show];
                }
            }
                break;
            case 1://本地相簿
            {
                BOOL supportPhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
                if (supportPhotoLibrary) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"错误" message:@"相册不被支持!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alertview show];
                }

            }
                break;
            default:
                break;
        }
        
    }
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
                if ([alterdict[@"detail"] isEqualToString:@"头像"]) {
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
