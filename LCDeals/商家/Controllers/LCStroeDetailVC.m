//
//  LCStroeDetailVC.m
//  LCDeals
//
//  Created by mac1 on 15/11/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCStroeDetailVC.h"


@interface LCStroeDetailVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LCStroeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"商户详情";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.store.business_url]]];
    [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];

}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    NSMutableString *js = [NSMutableString string];
    // 删除header
    [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
    [js appendString:@"header.parentNode.removeChild(header);"];
    
    // 删除下面的点评网信息
    [js appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
    [js appendString:@"footer.parentNode.removeChild(footer);"];
    
    // 删除 APP下单.....
    [js appendString:@"var btnBlock = document.getElementsByClassName('btnBlock')[0];"];
    [js appendString:@"btnBlock.parentNode.removeChild(btnBlock);"];
    
    //删除底部查找模块
    [js appendString:@"var homeSearch = document.getElementsByClassName('home-search')[0];"];
    [js appendString:@"homeSearch.parentNode.removeChild(homeSearch);"];
    
    [js appendString:@"var simpleSearch = document.getElementsByClassName('simpleFunction')[0];"];
    [js appendString:@"simpleSearch.parentNode.removeChild(simpleSearch);"];
    [webView stringByEvaluatingJavaScriptFromString:js]; //执行JS代码
    
//    NSLog(@"absoluteString--->>>>>%@",webView.request.URL.absoluteString);
//    if ([webView.request.URL.absoluteString isEqualToString:self.store.business_url]) {
//        // 旧的HTML5页面加载完毕
//       
//    } else { // 详情页面加载完毕
        // 用来拼接所有的JS
//    }
//     获得页面
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        NSLog(@"%@",html);
}



@end
