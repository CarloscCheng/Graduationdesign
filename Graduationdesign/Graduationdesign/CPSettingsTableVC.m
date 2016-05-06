//
//  CPSettingsTableVC.m
//  Graduationdesign
//
//  Created by cheng on 16/4/22.
//  Copyright © 2016年 chengpeng. All rights reserved.
//

#import "CPSettingsTableVC.h"
#import "CPFileService.h"

@implementation CPSettingsTableVC
- (void)viewDidLoad{
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"设置"];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CPLog(@"select cell %@",cell.textLabel.text);
    
    if ([cell.textLabel.text isEqualToString:@"清除缓存"]) {
        
        NSString* cacheDirectory  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *message = [NSString stringWithFormat:@"缓存大小为%0.02fM.确定要清除缓存吗?",[CPFileService folderSizeAtPath:cacheDirectory]];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [MBProgressHUD showSuccess:@"清除缓存成功"];
            [CPFileService clearCache:cacheDirectory]; 
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action2];
        [alert addAction:action1];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

@end
