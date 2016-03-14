//
//  CPDataViewController.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-23.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDataViewController.h"
#import "CPData.h"
#import "CPDataViewCell.h"

@interface CPDataViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UITableView *tabView;

- (IBAction)logoutAction;
@end

@implementation CPDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    //设置背景图片
    //UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_login"]];
    //[self.tabView addSubview:imgview];
    
    //把某一子控件移动到最下边
    //[self.tabView sendSubviewToBack:imgview];
    
    
}

//返回
- (IBAction)back:(id)sender
{
    NSLog(@"back%@",sender);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 注销操作，注销后个人中心数据刷新没，头像用户名清除
//注销
- (IBAction)logoutAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否注销当前登录?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
    
}


#pragma mark actionsheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) return;
    //点击注销后，个人中心用户头像恢复默认，所有数据恢复默认，在点击头像view，弹出登录界面
    
    //设置默认头像
    
    //告诉代理实现对应方法
    if ([self.delegate respondsToSelector:@selector(dataViewLogoutisClicked:)]) {
        [self.delegate dataViewLogoutisClicked:self];
    }
    
    //更改了actionSheet在pop当前界面之后才消失的小bug
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"navigationController = %@",self.navigationController);
    });
    
}

#pragma mark 设置懒加载
//数据的懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        // 初始化
        // 1.获得plist的全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PersonlData.plist" ofType:nil];
        
        // 2.加载数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *tgArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            // 3.1.创建模型对象
            CPData *data = [CPData dataWithDict:dict];
            
            // 3.2.添加模型对象到数组中
            [tgArray addObject:data];
        }
        
        // 4.赋值
        _dataArray = tgArray;
    }
    return _dataArray;
}

#pragma mark 数据源方法
/**
 *  一共有多少行数据
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"------------------");
    return self.dataArray.count;
}

/**
 *  每一行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    CPDataViewCell *cell = [CPDataViewCell cellWithTableView:tableView];
    
    // 2.给cell传递模型数据
    // 重写模型的setget方法达到设置的目的
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"+++++++++++%f",[CPDataViewCell cellWithTableView:tableView].frame.size.height);
    return [CPDataViewCell cellWithTableView:tableView].frame.size.height;
}

#warning 待完善功能
//选中第几行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 8:
            [self performSegueWithIdentifier:@"data2xiugaimima" sender:@"xiugaimima"];
            break;
        default:
            break;
    }
}
@end
