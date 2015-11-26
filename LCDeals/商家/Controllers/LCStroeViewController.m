//
//  LCStroeViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCStroeViewController.h"
#import "DPAPI.h"
#import "LCStore.h"
#import "LCStoreTableViewCell.h"
#import "MJExtension.h"
#import "LCStroeDetailVC.h"

@interface LCStroeViewController ()<DPRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *stores;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation LCStroeViewController

static NSString *const reuseIdentifier = @"stroeCell";

- (NSMutableArray *)stores
{
    if (!_stores) {
        _stores = [[NSMutableArray alloc] init];
    }
    return _stores;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"商家";
    [self setupSubViews];
    [self startRequest];
}

- (void)setupSubViews
{
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerNib:[UINib nibWithNibName:@"LCStoreTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:tableView];
    _tableView = tableView;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stores.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.store = self.stores[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCStroeDetailVC *detailVC = [[LCStroeDetailVC alloc] init];
    detailVC.store = self.stores[indexPath.row];
    [self pushViewController:detailVC animated:YES];
}



- (void)startRequest
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

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *deals = [LCStore objectArrayWithKeyValuesArray:result[@"businesses"]];
//    if (self.page == 1) {//第一页数据,清除之前的旧数据
//        [self.deals removeAllObjects];
//    }
    [self.stores addObjectsFromArray:deals];
    [self.tableView reloadData];

    NSLog(@"%@",result[@"businesses"]);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    
}

@end
