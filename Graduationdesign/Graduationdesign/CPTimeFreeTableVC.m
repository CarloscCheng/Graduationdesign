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

@interface CPTimeFreeTableVC ()
- (IBAction)back:(id)sender;
- (IBAction)segmentChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray *freeGameArray;

@property (strong, nonatomic) CPResultModel *resultModel;

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
