//
//  CPWDataBottomView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-7.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPWDataBottomView.h"
#import "CPWeatherConnect.h"

#define CPAVERHEIGHT self.height / 6
#define CPLABELFONT [UIFont systemFontOfSize:11.0]
#define CPLABELSIZE [NSString sizeWithText:@"紫外线指数" font:CPLABELFONT maxSize:CPMAXSIZE]

#define CPDETAILFONT [UIFont systemFontOfSize:11.0]

@interface CPWDataBottomView()

//每个view方便布局
@property (weak,nonatomic) UIView *view_0;
/**
 *  紫外线指数
 */
@property (weak,nonatomic) UILabel *uvLabel;
@property (weak,nonatomic) UILabel *uvDetailLabel;
@property (copy,nonatomic) NSString *uvDetailLabelstr;


@property (weak,nonatomic) UIView *view_1;
/**
 *  穿衣指数
 */
@property (weak,nonatomic) UILabel *drsgLabel;
@property (weak,nonatomic) UILabel *drsgDetailLabel;
@property (copy,nonatomic) NSString *drsgDetailLabelstr;

@property (weak,nonatomic) UIView *view_2;
/**
 *  运动指数
 */
@property (weak,nonatomic) UILabel *sportLabel;
@property (weak,nonatomic) UILabel *sportDetailLabel;
@property (copy,nonatomic) NSString *sportDetailLabelstr;

@property (weak,nonatomic) UIView *view_3;
/**
 *  洗车指数
 */
@property (weak,nonatomic) UILabel *cwLabel;
@property (weak,nonatomic) UILabel *cwDetailLabel;
@property (copy,nonatomic) NSString *cwDetailLabelstr;

@property (weak,nonatomic) UIView *view_4;
/**
 *  感冒指数
 */
@property (weak,nonatomic) UILabel *fluLabel;
@property (weak,nonatomic) UILabel *fluDetailLabel;
@property (copy,nonatomic) NSString *fluDetailLabelstr;

@property (weak,nonatomic) UIView *view_5;
/**
 *  旅游指数
 */
@property (weak,nonatomic) UILabel *travLabel;
@property (weak,nonatomic) UILabel *travDetailLabel;
@property (copy,nonatomic) NSString *travDetailLabelstr;



@end

@implementation CPWDataBottomView

