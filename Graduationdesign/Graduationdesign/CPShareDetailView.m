//
//  CPShareDetailView.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-9.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPShareDetailView.h"

@interface CPShareDetailView()
- (IBAction)miliaoShare:(id)sender;
- (IBAction)weixinShare:(id)sender;
- (IBAction)friendShare:(id)sender;
- (IBAction)weiboShare:(id)sender;

@end

@implementation CPShareDetailView

- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CPShareDetailView" owner:nil options:nil] lastObject];
    }
    return self;

}



- (IBAction)miliaoShare:(id)sender{
}

- (IBAction)weixinShare:(id)sender {
}

- (IBAction)friendShare:(id)sender {
}

- (IBAction)weiboShare:(id)sender {
}
@end
