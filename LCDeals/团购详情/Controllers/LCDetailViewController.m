//
//  LCDetailViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCDetailViewController.h"
#import "LCDealTool.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"

@interface LCDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *puchaseButton;

@end

@implementation LCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"详情";
    [self setupLoadView];
}

- (void)setupLoadView
{
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(SCREEN_WIDTH - 60, -8 , 60, 60);
    [collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"icon_collect_highlighted"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:collectButton];
    collectButton.selected = [LCDealTool isCollect:self.deal];
    
    UIButton *sharedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sharedButton.frame = CGRectMake(CGRectGetMinX(collectButton.frame) - 40, -8, 60, 60);
    [sharedButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [sharedButton setImage:[UIImage imageNamed:@"icon_share_highlighted"] forState:UIControlStateHighlighted];
    [sharedButton addTarget:self action:@selector(sharedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:sharedButton];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    NSLog(@"%@",self.deal.deal_h5_url);
    [SVProgressHUD showWithStatus:@"请稍候..." maskType:SVProgressHUDMaskTypeClear];

}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self addPuchaseButton];
    NSLog(@"absoluteString____%@",webView.request.URL.absoluteString);
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        // 旧的HTML5页面加载完毕
        NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location + 1];
        NSString *urlStr = [NSString stringWithFormat:@"http://lite.m.dianping.com/group/deal/moreinfo/%@", ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    } else { // 详情页面加载完毕
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var buyBox = document.getElementsByClassName('buy-box')[0];"];
        [js appendString:@"buyBox.parentNode.removeChild(buyBox);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        
        // 删除下面的点评网信息
        [js appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
        [js appendString:@"footer.parentNode.removeChild(footer);"];

        // 删除 APP下单.....
        [js appendString:@"var fixButton = document.getElementsByClassName('footer-btn-fix')[0];"];
        [js appendString:@"fixButton.parentNode.removeChild(fixButton);"];
        [webView stringByEvaluatingJavaScriptFromString:js];
    
    }
    // 获得页面
//    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//    NSLog(@"%@",html);
}

- (void)addPuchaseButton
{
    _puchaseButton.hidden = NO;
    _puchaseButton.layer.cornerRadius = 4;
    _puchaseButton.layer.masksToBounds = YES;
    [_puchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [_puchaseButton setBackgroundImage:[LCTool imageWithColor:[UIColor orangeColor] andSize:_puchaseButton.frame.size] forState:UIControlStateNormal];
    [_puchaseButton setBackgroundImage:[LCTool imageWithColor:[UIColor grayColor] andSize:_puchaseButton.frame.size] forState:UIControlStateHighlighted];
}

//收藏团购
- (void)collectButtonAction:(UIButton *)button
{
    if (button.isSelected) { // 取消收藏
        [LCDealTool removeCollect:self.deal];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];

    } else { // 收藏
        [LCDealTool addCollect:self.deal];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    }
    
    // 按钮的选中取反
    button.selected = !button.isSelected;
    
}
- (void)sharedButtonAction:(UIButton *)button
{
     // TODO 集成友盟分享
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_deal.image_url]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"566786b7e0f55a0f5200207a"
                                          shareText:_deal.desc
                                     shareImage:[UIImage imageWithData:imageData]
                                    shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter]
                                           delegate:nil];

}


- (IBAction)buttonClick:(id)sender {
    //立即购买 集成支付宝，购买界面
    
}

@end
