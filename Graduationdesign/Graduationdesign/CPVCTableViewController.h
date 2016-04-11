//
//  CPVCTableViewController.h
//  Graduationdesign
//
//  Created by cheng on 16/4/11.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPGallaryModel;

@interface CPVCTableViewController : UITableViewController

/**
 *  传递过来的模型
 */
@property (nonatomic, copy) NSString *naviTitle;

@property (nonatomic, strong) CPGallaryModel *gallarymodel;
@end
