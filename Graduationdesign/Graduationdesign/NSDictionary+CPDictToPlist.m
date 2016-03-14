//
//  NSDictionary+CPDictToPlist.m
//  Graduationdesign
//
//  Created by chengpeng on 16-3-1.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "NSDictionary+CPDictToPlist.h"

@implementation NSDictionary (CPDictToPlist)

- (void)dictToPlistWithPlistName:(NSString *)plistname
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",plistname]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:self, nil];
    [array writeToFile:filename atomically:YES];

}


+ (id)dictFromPlistWithPlistName:(NSString *)plistname;
{
    NSDictionary *dict = [NSDictionary dictionary];
    
    //读取文件
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString *readPath = [documentsPath stringByAppendingPathComponent:plistname];
    NSArray *fileContent = [[NSArray alloc] initWithContentsOfFile:readPath];
    dict = [fileContent firstObject];
    
    return dict;
}


@end
