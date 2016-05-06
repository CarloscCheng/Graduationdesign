//
//  CPStrategyTableViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/23.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPStrategyTableViewCell.h"
#import "CPStrategyCell.h"
#import "CPGameInfo.h"

@interface CPStrategyTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSArray *strategyList;
@end

@implementation CPStrategyTableViewCell

+ (instancetype)gameStrategyCellCreate:(UITableView *)tableview
{
    CPStrategyTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([CPStrategyTableViewCell class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPStrategyTableViewCell" owner:nil options:nil] lastObject];
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

- (NSArray *)strategyList
{
    if (_strategyList == nil) {
        CPGameStrategy *gameStrategy = [CPGameStrategy gameStrategyWithDict:self.gameResultModel.strategy];
        _strategyList = gameStrategy.list;
    }
    return _strategyList;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.strategyList.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPStrategyCell *cell = [CPStrategyCell strategyCellCreate:tableView];
    cell.gameStrategyList = [CPGameStrategyList gameStrategyListWithDict:self.strategyList[indexPath.row]];//self.strategyList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
