//
//  LCHelpViewController.m
//  LCDeals
//
//  Created by mac1 on 15/12/10.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCHelpViewController.h"

@interface LCHelpViewController ()

@end

@implementation LCHelpViewController

static NSString *const URLString = @"http://i.meituan.com/help/pay?ci=59&f=ios&lat=30.733712&lng=103.974426&msid=ADB716DC-7A5F-4466-B6E9-6769733CB88A2015-12-11-11-44475&token=d0VgztpcOz9OxuRhCl-5Bd9VQ58AAAAAHQEAAKgjpWqG1AC3SsJQ6EcQFAD66e8u42OSt5YIX2hP4KGt-9JECZtcXdR_PW-8kXN7qA&userid=81340531&utm_campaign=AgroupBgroupD100Gmore&utm_content=A07CA4F6CA7B63689B2274C5FE1D5D2979DB975AD2DBE08A40490217D4C713D1&utm_medium=iphone&utm_source=AppStore&utm_term=6.2.1&uuid=A07CA4F6CA7B63689B2274C5FE1D5D2979DB975AD2DBE08A40490217D4C713D1&version_name=6.2.1";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"帮助";
    [self setupSubViews];

}

- (void)setupSubViews
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    [self.view addSubview:webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [webView loadRequest:request];
}


@end
