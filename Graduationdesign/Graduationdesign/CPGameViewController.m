 //
//  CPGameViewController.m
//  Graduationdesign
//
//  Created by cheng on 16/4/6.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPGameViewController.h"
#import "CPTopCollectionViewCell.h"
#import "CPMiddleCollectionViewCell.h"
#import "CPBottomCollectionViewCell.h"
#import "CPCollectionReusableView.h"
#import "CPGameModel.h"
#import "CPVCTableViewController.h"
#import "CPTimeFreeTableVC.h"
#import "CPEachGameTableVC.h"

typedef NS_ENUM(NSInteger, CPClickType){
    CPClickTypeGarllary = 0,    //点击了上方的滚动相册
    CPClickTypeMiddle = 1,      //点击了中间的某个按钮
};

#define ITEMSNUMBER 1
#define SECTIONSNUMBER 3

#define TOPITEMS 1
#define MIDDLEITEMS 1

static NSString *topIdentifier = @"topCell";
static NSString *middleIdentifier = @"middleCell";
static NSString *bottomIdentifier = @"bottomCell";
static NSString *headerViewIdentifier = @"headerView";
static NSUInteger getCount = 10;


@interface CPGameViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CPTopCollectionViewCellDelegate,CPMiddleCollectionViewCellDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *newlistArray;
@property (nonatomic, strong) NSArray *hotlistArray;

@property (nonatomic, assign) CPClickType clickType;

@property (nonatomic, strong) CPGallaryModel *gallaryModel;
@property (nonatomic, strong) CPNewListModel *newlistModel;
@property (nonatomic, strong) CPHotListModel *hotlistModel;

/**
 *  选中的是新游推荐还是游戏热榜
 */
@property (nonatomic, readonly, getter = isSelectedNewGame) BOOL selectedNewGame;

@end

@implementation CPGameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"家庭娱乐"];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 3.0f;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerNib:[UINib nibWithNibName:@"CPTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:topIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"CPMiddleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:middleIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"CPBottomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bottomIdentifier];
    
    //ReusableView
    [collectionView registerNib:[UINib nibWithNibName:@"CPCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    self.collectionView = collectionView;
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:collectionView];
    
    //下拉刷新
    [self setupRefresh];
}

#pragma mark 侧滑 
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark- 刷新的方法
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.collectionView.headerPullToRefreshText = @"下拉刷新";
    self.collectionView.headerRefreshingText = @"载入中...";
    
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.collectionView.footerPullToRefreshText = @"上拉刷新";
    self.collectionView.footerRefreshingText = @"加载中...";
    
}

#pragma mark 下拉刷新
- (void)headerRereshing
{
    [self getGameDataFormNetwork:getCount];
    
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView headerEndRefreshing];
        
    });
}

#pragma mark 上拉刷新
- (void)footerRereshing
{
    //从网络请求数据
    //一次刷新10个数据
    getCount += 10;
    
    [self getGameDataFormNetwork:getCount];
    
    //2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.collectionView footerEndRefreshing];
        [self.collectionView reloadData];
    });
}
#pragma mark- <数组懒加载>
#pragma mark 新游推荐
- (NSArray *)newlistArray
{
    if (!_newlistArray) {
        _newlistArray = [CPSortModel sortModel].newlist;
    }
    return _newlistArray;
}

#pragma mark 游戏热榜
- (NSArray *)hotlistArray
{
    if (!_hotlistArray) {
        _hotlistArray = [CPSortModel sortModel].hotlist;
    }
    return _hotlistArray;
}

#pragma mark 从网络刷新数据
- (void)getGameDataFormNetwork:(NSUInteger)getcount;
{
    NSString *gameHttpUrl = @"http://cdn.4399sj.com/app/iphone/v2.2/home.html";
    NSString *gameHttpArg = [NSString stringWithFormat:@"start=%d&count=%ld",1,getCount];
    
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachefilename = [cacheDirectory stringByAppendingPathComponent:gameCacheName];
    //URL
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",gameHttpUrl,gameHttpArg];
    CPLog(@"GET地址%@",urlStr);
    
    AFHTTPSessionManager *httpMrg = [AFHTTPSessionManager manager];
    httpMrg.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpMrg GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //写入文件
            NSError *error;
            if ([responseObject writeToFile:cachefilename options:NSDataWritingAtomic error:&error]) {
                CPLog(@"写入缓存成功");
            }else{
                CPLog(@"写入缓存失败");
            }
        }else{
            CPLog(@"获取数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CPLog(@"失败%@",error);
    }];
    
    
    //重新加载数据
    self.newlistArray = nil;
    self.hotlistArray = nil;
}

