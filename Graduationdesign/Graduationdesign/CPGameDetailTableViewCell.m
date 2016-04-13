//
//  CPGameDetailTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/13.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameDetailTableViewCell.h"
#import "CPGameInfo.h"

static NSString *ID = @"gameDetail";

@interface CPGameDetailTableViewCell()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//下方弹出的下载view
@property (nonatomic, strong) UIView *bottomDownView;
@property (nonatomic, strong) UIButton *bottomDownButton;
@end

@implementation CPGameDetailTableViewCell

+ (instancetype)gameDetailCellCreate:(UITableView *)tableview
{
    CPGameDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
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
        bottomDownButton;
    });
    
    [self.bottomDownView addSubview:self.bottomDownButton];
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

#pragma mark cell中的tableview滚动属性判断
- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.myTableView.scrollEnabled = scrollEnabled;
    if (scrollEnabled) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.bottomDownView];
    }else{
        [self.bottomDownView removeFromSuperview];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma mark 返回每一组需要显示的头部标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark tableview的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //section == 2的headerView的Y值
    CGFloat headerY = scrollView.contentOffset.y;
    if (headerY < 0) {
        self.myTableView.scrollEnabled = NO;
    }
    CPLog(@"headerY = %f",headerY);
}

@end
