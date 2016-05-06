//
//  CPGameDetailTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameDetailTableViewCell.h"
#import "CPGameInfo.h"
#import "CPGameDetailCellHeaderView.h"
#import "CPGameDetailCellFooterView.h"
#import "CPDetailTableViewCell.h"
#import "CPGameCellFrame.h"
#import "CPEachHeaderView.h"
#import "CPAbstractCell.h"

@interface CPGameDetailTableViewCell()<UITableViewDelegate, UITableViewDataSource,CPAbstractCellDelegate>


#define SECTIONS 6
#define ROWS 1

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//下方弹出的下载view
@property (nonatomic, strong) UIView *bottomDownView;
@property (nonatomic, strong) UIButton *bottomDownButton;
@property (nonatomic, strong) CPDetailTableViewCell *detailCell;
@property (nonatomic, strong) CPGameCellFrame *cellFrames;

@property (nonatomic, readonly,getter=isShowOrHide) BOOL showOrHide;
@end

@implementation CPGameDetailTableViewCell

+ (instancetype)gameDetailCellCreate:(UITableView *)tableview
{
    CPGameDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPGameDetailTableViewCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPGameDetailTableViewCell" owner:nil options:nil] lastObject];
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
    
    self.bottomDownView = ({
        UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        padding.backgroundColor = [UIColor lightGrayColor];
        padding.alpha = 0.5;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        view.backgroundColor = [UIColor whiteColor];
        view.y = [UIApplication sharedApplication].keyWindow.height - view.height;
        [view addSubview:padding];
        view;
    });
//    CPLog(@"====%f",view.y);
    
    self.bottomDownButton = ({
        UIButton *bottomDownButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 26)];
        bottomDownButton.centerX = self.bottomDownView.centerX;
        bottomDownButton.centerY = self.bottomDownView.centerY - self.bottomDownView.y;
        //    bottomDownButton.backgroundColor = [UIColor redColor];
        bottomDownButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        bottomDownButton.backgroundColor = CP_RGB(0, 192, 139);
        [bottomDownButton setTintColor:[UIColor whiteColor]];
        [bottomDownButton addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
        bottomDownButton;
    });
    
//    [self.myTableView registerClass:[CPDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CPDetailTableViewCell class])];
    
    //tableview
    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomDownView.height, 0);
    
    [self.bottomDownView addSubview:self.bottomDownButton];
    self.bottomDownView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomDownView];
}
 

- (void)setGameDetailModel:(CPGameDetail *)gameDetailModel
{
    _gameDetailModel = gameDetailModel;
    if ([gameDetailModel.price isEqualToString:@"0.00"]) {
        //免费
        [self.bottomDownButton setTitle:@"下载(免费)" forState:UIControlStateNormal];
    } else {
        //付费
        [self.bottomDownButton setTitle:[NSString stringWithFormat:@"下载(¥%@)",gameDetailModel.price] forState:UIControlStateNormal];
    }
} 
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uicell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        CPAbstractCell *cell = [CPAbstractCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell setGameCellFrame:self.cellFrames withShowOrHide:_showOrHide];
        uicell = cell;
    }else{
        CPDetailTableViewCell *cell = [CPDetailTableViewCell cellWithTableView:tableView];
        CPLog(@"第%ldcell地址%p", indexPath.section ,cell);
        [cell setGameCellFrame:self.cellFrames section:indexPath.section];
        cell.sencondShow = _showOrHide;
        uicell = cell;
    }
    return uicell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getRowHeightWithSection:indexPath.section];//gamecell.relateNewsF.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPLog(@"点击%ld,%ld",indexPath.row ,indexPath.section);
    if (indexPath.section == 2) {
        //播放视频
        if ([self.delegate respondsToSelector:@selector(gameDetailTableViewCellClickPalyVideo:)]) {
            [self.delegate gameDetailTableViewCellClickPalyVideo:self];
        }
    }
}

#pragma mark 设置不同sections的高度
- (CGFloat)getRowHeightWithSection:(NSInteger)section
{
    CPGameCellFrame *gamecell = self.cellFrames; //[self.cellFrames lastObject];
    CGFloat height = 0;
    if (section == 0) {
        //游戏截图
        height = gamecell.gallaryF.size.height;
    }else if (section == 1) {
        //内容概要
        if (_showOrHide) {
            height = gamecell.detailF.size.height;
        }else{
            height = gamecell.detailHideF.size.height;
        }
    }else if (section == 2) {
        //游戏视频
        height = gamecell.vedioF.size.height;
    }else if (section == 3) {
        //游戏相关
        height = gamecell.relateNewsF.size.height + 10;
    }else if (section == 4) {
        //用户评论
        height = gamecell.commentsF.size.height;
    }else if (section == 5) {
        //游戏推荐
        height = gamecell.relateGameF.size.height;
    }
    return height;
}

#pragma mark 返回每一组需要显示的头部标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CPGameDetailCellHeaderView *gameHeader = [CPGameDetailCellHeaderView gameDetailCellHeaderView];
    gameHeader.cellSection = section;
    return gameHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;       
    if (section != 4) {
        CPGameDetailCellHeaderView *gameHeader = [CPGameDetailCellHeaderView gameDetailCellHeaderView];
        height = gameHeader.height;
    }else {
        height = 0.01;
    }
    return height;
}

#pragma mark tableview的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //section == 2的headerView的Y值
    CGFloat headerY = scrollView.contentOffset.y;
    if (headerY < 0) {
        self.myTableView.scrollEnabled = NO; 
    }
}


#pragma mark 下载
- (void)downAction {
    CPLog(@"下载");
}

#pragma mark gameDetailCellFooterView代理
- (void)abstractCellShowOrHideDetail:(CPAbstractCell *)cell
{
    [self.myTableView reloadData];
//    _showOrHide = show;
    _showOrHide = !_showOrHide;
//    CPLog(@"====%d",show);
}

#pragma mark 懒加载
- (CPGameCellFrame *)cellFrames
{
    if (_cellFrames == nil) {
        CPGameCellFrame *gameCellFrame = [[CPGameCellFrame alloc] init];
        gameCellFrame.gameResult = self.gameResultModel;
        
        NSMutableArray *cellFrameArray = [NSMutableArray array];
        [cellFrameArray addObject:gameCellFrame];

        _cellFrames = gameCellFrame; 
    }
    return _cellFrames;
}

#pragma mark cell中的tableview滚动属性判断
- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.myTableView.scrollEnabled = scrollEnabled; 
    if (scrollEnabled) {
        self.bottomDownView.hidden = NO;
    }else{
        self.bottomDownView.hidden = YES;
    }
}

- (void)dealloc {
    CPLog(@"CPGameDetailTableViewCell---dealloc");
    [self.bottomDownView removeFromSuperview];
    self.bottomDownView = nil; 
}





@end