#pragma mark <UICollectionView>的数据源
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SECTIONSNUMBER;
} 

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger items;
    if (section == 0) {
        items = TOPITEMS;
    }else if (section == 1){
        items = MIDDLEITEMS;
    }else if (section == 2){
        items = self.newlistArray.count + self.hotlistArray.count;
    }
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];

    if (indexPath.section == 0) {
        CPTopCollectionViewCell *topcell = [collectionView dequeueReusableCellWithReuseIdentifier:topIdentifier forIndexPath:indexPath];
        topcell.delegate = self;
        cell = topcell;
    }else if (indexPath.section == 1){
        CPMiddleCollectionViewCell *middlecell = [collectionView dequeueReusableCellWithReuseIdentifier:middleIdentifier forIndexPath:indexPath];
        middlecell.delegate = self;
        cell = middlecell;
          
    }else if (indexPath.section == 2){
        CPBottomCollectionViewCell *bottomcell = [collectionView dequeueReusableCellWithReuseIdentifier:bottomIdentifier forIndexPath:indexPath];
 
        CPNewListModel *newlistmodel = [CPNewListModel newListModelWithDict:self.newlistArray[indexPath.row / 2]];
        CPHotListModel *hotlistmodel = [CPHotListModel hotListModelWithDict:self.hotlistArray[indexPath.row / 2]];

        if (indexPath.row % 2 == 0) {
            //第一列
            bottomcell.newlistModel = newlistmodel;
        }else{
            //第二列
            bottomcell.hotlistModel = hotlistmodel;
        }
        cell = bottomcell;
    }
    CPLog(@"row=%ld,section=%ld",(long)indexPath.row,(long)indexPath.section);
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CPCollectionReusableView *collectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
    return collectionReusableView;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize layoutSize = CGSizeZero;
    if (indexPath.section == 0) {
        layoutSize = CGSizeMake(self.view.width, 120);
    }else if (indexPath.section == 1){
        layoutSize = CGSizeMake(self.view.width, 70);
    }else if (indexPath.section == 2){
        layoutSize = CGSizeMake(140, 125);
    }
    return layoutSize;
}
 

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = CGSizeZero;
    if (section == 2) {
        headerSize = CGSizeMake(self.view.width, 44);
    }
    return headerSize;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (section == 2) {
        edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return edgeInsets;
}

#pragma mark- <UICollectionViewDelegate>
#pragma mark  UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPNewListModel *newlistmodel = [CPNewListModel newListModelWithDict:self.newlistArray[indexPath.row / 2]];
    CPHotListModel *hotlistmodel = [CPHotListModel hotListModelWithDict:self.hotlistArray[indexPath.row / 2]];
    self.newlistModel = newlistmodel; 
    self.hotlistModel = hotlistmodel;
    
    NSString *host = @"http://cdn.4399sj.com";
    NSString *path = [[NSString alloc] init];
    NSString *fileID = [[NSString alloc] init];
    if (indexPath.row % 2 == 0) {
        //点击的是新游推荐
        
        path = [NSString stringWithFormat:@"/app/iphone/v2.2/game.html?id=%ld",(long)newlistmodel.id];
        fileID = [NSString stringWithFormat:@"%@-%ld",vcGameCacheName, (long)newlistmodel.id];
        _selectedNewGame = YES;
    }else{
        //点击的是游戏热榜
        path = [NSString stringWithFormat:@"/app/iphone/v2.2/game.html?id=%ld",(long)hotlistmodel.id];
        fileID = [NSString stringWithFormat:@"%@-%ld",vcGameCacheName, (long)hotlistmodel.id];
        _selectedNewGame = NO;
    }
    
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
                [self performSegueWithIdentifier:@"gameView2eachGame" sender:fileID];
                
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

