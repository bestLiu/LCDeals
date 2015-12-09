//
//  LCMainViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCMainViewController.h"
#import "Masonry.h"
#import "LCHomeTopItem.h"
#import "LCHomeDropView.h"
#import "LCCategoryViewController.h"
#import "LCDistrictViewController.h"
#import "LCRegion.h"
#import "LCCity.h"
#import "DPAPI.h"
#import "MJRefresh.h"
#import "LCMainTableViewCell.h"
#import "LCSortButton.h"
#import "UIView+Extension.h"
#import "LCDetailViewController.h"
#import "LCMapViewController.h"
#import "LCCityViewController.h"

@interface LCMainViewController ()<UITableViewDataSource,UITableViewDelegate, DPRequestDelegate>

@property (weak, nonatomic)  LCHomeTopItem *categoryTopItem;
@property (weak, nonatomic) LCHomeTopItem *districtTopItem;
@property (weak, nonatomic)  LCHomeTopItem *sortTopItem;

@property (nonatomic, copy) NSString *selectedCityName;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, copy) NSString *selectedRegionName;
@property (nonatomic, strong) LCSort *selectedSort;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *deals;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIView *noRecordView;
@property (weak, nonatomic) UIView *sortBGView;
@property (weak, nonatomic) UIButton *cityButton;

@property (nonatomic, weak) DPRequest *lastRequest;


@end

@implementation LCMainViewController

- (NSMutableArray *)deals
{
    if (!_deals) {
        _deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    self.backButton.hidden = YES;
    self.navigationTitle = @"首页";
        
    [self setupSubViews];
    [self setupNotification];
}

- (void)setupSubViews
{
  
    if ([[userDefaults objectForKey:kUDCityNameKey] length] > 0) {
        self.selectedCityName = [userDefaults objectForKey:kUDCityNameKey];
    }
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(15, 0, 80, CGRectGetHeight(self.customNavigationBar.frame));
    [cityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cityButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    NSString *selectedCityName = [userDefaults objectForKey:kUDCityNameKey];
    NSString *buttonText = selectedCityName.length > 0 ? selectedCityName : @"请选择城市";
    cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cityButton setTitle:buttonText forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:cityButton];
    _cityButton = cityButton;
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 50, CGRectGetHeight(self.customNavigationBar.frame));
    [mapButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [mapButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    mapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//渲染在右边
    [mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:mapButton];
    
    //类别
    CGFloat itemWith = CGRectGetWidth(self.view.frame)/3.0;
    _categoryTopItem = [LCHomeTopItem item];
    _categoryTopItem.frame = CGRectMake(0, 0, itemWith, 35);
    [_categoryTopItem setTitle:@"全部分类"];
    [_categoryTopItem setIcon:@"icon_category_-1" highlightIcon:@"icon_category_highlighted_-1"];
    [_categoryTopItem addTarget:self action:@selector(categoryClick)];
    [_headView addSubview:_categoryTopItem];
    
    //地区
    LCHomeTopItem *districtTopItem = [LCHomeTopItem item];
    districtTopItem.frame = CGRectMake(itemWith, 0, itemWith, 35);
    [districtTopItem setIcon:@"icon_map" highlightIcon:@"icon_map_highlighted"];
    [districtTopItem setTitle:@"全城"];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    [_headView addSubview:districtTopItem];
    _districtTopItem = districtTopItem;
  
    //排序方式
    _sortTopItem = [LCHomeTopItem item];
    _sortTopItem.frame = CGRectMake(itemWith * 2, 0, itemWith, 35);
    [_sortTopItem setTitle:@"智能排序"];
    [_sortTopItem setIcon:@"icon_sort" highlightIcon:@"icon_sort_highlighted"];
    [_sortTopItem addTarget:self action:@selector(sortClick)];
    [_headView addSubview:_sortTopItem];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LCMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    self.tableView.rowHeight = 120;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    [self.tableView headerBeginRefreshing];
    
    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), SCREEN_WIDTH, CGRectGetHeight(self.tableView.frame))];
    noRecordView.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    noRecordView.hidden = YES;
    [self.view addSubview:noRecordView];
    _noRecordView = noRecordView;
    
    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160) * 0.5, SCREEN_HEIGHT*0.5 - CGRectGetMaxY(_headView.frame) - 80, 160, 160)];
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

- (void)setupNotification
{
    //监听分类的改变
    [LCNotifiCationCenter addObserver:self selector:@selector(categoryChange:) name:LCCategoryDidChangeNotification object:nil];
    
    //监听城市改变
    [LCNotifiCationCenter addObserver:self selector:@selector(cityChange:) name:LCCityDidSelectNotification object:nil];
    
    //监听区域改变
    [LCNotifiCationCenter addObserver:self selector:@selector(regionChange:) name:LCRegionDidChangeNotification object:nil];
    
    //监听退出当前账号
    [LCNotifiCationCenter addObserver:self selector:@selector(exit) name:LCMoreViewControllerExitSucceed object:nil];
}


//显示分类
- (void)categoryClick
{
    //显示分类菜单
    LCCategoryViewController *categoryVC = [[LCCategoryViewController alloc] init];
    [self pushViewController:categoryVC animated:YES];
    
}

