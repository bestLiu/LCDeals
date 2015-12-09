//
//  LCScanResultViewController.m
//  LCDeals
//
//  Created by mac1 on 15/12/1.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCScanResultViewController.h"

@interface LCScanResultViewController ()<UIWebViewDelegate>

@end

@implementation LCScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.resultUrlString]];
    [webView loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //js获取title
     NSString *str = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.navigationTitle = str;
}


@end