#pragma mark 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark- <CPTopCollectionViewCellDelegate>
- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell VCGallaryModel:(CPGallaryModel *)gallaryModel
{
    CPLog(@"固定UI");
    self.clickType = CPClickTypeGarllary;
    self.gallaryModel = gallaryModel;
    
    //获取缓存目录
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //拼接请求网址 
    NSString *host = @"http://cdn.4399sj.com";
    
    NSRange range = [gallaryModel.url rangeOfString:@"?"];
    
    NSString *path = [NSString stringWithFormat:@"/app/iphone/v2.1/special-detail.html?%@&start=1&count=20",[gallaryModel.url substringFromIndex:range.location + 1]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"GET地址%@",urlStr);
     
    //路径
    NSString *fileID = [NSString stringWithFormat:@"%@-%@",vcGameCacheName,[gallaryModel.url substringFromIndex:range.location + 1]];
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
                [self performSegueWithIdentifier:@"gameHome2vc" sender:fileID];
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

- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell WebArticleGallaryModel:(CPGallaryModel *)gallaryModel
{
    CPLog(@"网页文章");
    self.gallaryModel = gallaryModel;
    
    UIViewController *webVC = [[UIViewController alloc] init];
    
    //自定义返回
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_normal"] style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    //自定义分享
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_share_black"] style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
    //自定义导航栏字体
    webVC.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"游戏攻略"];
    
    webVC.navigationItem.leftBarButtonItem = left;
    webVC.navigationItem.rightBarButtonItem = right; 
    webVC.hidesBottomBarWhenPushed = YES; 
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    //get网址
    NSRange range = [gallaryModel.url rangeOfString:@"?"];
    
    NSString *host = @"http://cdn.4399sj.com/"; 
    
    NSString *path = [NSString stringWithFormat:@"/service/iphone/v2.1/news.html?%@&gameId=0",[gallaryModel.url substringFromIndex:range.location + 1]];//@"/service/iphone/v2.1/news.html?id=619319&gameId=0";
    CPLog(@"id = %@",[gallaryModel.url substringToIndex:range.location]);
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"urlstr = %@",urlstr);
    //创建URL
    NSURL *url = [NSURL URLWithString:urlstr];
    
    //添加uiwebview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    
    //自动对页面进行缩放以适应屏幕
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webVC.view addSubview:webView];

}

- (void)topCollectionViewCell:(CPTopCollectionViewCell *)topCollectionViewCell WebGameGallaryModel:(CPGallaryModel *)gallaryModel
{
    CPLog(@"网页游戏");
    self.gallaryModel = gallaryModel;
    
    UIViewController *webVC = [[UIViewController alloc] init];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    
    //自定义返回
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_normal"] style:UIBarButtonItemStyleBordered target:self action:@selector(modalback)];
    //自定义分享
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_share_black"] style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
    //自定义导航栏字体
    webVC.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:gallaryModel.title];
    
    webVC.navigationItem.leftBarButtonItem = left;
    webVC.navigationItem.rightBarButtonItem = right;
    webVC.hidesBottomBarWhenPushed = YES;
    
    //设置navigationItemView的titleview
    UIView *titleView = ({
        CGSize titleSize = [NSString sizeWithText:self.gallaryModel.title font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
        label.font = MYITTMFONTSIZE;
        label.text = self.gallaryModel.title;
        [view addSubview:label];
        view;
    });
    [webVC.navigationItem setTitleView:titleView];
    
    [self presentViewController:naVC animated:YES completion:^{
        CPLog(@"modal");
    }]; 
    
    //创建URL
    NSURL *url = [NSURL URLWithString:gallaryModel.url];
    
    //添加uiwebview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    
    //自动对页面进行缩放以适应屏幕
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webVC.view addSubview:webView];

}

#pragma mark- <CPMiddleCollectionViewCellDelegate>
#pragma mark 必备
- (void)middleCollectionViewCellChooseNecessary:(CPMiddleCollectionViewCell *)cell
{
    //点击类型 
    self.clickType = CPClickTypeMiddle;
    
    //获取缓存目录
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    //拼接请求网址
    NSString *host = @"http://cdn.4399sj.com";
    NSString *path = @"/app/iphone/v2.1/special-detail.html?id=28&start=1&count=20";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"GET地址%@",urlStr);
    
    NSString *fileID = [NSString stringWithFormat:@"%@-%@",vcGameCacheName,@"id=28"];
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
                [self performSegueWithIdentifier:@"gameHome2vc" sender:fileID];
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

- (void)middleCollectionViewCellChooseGift:(CPMiddleCollectionViewCell *)cell{
}

- (void)middleCollectionViewCellChooseForum:(CPMiddleCollectionViewCell *)cell
{
    UIViewController *webVC = [[UIViewController alloc] init];
    
    //自定义返回
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_normal"] style:UIBarButtonItemStyleBordered target:self action:@selector(back)];

    //自定义导航栏字体
    webVC.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"游戏论坛"];
    
    webVC.navigationItem.leftBarButtonItem = left;
    webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    //get网址
    NSString *host = @"http://bbs.4399.cn";
    NSString *path = @"/m/?fromIOSNative=1";
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",host, path];
    CPLog(@"urlstr = %@",urlstr);
    
    //创建URL
    NSURL *url = [NSURL URLWithString:urlstr];
 
    //添加uiwebview
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    
    //自动对页面进行缩放以适应屏幕
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [webVC.view addSubview:webView];

}

