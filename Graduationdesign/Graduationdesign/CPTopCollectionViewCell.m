//
//  CPTopCollectionViewCell.m
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPTopCollectionViewCell.h"
#import "CPGameModel.h"
#import "CPTopImgCell.h"

@interface CPTopCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource,CPTopImgCellDelegate>
/**
 *  顶部的collectionviewcell中的collectionview
 */
@property (weak, nonatomic) IBOutlet UICollectionView *myTopCollectionView;

/**
 *  分页Control
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//返回游戏数据的数组
@property (nonatomic, strong) NSArray *topDataArray;
@end

static NSString *imgIdentifier = @"imgCell";

@implementation CPTopCollectionViewCell

- (void)awakeFromNib {  
    // Initialization code
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.myTopCollectionView.collectionViewLayout = flowLayout;
     
    // 设置行之间间隔
    flowLayout.minimumLineSpacing = 0;
    
    //设置代理和数据源
    self.myTopCollectionView.delegate = self;
    self.myTopCollectionView.dataSource = self;
    self.myTopCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.myTopCollectionView registerNib:[UINib nibWithNibName:@"CPTopImgCell" bundle:nil] forCellWithReuseIdentifier:imgIdentifier];
    
    //滚动条不可见
    self.myTopCollectionView.showsHorizontalScrollIndicator = NO;

    //分页
    self.myTopCollectionView.pagingEnabled = YES;
    
    //分页数
    self.pageControl.numberOfPages = self.topDataArray.count;

}
#pragma mark 懒加载
- (NSArray *)topDataArray
{
    if (!_topDataArray) {
        //因为程序一启动就已经加载数据到缓存了，所以界面出现从缓存中加，下拉刷新在判断是否和网页端数据同步
        _topDataArray = [CPSortModel sortModel].gallary;
    }
    return _topDataArray;
}


#pragma mark <UICollectionView>的数据源
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CPLog(@"top count=%lu",(unsigned long)self.topDataArray.count);
    return self.topDataArray.count; 
} 

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CPTopImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgIdentifier forIndexPath:indexPath];
    CPLog(@"cell%p====row = %ld/section-%ld",cell, (long)indexPath.row, (long)indexPath.section);
    CPGallaryModel *gallarymodel = [CPGallaryModel gallaryModelWithDict:self.topDataArray[indexPath.row]];
    
    cell.gallaryModel = gallarymodel;
    self.pageControl.currentPage = indexPath.row;
    
    return cell; 
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.myTopCollectionView.width, self.myTopCollectionView.height);
}


#pragma mark- <UICollectionViewDelegate>
#pragma mark  UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPLog(@"第几个cell被选中row=%ld---section=%ld",(long)indexPath.row, (long)indexPath.section);
    CPTopImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgIdentifier forIndexPath:indexPath];
    CPGallaryModel *gallarymodel = [CPGallaryModel gallaryModelWithDict:self.topDataArray[indexPath.row]];

    //设置代理
    cell.delegate = self;
    cell.gallaryModel = gallarymodel;
}

#pragma mark 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark <CPTopImgCellDelegate>代理
- (void)topImgCellClick:(CPTopImgCell *)topimgcell GallaryModel:(CPGallaryModel *)gallaryModel
{
    if (gallaryModel.type == 2) {
        if ([self.delegate respondsToSelector:@selector(topCollectionViewCell:VCGallaryModel:)]) {
            [self.delegate topCollectionViewCell:self VCGallaryModel:gallaryModel];
        }
        
    }else if (gallaryModel.type == 3){
        if ([self.delegate respondsToSelector:@selector(topCollectionViewCell:WebArticleGallaryModel:)]) {
            [self.delegate topCollectionViewCell:self WebArticleGallaryModel:gallaryModel];
        }
    }else if (gallaryModel.type == 7){
        if ([self.delegate respondsToSelector:@selector(topCollectionViewCell:WebGameGallaryModel:)]) {
            [self.delegate topCollectionViewCell:self WebGameGallaryModel:gallaryModel];
        }
    }
}
@end
