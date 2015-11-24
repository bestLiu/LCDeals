//
//  LCStroeViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCStroeViewController.h"
#import "DPAPI.h"

@interface LCStroeViewController ()<DPRequestDelegate>



@end

@implementation LCStroeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"商家";
    [self setupSubViews];
}

- (void)setupSubViews
{
    NSString *urlString = @"v1/business/find_businesses";
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    if (cityName.length > 0) {
        params[@"city"] = @"成都";
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
//    }
    
    [api requestWithURL:urlString params:params delegate:self];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
}


@end