- (instancetype)init
{
    if (self = [super init]) {
        //设置参数
        [[[CPWeatherConnect alloc] init] setWeatherDataBlock:^(NSDictionary *suggestion) {
            self.uvDetailLabelstr = suggestion[@"uv"];
            CPLog(@"===============%@",self.uvDetailLabelstr);
            self.drsgDetailLabelstr = suggestion[@"drsg"];
            self.sportDetailLabelstr = suggestion[@"sport"];
            self.cwDetailLabelstr = suggestion[@"cw"];
            self.fluDetailLabelstr = suggestion[@"flu"];
            self.travDetailLabelstr = suggestion[@"trav"];
        }];
        //紫外线指数
        UIView *view_0 = [[UIView alloc] init];
        self.view_0 = view_0;
        [self addSubview:view_0];
        
        UILabel *uvLabel = [[UILabel alloc] init];
        self.uvLabel = uvLabel;
        self.uvLabel.font = CPLABELFONT;
        [view_0 addSubview:uvLabel];
        
        UILabel *uvDetailLabel = [[UILabel alloc] init];
        self.uvDetailLabel = uvDetailLabel;
        self.uvDetailLabel.font = CPLABELFONT;
        self.uvDetailLabel.textAlignment = NSTextAlignmentRight;
        self.uvDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_0 addSubview:uvDetailLabel];
        
        //穿衣指数
        UIView *view_1 = [[UIView alloc] init];
        self.view_1 = view_1;
        [self addSubview:view_1];
        
        UILabel *drsgLabel = [[UILabel alloc] init];
        self.drsgLabel = drsgLabel;
        self.drsgLabel.font = CPLABELFONT;
        [view_1 addSubview:drsgLabel];
        
        UILabel *drsgDetailLabel = [[UILabel alloc] init];
        self.drsgDetailLabel = drsgDetailLabel;
        self.drsgDetailLabel.font = CPLABELFONT;
        self.drsgDetailLabel.textAlignment = NSTextAlignmentRight;
        self.drsgDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_1 addSubview:drsgDetailLabel];
        
        
        //运动指数
        UIView *view_2 = [[UIView alloc] init];
        self.view_2 = view_2;
        [self addSubview:view_2];
        
        UILabel *sportLabel = [[UILabel alloc] init];
        self.sportLabel = sportLabel;
        self.sportLabel.font = CPLABELFONT;
        [view_2 addSubview:sportLabel];
        
        UILabel *sportDetailLabel = [[UILabel alloc] init];
        self.sportDetailLabel = sportDetailLabel;
        self.sportDetailLabel.font = CPLABELFONT;
        self.sportDetailLabel.textAlignment = NSTextAlignmentRight;
        self.sportDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_2 addSubview:sportDetailLabel];
        
        //洗车指数
        UIView *view_3 = [[UIView alloc] init];
        self.view_3 = view_3;
        [self addSubview:view_3];
        
        UILabel *cwLabel = [[UILabel alloc] init];
        self.cwLabel = cwLabel;
        self.cwLabel.font = CPLABELFONT;
        [view_3 addSubview:cwLabel];
        
        UILabel *cwDetailLabel = [[UILabel alloc] init];
        self.cwDetailLabel = cwDetailLabel;
        self.cwDetailLabel.font = CPLABELFONT;
        self.cwDetailLabel.textAlignment = NSTextAlignmentRight;
        self.cwDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_3 addSubview:cwDetailLabel];
        
        //感冒指数
        UIView *view_4 = [[UIView alloc] init];
        self.view_4 = view_4;
        [self addSubview:view_4];
        
        UILabel *fluLabel = [[UILabel alloc] init];
        self.fluLabel = fluLabel;
        self.fluLabel.font = CPLABELFONT;
        [view_4 addSubview:fluLabel];
        
        UILabel *fluDetailLabel = [[UILabel alloc] init];
        self.fluDetailLabel = fluDetailLabel;
        self.fluDetailLabel.font = CPLABELFONT;
        self.fluDetailLabel.textAlignment = NSTextAlignmentRight;
        self.fluDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_4 addSubview:fluDetailLabel];
        
        //旅游指数
        UIView *view_5 = [[UIView alloc] init];
        self.view_5 = view_5;
        [self addSubview:view_5];
        
        UILabel *travLabel = [[UILabel alloc] init];
        self.travLabel = travLabel;
        self.travLabel.font = CPLABELFONT;
        [view_5 addSubview:travLabel];
        
        UILabel *travDetailLabel = [[UILabel alloc] init];
        self.travDetailLabel = travDetailLabel;
        self.travDetailLabel.font = CPLABELFONT;
        self.travDetailLabel.textAlignment = NSTextAlignmentRight;
        self.travDetailLabel.textColor = CP_RGB(65, 151, 242);
        [view_5 addSubview:travDetailLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    //紫外线指数
    self.view_0.frame = CGRectMake(0, 0, CPWINDOWWIDTH, CPAVERHEIGHT);
//    self.view_0.backgroundColor = [UIColor redColor];
    
    self.uvLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.uvLabel.centerY = self.view_0.centerY;
    self.uvLabel.text = @"紫外线指数";
    
    
    //紫外线指数的尺寸
    CGSize uvSize = [NSString sizeWithText:self.uvDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.uvDetailLabel.frame = CGRectMake(0, 0, uvSize.width, uvSize.height);
    self.uvDetailLabel.text = self.uvDetailLabelstr;
    self.uvDetailLabel.centerY = self.view_0.centerY;
    self.uvDetailLabel.x = self.view_0.width - uvSize.width - 20;
    
    //分割线
    UIView *upadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    upadding.backgroundColor = [UIColor lightGrayColor];
    upadding.alpha = 0.3;
    [self.view_0 addSubview:upadding];
    
    
    //穿衣指数
    self.view_1.frame = CGRectMake(0, CPAVERHEIGHT, CPWINDOWWIDTH, CPAVERHEIGHT);
//    self.view_1.backgroundColor = [UIColor blueColor];
    
    self.drsgLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.drsgLabel.centerY = self.view_1.centerY - self.view_1.y;
    self.drsgLabel.text = @"穿衣指数";
    
    //穿衣指数的尺寸
    CGSize drsgSize = [NSString sizeWithText:self.drsgDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.drsgDetailLabel.frame = CGRectMake(0, 0, drsgSize.width, drsgSize.height);
    self.drsgDetailLabel.text = self.drsgDetailLabelstr;
    self.drsgDetailLabel.centerY = self.view_1.centerY - self.view_1.y;
    self.drsgDetailLabel.x = self.view_1.width - drsgSize.width - 20;
    
    //分割线
    UIView *dpadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    dpadding.backgroundColor = [UIColor lightGrayColor];
    dpadding.alpha = 0.3;
    [self.view_1 addSubview:dpadding];
    
    
    //运动指数
    self.view_2.frame = CGRectMake(0, CPAVERHEIGHT * 2, CPWINDOWWIDTH, CPAVERHEIGHT);
//    self.view_2.backgroundColor = [UIColor yellowColor];
    
    self.sportLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.sportLabel.centerY = self.view_2.centerY - self.view_2.y;
    self.sportLabel.text = @"运动指数";
    
    //运动指数的尺寸
    CGSize sportSize = [NSString sizeWithText:self.sportDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.sportDetailLabel.frame = CGRectMake(0, 0, sportSize.width, sportSize.height);
    self.sportDetailLabel.text = self.sportDetailLabelstr;
    self.sportDetailLabel.centerY = self.view_2.centerY - self.view_2.y;
    self.sportDetailLabel.x = self.view_2.width - sportSize.width - 20;
    
    //分割线
    UIView *spadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    spadding.backgroundColor = [UIColor lightGrayColor];
    spadding.alpha = 0.3;
    [self.view_2 addSubview:spadding];
    
    
    //洗车指数
    self.view_3.frame = CGRectMake(0, CPAVERHEIGHT * 3, CPWINDOWWIDTH, CPAVERHEIGHT);
    
    self.cwLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.cwLabel.centerY = self.view_3.centerY - self.view_3.y;
    self.cwLabel.text = @"洗车指数";

    //洗车指数的尺寸
    CGSize cwSize = [NSString sizeWithText:self.cwDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.cwDetailLabel.frame = CGRectMake(0, 0, cwSize.width, cwSize.height);
    self.cwDetailLabel.text = self.cwDetailLabelstr;
    self.cwDetailLabel.centerY = self.view_3.centerY - self.view_3.y;
    self.cwDetailLabel.x = self.view_3.width - cwSize.width - 20;

    
    //分割线
    UIView *cpadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    cpadding.backgroundColor = [UIColor lightGrayColor];
    cpadding.alpha = 0.3;
    [self.view_3 addSubview:cpadding];

    //感冒指数
    self.view_4.frame = CGRectMake(0, CPAVERHEIGHT * 4, CPWINDOWWIDTH, CPAVERHEIGHT);

    self.fluLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.fluLabel.centerY = self.view_4.centerY - self.view_4.y;
    self.fluLabel.text = @"感冒指数";
    
    //感冒指数的尺寸
    CGSize fluSize = [NSString sizeWithText:self.fluDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.fluDetailLabel.frame = CGRectMake(0, 0, fluSize.width, fluSize.height);
    self.fluDetailLabel.text = self.fluDetailLabelstr;
    self.fluDetailLabel.centerY = self.view_4.centerY - self.view_4.y;
    self.fluDetailLabel.x = self.view_4.width - fluSize.width - 20;
    
    //分割线
    UIView *fpadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    fpadding.backgroundColor = [UIColor lightGrayColor];
    fpadding.alpha = 0.3;
    [self.view_4 addSubview:fpadding];
    
    //旅游指数
    self.view_5.frame = CGRectMake(0, CPAVERHEIGHT * 5, CPWINDOWWIDTH, CPAVERHEIGHT);
    
    self.travLabel.frame = CGRectMake(20, 0, CPLABELSIZE.width, CPLABELSIZE.height);
    self.travLabel.centerY = self.view_5.centerY - self.view_5.y;
    self.travLabel.text = @"旅游指数";
    
    //旅游指数的尺寸
    CGSize travSize = [NSString sizeWithText:self.travDetailLabelstr font:CPDETAILFONT maxSize:CPMAXSIZE];
    self.travDetailLabel.frame = CGRectMake(0, 0, travSize.width, travSize.height);
    self.travDetailLabel.text = self.travDetailLabelstr;
    self.travDetailLabel.centerY = self.view_5.centerY - self.view_5.y;
    self.travDetailLabel.x = self.view_5.width - travSize.width - 20;
    
    //分割线
    UIView *tpadding = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 1)];
    tpadding.backgroundColor = [UIColor lightGrayColor];
    tpadding.alpha = 0.3;
    [self.view_5 addSubview:tpadding];
    
}

@end