- (void)middleCollectionViewCellChooseTimeFree:(CPMiddleCollectionViewCell *)cell
{
    //获取缓存目录
    NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //拼接请求网址(限时免费)
    NSString *host = @"http://cdn.4399sj.com";
    NSString *path1 = @"/app/iphone/v2.1/coupon.html?type=1&start=1&count=20";
    NSString *path2 = @"/app/iphone/v2.1/coupon.html?type=2&start=1&count=20";
    
    NSString *urlStr1 = [NSString stringWithFormat:@"%@%@",host, path1];
    NSString *urlStr2 = [NSString stringWithFormat:@"%@%@",host, path2];
    CPLog(@"GET地址%@",urlStr1);
    
    NSString *fileID1 = [NSString stringWithFormat:@"%@-%@",vcGameCacheName,@"type=1"];
    NSString *fileID2 = [NSString stringWithFormat:@"%@-%@",vcGameCacheName,@"type=2"];
    
    NSString *vccachefilename1 = [cacheDirectory stringByAppendingPathComponent:fileID1];
    NSString *vccachefilename2 = [cacheDirectory stringByAppendingPathComponent:fileID2];
    
    //segmented control 当前所选
    NSArray *segmentArray = @[fileID1, fileID2];
    
    //连接服务器get数据
    AFHTTPSessionManager *httpMrg = [AFHTTPSessionManager manager];
    httpMrg.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //限时免费
    [httpMrg GET:urlStr1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //写入文件
            NSError *error;
            if ([responseObject writeToFile:vccachefilename1 options:NSDataWritingAtomic error:&error]) {
                CPLog(@"写入缓存成功");
                [self performSegueWithIdentifier:@"gameHome2timeFree" sender:segmentArray];
            }else{
                CPLog(@"写入缓存失败");
            }
        }else{
            CPLog(@"获取数据为空");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CPLog(@"失败%@",error);
    }];
    
    //降价促销
    [httpMrg GET:urlStr2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            //写入文件
            NSError *error;
            if ([responseObject writeToFile:vccachefilename2 options:NSDataWritingAtomic error:&error]) {
                CPLog(@"写入缓存成功");
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

#pragma mark 添加segue进行判断
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //获取目标控制起的vc类型代理
    if ([segue.identifier isEqualToString:@"gameHome2vc"]) {
        CPVCTableViewController *vcTableview = segue.destinationViewController;
        vcTableview.clickID = sender;
    
        //设置navigationItemView的titleview
        UIView *titleView = ({
            CGSize titleSize = [NSString sizeWithText:self.gallaryModel.title font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
            label.font = MYITTMFONTSIZE;
            label.text = self.gallaryModel.title;
            [view addSubview:label];
            view;
        });
        
        [vcTableview.navigationItem setTitleView:titleView];
    }else if([segue.identifier isEqualToString:@"gameHome2timeFree"]){
        CPTimeFreeTableVC *timeFreeVC = segue.destinationViewController;
        timeFreeVC.segments = sender;
    }else if ([segue.identifier isEqualToString:@"gameView2eachGame"]){
        CPEachGameTableVC *eachgameVC = segue.destinationViewController;
        eachgameVC.fileID = sender;
        UIView *titleView = [[UIView alloc] init];
        if (self.selectedNewGame) {
            //新游推荐
            titleView = ({
                CGSize titleSize = [NSString sizeWithText:self.newlistModel.name font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
                label.font = MYITTMFONTSIZE;
                label.text = self.newlistModel.name;
                [view addSubview:label];
                view;
            });
        }else{
            //热榜游戏
            titleView = ({
                CGSize titleSize = [NSString sizeWithText:self.hotlistModel.name font:MYITTMFONTSIZE maxSize:CPMAXSIZE];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
                label.font = MYITTMFONTSIZE;
                label.text = self.hotlistModel.name;
                [view addSubview:label];
                view;
            });
        }
        [eachgameVC.navigationItem setTitleView:titleView];
    }
}


#pragma mark UINavigationController
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modalback
{
    [self dismissViewControllerAnimated:YES completion:^{
        CPLog(@"modal back");
    }];
}

- (void)share
{
    
    
}

@end
