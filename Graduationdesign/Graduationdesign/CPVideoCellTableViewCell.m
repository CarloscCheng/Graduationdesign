//
//  CPVideoCellTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPVideoCellTableViewCell.h"
#import "CPVideoCell.h"
#import "CPGameInfo.h"

@interface CPVideoCellTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *videoList;
@end

@implementation CPVideoCellTableViewCell

+ (instancetype)videoCellCellCreate:(UITableView *)tableview
{
    CPVideoCellTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPVideoCellTableViewCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPVideoCellTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
    
    //设置代理和数据源
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = NO;
    
    //stytle
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //tableview
    self.myTableView.showsVerticalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSArray *)videoList
{
    if (_videoList == nil) {
        CPGameVideo *video = [CPGameVideo gameVideoWithDict:self.gameResultModel.video];
        _videoList = video.list;
    }
    return _videoList;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoList.count;
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPVideoCell *cell = [CPVideoCell videoCellCreate:tableView];
//    cell.videoList = self.videoList[indexPath.row];
    cell.videoList = [CPGameVideoList gameVideoListWithDict:self.videoList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
