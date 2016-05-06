//
//  CPTimeFreeTableVC.m
//  Graduationdesign
//
//  Created by cheng on 16/4/12.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPTimeFreeTableVC.h"
#import "CPGameTableViewCell.h"
#import "CPTimeFreeModel.h"
#import "CPEachGameTableVC.h"

@interface CPTimeFreeTableVC ()
- (IBAction)back:(id)sender;
- (IBAction)segmentChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray *freeGameArray;

@property (strong, nonatomic) CPResultModel *resultModel;
@property (strong, nonatomic) CPTimeFreeListModel *timeFreeList;
@property (copy, nonatomic) NSString *fileID;
@end

@implementation CPTimeFreeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认加载的时候segmented control在0的位置
    self.fileID = self.segments[0];
    
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark 懒加载
- (NSArray *)freeGameArray
{
    if (!_freeGameArray) {
        [self LoadResultModel:self.fileID];
        _freeGameArray = self.resultModel.list;
    }
    return _freeGameArray;
}

#pragma mark 加载模型数据
- (void)LoadResultModel:(NSString *)fileId;
{
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:fileId];
    
    NSData *gameData = [NSData dataWithContentsOfFile:cachefilename];
    NSDictionary *gameDataDict = [NSJSONSerialization JSONObjectWithData:gameData options:NSJSONReadingMutableLeaves error:nil];
    
    CPTimeFreeModel *timeFreeModel = [CPTimeFreeModel timeFreeModelWithDict:gameDataDict];
    CPResultModel *resultModel = [CPResultModel resultModelWithDict:timeFreeModel.result];
    
    self.resultModel = resultModel;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.freeGameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPGameTableViewCell *gameCell = [CPGameTableViewCell gameCellCreate:tableView];
    CPTimeFreeListModel *listModel = self.freeGameArray[indexPath.row];
    gameCell.timeFreeListModel = listModel;
    
    return gameCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    return 80;
}


#pragma mark 选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CPLog(@"timefree %ld,%ld",indexPath.row, indexPath.section);
    CPTimeFreeListModel *listModel = self.freeGameArray[indexPath.row];
    self.timeFreeList = listModel;
    
    NSString *host = @"http://cdn.4399sj.com";
    NSString *path = [NSString stringWithFormat:@"/app/iphone/v2.2/game.html?id=%@",listModel.id];
    NSString *fileID = [NSString stringWithFormat:@"%@-%@",vcGameCacheName, listModel.id];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"请求的数据地址%@",urlStr);
    
    //获取缓存目录
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *vccachefilename = [cacheDirectory stringByAppendingPathComponent:fileID];
    
    //连接服务器get数据
    AFHTTPSessionManager *httpMrg = [AFHTTPSessionManager manager];
    httpMrg.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMrg GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //写入文件
            NSError *error;
            if ([responseObject writeToFile:vccachefilename options:NSDataWritingAtomic error:&error]) {
                CPLog(@"写入缓存成功");
                [self performSegueWithIdentifier:@"timeFree2eachGame" sender:fileID];
                
            }else{
                CPLog(@"写入缓存失败");
            }
        }else{
            CPLog(@"获取数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CPLog(@"失败%@",error);
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeFree2eachGame"]) {
        CPEachGameTableVC *eachgameVC = segue.destinationViewController;
        eachgameVC.fileID = sender;
        UIView *titleView = [[UIView alloc] init];
        //新游推荐
        titleView = ({
            CGSize titleSize = [NSString sizeWithText:self.timeFreeList.name font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            label.font = MYITTMFONTSIZE;
            label.text = self.timeFreeList.name;
            [view addSubview:label];
            view;
        });
        
        [eachgameVC.navigationItem setTitleView:titleView];
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark segmented control 切换事件
- (IBAction)segmentChange:(id)sender {
    CPLog(@"===%ld",(long)self.segmentedControl.selectedSegmentIndex);
    //选择不同的功能
    self.fileID = self.segments[self.segmentedControl.selectedSegmentIndex];
    
    //更新tableview
    self.freeGameArray = nil; 
    [self.tableView reloadData];
}
@end
