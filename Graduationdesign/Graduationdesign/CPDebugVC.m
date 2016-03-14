//
//  CPDebugVC.m
//  Graduationdesign
//
//  Created by chengpeng on 16-2-26.
//  Copyright (c) 2016年 chengpeng. All rights reserved.
//

#import "CPDebugVC.h"

@interface CPDebugVC ()



@end

@implementation CPDebugVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //自定义导航栏字体
    self.navigationItem.titleView = [UIView navigationItemFontSize:MYITTMFONTSIZE WithTitle:@"敬请期待"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:button];
    
}
-(void)request: (NSString*)httpUrl
{
    CPLog(@"接受测试");
    httpUrl = @"https://api.heweather.com/x3/citylist?search=allchina&key=4bee9c367a5e40d9b46f22652d7b2996";
    NSURL *url = [NSURL URLWithString: httpUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, (long)connectionError.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//            strValue += StrDate + "\r\n";
            
            NSDictionary *weatherdict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [weatherdict dictToPlistWithPlistName:@"placeData.plist"];
        }
//        return strValue;
    }];

}

//- (IBAction)debugBtn
//{
//    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
//    NSString *httpArg = @"city=beijing";
//    [self request: httpUrl withHttpArg: httpArg];
//    
//    -(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
//        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
//        NSURL *url = [NSURL URLWithString: urlStr];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
//        [request setHTTPMethod: @"GET"];
//        [request addValue: @"您自己的apikey" forHTTPHeaderField: @"apikey"];
//        [NSURLConnection sendAsynchronousRequest: request
//                                           queue: [NSOperationQueue mainQueue]
//                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
//                                   if (error) {
//                                       NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
//                                   } else {
//                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                                       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                       NSLog(@"HttpResponseCode:%ld", responseCode);
//                                       NSLog(@"HttpResponseBody %@",responseString);
//                                   }
//                               }];
//    }
//}
    
    
@end
