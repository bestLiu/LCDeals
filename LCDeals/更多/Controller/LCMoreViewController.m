//
//  LCMoreViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//



#import "LCMoreViewController.h"
#import "LCMoreTableViewCell.h"
#import "LCScanViewController.h"
#import "UMFeedback.h"
#import "LCAboutUSViewController.h"
#import "LCHelpViewController.h"
#import "SDImageCache.h"

@interface LCMoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic)SDImageCache *imageCache;

@end

@implementation LCMoreViewController

static NSString *const reuseIdentifier = @"moreCell";

- (NSMutableArray *)datas
{
    if (!_datas) {
        NSUInteger tempSize = [self.imageCache getSize];
        NSString *tempSizeStr = [NSString stringWithFormat:@"%.2f",tempSize/1000.0/1000.0];
        NSMutableDictionary  *mutableDic = [NSMutableDictionary dictionaryWithObject:@"清空缓存" forKey:kCell_Title];
        [mutableDic setObject:tempSizeStr forKey:kCell_count];
        
        NSMutableArray *section1 = @[@{kCell_Title : @"扫一扫",kCell_Arrow : @"right_arrow"}].copy;
        NSMutableArray *section2 = @[@{kCell_Title : @"省流量模式", kCell_Switch : @"1"},
                                     @{kCell_Title : @"分享",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"消息设置",kCell_Arrow : @"right_arrow"},
                                       mutableDic].copy;
        NSMutableArray *section3 = @[@{kCell_Title : @"意见反馈",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"关于我们",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"帮助",kCell_Arrow : @"right_arrow"}].copy;
        NSMutableArray *section4 = @[@{kCell_Title : @"退出当前账号", @"islast":@YES}].copy;
        _datas = [[NSMutableArray alloc] initWithObjects:section1,section2,section3,section4, nil];
    }
    
    return _datas;
}
- (SDImageCache *)imageCache
{
    if (!_imageCache) {
        self.imageCache = [SDImageCache sharedImageCache];
    }
    return _imageCache;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"更多";
    [self setupSubviews];
    
    
    
    
}

- (void)setupSubviews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"LCMoreTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    _tableView = tableView;
}
#pragma mark - UITableView  delegate  and  datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArr = self.datas[section];
    return rowArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.datas = self.datas[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0://扫一扫
        {
            [self push2ScanViewController];    
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0://省流量模式
                {
                    
                }
                    break;
                case 1://分享
                {
                    
                }
                    break;
                case 2://消息设置
                {
                    
                }
                    break;
                case 3://清空缓存
                {
                    NSString *msg = [NSString stringWithFormat:@"当前缓存：%.2fM\n确认清理",[self.imageCache getSize]/1000.0/1000.0];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.imageCache clearDiskOnCompletion:^{
                            //改变数据源
                            NSMutableDictionary *dic = _datas[indexPath.section][indexPath.row];
                            NSUInteger tempSize = [self.imageCache getSize];
                            NSString *tempSizeStr = [NSString stringWithFormat:@"%.2f",tempSize/1000.0/1000.0];
                            [dic setObject:tempSizeStr forKey:kCell_count];
                            
                            //刷新表
                            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }];
                        
                    }];
                    [alertController addAction:actionCancel];
                    [alertController addAction:actionConfirm];
                    [self presentViewController:alertController animated:YES completion:nil];

                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0://反馈
                {
                    [self.navigationController setNavigationBarHidden:NO animated:NO];
                    [self pushViewController:[UMFeedback feedbackViewController] animated:YES];
                }
                    break;
                case 1://关于我们
                {
                    LCAboutUSViewController *abountVC = [[LCAboutUSViewController alloc] init];
                    [self pushViewController:abountVC animated:YES];
                }
                    break;
                case 2://帮助中心
                {
                    LCHelpViewController *helpVC= [[LCHelpViewController alloc] init];
                    [self pushViewController:helpVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            //退出
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //确认退出
                //1.清理沙盒
                [userDefaults removeObjectForKey:kUserInfoKey];
                [userDefaults removeObjectForKey:kUDCityNameKey];
                
                //2.告诉外面的控制器
                [LCNotifiCationCenter postNotificationName:LCMoreViewControllerExitSucceed object:self];
                
            }];
            [alertController addAction:actionCancel];
            [alertController addAction:actionConfirm];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)push2ScanViewController
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
    LCScanViewController *scanViewController = [[LCScanViewController alloc] init];
    scanViewController.style = style;
    [self pushViewController:scanViewController animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

@end
