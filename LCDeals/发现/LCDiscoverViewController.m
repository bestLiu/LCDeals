//
//  LCDiscoverViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCDiscoverViewController.h"
#import "LCMainTableViewCell.h"
#import "LCDeal.h"
#import "MJRefresh.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "LCCityViewController.h"
#import "LCDetailViewController.h"

@interface LCDiscoverViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DPRequestDelegate>

@property (strong, nonatomic) NSMutableArray *deals;
@property (weak, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *noRecordView;
@property (weak, nonatomic) UIButton *cityButton;
@property (nonatomic, weak) DPRequest *lastRequest;


@end

@implementation LCDiscoverViewController

static NSString *const reuseIdentifier = @"mainCell";

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cityName.length > 0 && _cityButton) {
        NSString *buttonText = self.cityName.length > 0 ? self.cityName : @"请选择城市";
        [_cityButton setTitle:buttonText forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"发现";
    [self setupSubViews];
    
    //监听退出当前账号
    [LCNotifiCationCenter addObserver:self selector:@selector(exit) name:LCMoreViewControllerExitSucceed object:nil];
}


- (void)setupSubViews
{
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(15, 0, 80, CGRectGetHeight(self.customNavigationBar.frame));
    [cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cityButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    NSString *cityName = [userDefaults objectForKey:kUDCityNameKey];
    NSString *buttonText = cityName.length > 0 ? cityName : @"请选择城市";
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cityButton setTitle:buttonText forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:cityButton];
    _cityButton = cityButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    _searchBar = searchBar;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(searchBar.frame)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    tableView.rowHeight = 120;
    [tableView addHeaderWithTarget:self action:@selector(tableHeaderRefresh)];
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"LCMainTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    _tableView = tableView;
    
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame), SCREEN_WIDTH, CGRectGetHeight(tableView.frame))];
    noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    noRecordView.hidden = YES;
    [self.view addSubview:noRecordView];
    _noRecordView = noRecordView;
    
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160) * 0.5, SCREEN_HEIGHT*0.5 - CGRectGetMaxY(_searchBar.frame) - 80, 160, 160)];
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.layer.cornerRadius = roundView.frame.size.width/2;
    roundView.layer.masksToBounds = YES;
    [_noRecordView addSubview:roundView];
    
    UILabel *noRecordLabel = [[UILabel alloc] init];
    noRecordLabel.bounds = CGRectMake(0, 0, 150, 30);
    noRecordLabel.center = roundView.center;
    noRecordLabel.textAlignment = NSTextAlignmentCenter;
    noRecordLabel.text = @"暂无团购信息";
    noRecordLabel.font = [UIFont boldSystemFontOfSize:14.0];
    noRecordLabel.textColor = [UIColor grayColor];
    [_noRecordView addSubview:noRecordLabel];
}

#pragma mrak - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _noRecordView.hidden = self.deals.count != 0;
    return self.deals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    LCDeal *deal = self.deals[indexPath.row];
    cell.deal = deal;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LCDetailViewController *detailVc = [[LCDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.row];
    [self pushViewController:detailVc animated:YES];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 进入下拉刷新状态
    [self.tableView headerBeginRefreshing];
    [searchBar resignFirstResponder];
}

- (void)tableHeaderRefresh
{
    NSString *cityName = _cityButton.titleLabel.text;
    
    // 发请求给服务器
    NSString *urlString = @"v1/deal/find_deals";
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
    if (cityName.length > 0) {
        params[@"city"] = cityName;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    
    if (_searchBar.text) {
        params[@"keyword"] = _searchBar.text;
        self.lastRequest = [api requestWithURL:urlString params:params delegate:self];
    }
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return; //如果不是最后一个请求 就结束
    
    //MJExtension 的使用
    NSArray *deals = [LCDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    [self.deals addObjectsFromArray:deals];
    [self.tableView reloadData];
    [self.tableView headerEndRefreshing];

}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    
    [SVProgressHUD showErrorWithStatus:kNetworkErrorMsg];
    // 结束上/下拉刷新
    [self.tableView headerEndRefreshing];
}

- (void)cityButtonAction:(UIButton *)button
{
    LCCityViewController *cityVc = [[LCCityViewController alloc] init];
    [self pushViewController:cityVc animated:YES];
}

- (void)exit
{
    [_cityButton setTitle:@"请选择城市" forState:UIControlStateNormal];
    [_noRecordView setHidden:NO];
}

@end
