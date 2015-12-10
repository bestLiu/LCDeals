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

static NSString *const helpMsg = @"1、问：无法进行支付？\n答：当你点击确认充值或购买后，请不要关闭新打开的页面，否则充值或购买将无法完成。\n2、问：打开支付页面，提示“该页无法显示”或空白页，可能是什么原因？\n答：可能是由以下原因造成的：\n1）没有升级IE浏览器，导致加密级别过低，无法进入银行系统。\n2）上网环境或上网方式受限，可能是网络服务商限制，建议更换一种上网方式。\n3）尝试刷新页面；如果刷新不能解决问题，可能由于浏览器缓存设置的原因，请在IE菜单->工具->Internet选项->点击 “删除cookies”和“删除文件”，用以清除临时文件。\n3、银行页面打不开的解决方法？\n答：可能是由以下原因造成的：\n1）没有升级IE浏览器，导致加密级别过低，无法进入银行系统。\n2）如果是个人电脑，请关闭您的防火墙再试。\n3）在IE浏览器“工具”菜单->Internet选项->高级->安全，在SSL2.0和SSL3.0的选项前打勾。\n4）查看密钥长度是否支持128位(IE->帮助->关于Internet Explorer)，如果低于128，请升级密钥包。\n5）请您把银行网址在受信任的站点中添加进去，添加方法为：\n打开IE浏览器->工具->Internet选项->安全->受信任的站点->站点->添加网易宝和银行的网站，重启IE浏览器登录网易宝进行相关操作。\n4、还有什么其他问题可能导致付款不成功？\n答：1）所需支付金额超过了银行支付限额建议您登录网上银行提高上限额度，或是先分若干次充值到支付宝账户余额，即能轻松支付。\n2）支付宝页面显示错误或者空白部分网银对不同浏览器的兼容性有限，导致无法正常支付，建议您使用IE浏览器进行支付操作。\n3）提示“支付失败”怎么办?在银行页面提示支付失败，通常不会扣除银行卡费用。可能是由于网络传输或网银支付上限设置等原因所致，详情请咨询银行客服。\n4）网上银行已扣款，订单仍显示“未付款”可能由于银行的数据没有即时传输，请不要担心，稍后刷新页面查看。如较长时间仍显示未付款，可在115社区 6 7发帖求求，客服将在第一时间为你解决。\n5）如使用充值功能，充值完毕，但是账户余额内仍未到帐怎么办?充值过程一般即时开能，但出于银行对账原因，可能会有15-20分钟的延迟，如果20分钟之后仍然未到帐，可在115社区发帖求求，客服将在第一时间为你解决。";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"帮助";
    

}

- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)]
}


@end
