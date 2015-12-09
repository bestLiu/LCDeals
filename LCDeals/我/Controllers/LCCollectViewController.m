//
//  LCCollectViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/26.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCCollectViewController.h"
#import "LCMainTableViewCell.h"
#import "LCDealTool.h"
#import "Masonry.h"
#import "LCDetailViewController.h"
#import "UMSocial.h"


@interface LCCollectViewController ()<UITableViewDataSource, UITableViewDelegate,UMSocialUIDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *noDataView;
@property (strong, nonatomic) NSMutableArray *deals;

@end

@implementation LCCollectViewController

static NSString *const reuseIdentifier = @"mainCell";

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] initWithArray:[LCDealTool collectDeals:1]];
        
    }
    return _deals;
}
- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        noDataView.frame = CGRectMake(0, 0, 248, 150);
        noDataView.center = self.view.center;
        [self.view addSubview:noDataView];
        self.noDataView = noDataView;
    }
    return _noDataView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"我的收藏";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 120;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"LCMainTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView = tableView;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.deals removeAllObjects];
    [self.deals addObjectsFromArray:[LCDealTool collectDeals:1]];
    self.noDataView.hidden = self.deals.count != 0;
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCDetailViewController *detaileVc = [[LCDetailViewController alloc] init];
    detaileVc.deal = self.deals[indexPath.row];
    [self pushViewController:detaileVc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
// TODO 集成友盟分享
        [UMSocialSnsService presentSnsIconSheetView:self
    appKey:@"566786b7e0f55a0f5200207a"
    shareText:@"你要分享的文字"
    shareImage:[UIImage imageNamed:@"icon.png"]
    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToYXSession,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToTencent,nil]
    delegate:self];
        
        _tableView.editing = NO;
    }];
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       //找到对应的团购信息
        LCDeal *dealtoDelete = self.deals[indexPath.row];
        //从数据库里面删除
        [LCDealTool removeCollect:dealtoDelete];
        
        //从数据源中删除
        [weakSelf.deals removeObjectAtIndex:indexPath.row];
        
        //从表中删除
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        // 提醒一下
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
    }];

    action1.backgroundColor = [UIColor greenColor];
    return @[action1,action2];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UMSocialUIDelegate
// 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    LCLog(@"platformName--->>>>%@, socialData---->>>>>>%@",platformName,socialData);
}
//各个页面执行授权完成、分享完成、或者评论完成时的回调函数
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    LCLog(@"授权分享完成的回调response----->>>>>>>%@",response);
}



@end