//显示区域
- (void)districtClick
{
    
    LCDistrictViewController *districtVc = [[LCDistrictViewController alloc] init];
    
    if (self.selectedCityName) {
        LCCity *city = [[[LCTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] firstObject];
        
        //获得当前选中城市的区域
        districtVc.regions = city.regions;
        districtVc.navName = self.selectedCityName;
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    [self pushViewController:districtVc animated:YES];
    
}
//显示排序方式
- (void)sortClick
{
    if (_sortBGView) {
        [_sortBGView removeFromSuperview];
        return;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_districtTopItem.frame), CGRectGetMaxY(_headView.frame), CGRectGetWidth(_sortTopItem.frame), SCREEN_HEIGHT - CGRectGetHeight(_headView.frame)- 108)];
    bgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:bgView];
    _sortBGView = bgView;
    
    CGFloat btnW = CGRectGetWidth(bgView.frame);
    CGFloat btnH = 30;
    CGFloat btnX = 0;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    NSArray *sorts = [LCTool sorts];
    NSInteger count = sorts.count;
    for (int i = 0; i < count; i ++) {
        LCSort *sort = sorts[i];
        LCSortButton *button = [[LCSortButton alloc] init];
        button.sort = sort;//绑定sort
        button.x = btnX;
        button.y = btnStartY + i*(btnH + btnMargin);
        button.width = btnW;
        button.height = btnH;
        
        [button setTitle:sort.label forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(sortChanged:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        height = CGRectGetMaxY(button.frame);
    }
    bgView.height = height;
}


#pragma mark - 通知方法
- (void)categoryChange:(NSNotification *)noti
{
    LCCategory *category = noti.userInfo[LCCategorySelectKey];
    NSString *subcategoryName = noti.userInfo[LCSubCategorySelectKey];
    
    
    if (subcategoryName == nil ||[subcategoryName isEqualToString:@"全部"]) {//点击了没有子分类的类别
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = subcategoryName;
    }
    //改变顶部文字
    [_categoryTopItem setIcon:category.icon highlightIcon:category.highlighted_icon];
    [_categoryTopItem setTitle:self.selectedCategoryName];
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    [self.tableView headerBeginRefreshing];

}
- (void)cityButtonAction:(UIButton *)button
{
    LCCityViewController *cityVc = [[LCCityViewController alloc] init];
    [self pushViewController:cityVc animated:YES];
}

- (void)cityChange:(NSNotification *)noti
{
    self.selectedCityName = noti.userInfo[LCCitySelectCityKey];
    
    //保存一下，下次进入界面用
    [userDefaults setObject:self.selectedCityName forKey:kUDCityNameKey];
    [userDefaults synchronize];
    
    // 1更换区域item的文字
    [_cityButton setTitle:self.selectedCityName forState:UIControlStateNormal];
    [self.tableView headerBeginRefreshing];
}

- (void)regionChange:(NSNotification *)noti
{
    LCRegion *region = noti.userInfo[LCRegionSelectKey];
    NSString *subRegionName = noti.userInfo[LCSubRegionSelectKey];
    
   

    if (subRegionName == nil ||[subRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    }else{
        self.selectedRegionName = subRegionName;
    }
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
     //改变顶部文字
    [_districtTopItem setTitle:self.selectedRegionName];
    [self.tableView headerBeginRefreshing];
    
}

- (void)sortChanged:(LCSortButton *)button
{
    NSLog(@"%d点击了： %@",button.sort.value,button.sort.label);
    [button.superview removeFromSuperview];
    [_sortTopItem setTitle:button.sort.label];
    self.selectedSort = button.sort;
    [self.tableView headerBeginRefreshing];
}

- (void)exit
{
    [_cityButton setTitle:@"请选择城市" forState:UIControlStateNormal];
    [_noRecordView setHidden:NO];
}

- (void)startRequst
{
    NSString *urlString = @"v1/deal/find_deals";
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    params[@"page"] = @(self.page);
    params[@"limit"] = @20;
    if (self.selectedCityName) {
        params[@"city"] = self.selectedCityName;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    if (self.selectedCategoryName) {
       params[@"category"] = self.selectedCategoryName;
            }
    if (self.selectedRegionName) {
            params[@"region"] = self.selectedRegionName;
        }
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    
    NSLog(@"首页请求参数---->>>>>>%@",params);
    self.lastRequest = [api requestWithURL:urlString params:params delegate:self];
}



#pragma mark 请求代理
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    //请求失败
    NSLog(@"请求失败--->>> %@",error);
    // 提醒用户失败
//    [MBProgressHUD showError:@"网络繁忙，请稍候再试" toView:self.view];
    
    // 结束上/下拉刷新
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    
    //如果是上拉刷新失败
    if (self.page > 1) {
        self.page -- ;
    }
    
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return; //如果不是最后一个请求 就结束
    
    //1、取出团购的字典数组
    NSArray *deals = [LCDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.page == 1) {//第一页数据,清除之前的旧数据
        [self.deals removeAllObjects];
    }
    [self.deals addObjectsFromArray:deals];
    
    //2 、刷新表格
    [self.tableView reloadData];
    
    //3 、结束上/下拉加载
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    
    //4 、控制尾部刷新控件的显示和隐藏.总数和数组的长度相等的时候影藏上拉刷新
    self.tableView.footerHidden = [result[@"total_count"] integerValue] == self.deals.count;
    
    //5 、控制没有数据的提醒
    self.noRecordView.hidden = self.deals.count != 0;
}

- (void)loadMoreDeals
{
    self.page ++;
    [self startRequst];
}
- (void)loadNewDeals
{
    self.page = 1;
    [self startRequst];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _noRecordView.hidden = self.deals.count != 0;
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.row];
    return cell;
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCDetailViewController *detailVc = [[LCDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.row];
    [self pushViewController:detailVc animated:YES];
}


- (void)mapButtonAction
{
    LCMapViewController *mapVC = [[LCMapViewController alloc] init];
    [self pushViewController:mapVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_sortBGView removeFromSuperview];
}

- (void)dealloc
{
    [LCNotifiCationCenter removeObserver:self];
}

@end
