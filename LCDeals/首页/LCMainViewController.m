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

@interface LCMainViewController ()<UITableViewDataSource,UITableViewDelegate, DPRequestDelegate>

@property (weak, nonatomic)  LCHomeTopItem *categoryTopItem;
@property (weak, nonatomic)  LCHomeTopItem *districtTopItem;
@property (weak, nonatomic)  LCHomeTopItem *sortTopItem;

@property (nonatomic, copy) NSString *selectedCityName;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, copy) NSString *selectedRegionName;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray *deals;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noRecordView;

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
    //1、类别
    CGFloat itemWith = CGRectGetWidth(self.view.frame)/3.0;
    _categoryTopItem = [LCHomeTopItem item];
    _categoryTopItem.frame = CGRectMake(0, 0, itemWith, 35);
    [_categoryTopItem setTitle:@"全部分类"];
    [_categoryTopItem setIcon:@"icon_category_-1" highlightIcon:@"icon_category_highlighted_-1"];
    [_categoryTopItem addTarget:self action:@selector(categoryClick)];
    [_headView addSubview:_categoryTopItem];
    
    //2、地区
    _districtTopItem = [LCHomeTopItem item];
    _districtTopItem.frame = CGRectMake(itemWith, 0, itemWith, 35);
    [_districtTopItem setTitle:@"城市"];
    [_districtTopItem addTarget:self action:@selector(districtClick)];
    [_headView addSubview:_districtTopItem];
    
    //3、排序
    _sortTopItem = [LCHomeTopItem item];
    _sortTopItem.frame = CGRectMake(itemWith * 2, 0, itemWith, 35);
    [_sortTopItem setTitle:@"排序"];
    [_sortTopItem setSubtitle:@"默认排序"];
    [_sortTopItem setIcon:@"icon_sort" highlightIcon:@"icon_sort_highlighted"];
    [_sortTopItem addTarget:self action:@selector(sortClick)];
    [_headView addSubview:_sortTopItem];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LCMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    self.tableView.rowHeight = 120;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}

- (void)setupNotification
{
    //监听分类改变
    [LCNotifiCationCenter addObserver:self selector:@selector(categoryChange:) name:LCCategoryDidChangeNotification object:nil];
    
    //监听城市改变
    [LCNotifiCationCenter addObserver:self selector:@selector(cityChange:) name:LCCityDidSelectNotification object:nil];
    
    //监听区域改变
    [LCNotifiCationCenter addObserver:self selector:@selector(regionChange:) name:LCRegionDidChangeNotification object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.row];
    return cell;
}
#pragma mark - UITabelViewDelegate


//显示分类
- (void)categoryClick
{
    //显示分类菜单
//    if (!self.selectedCityName) {
//        [MBProgressHUD showError:@"请先选择城市" toView:self.view];
//        return;
//    }

//    [UIView animateWithDuration:0.3 animations:^{
//        UIView *categoryDorpView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_headView.frame) - 49)];
//        categoryDorpView.backgroundColor = [UIColor grayColor];
//        categoryDorpView.userInteractionEnabled = YES;
//        [self.view addSubview:categoryDorpView];
//        
//
//        
//    }];
    LCCategoryViewController *categoryVC = [[LCCategoryViewController alloc] init];
    [self pushViewController:categoryVC animated:YES];
    
    
}

//显示区域
- (void)districtClick
{
//    [UIView animateWithDuration:0.3 animations:^{
//        UIView *districtDropView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_headView.frame) - 49)];
//        districtDropView.backgroundColor = [UIColor grayColor];
//        districtDropView.alpha = 0.5;
//        districtDropView.userInteractionEnabled = YES;
//        [self.view addSubview:districtDropView];
//        
//        LCDistrictViewController *disVC = [[LCDistrictViewController alloc] init];
//        [districtDropView addSubview:disVC.view];
//    }];
    
    LCDistrictViewController *districtVc = [[LCDistrictViewController alloc] init];
    
    if (self.selectedCityName) {
        LCCity *city = [[[LCTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] firstObject];
        
        //获得当前选中城市的区域
        districtVc.regions = city.regions;
        districtVc.navName = self.selectedCityName;
        
    }
    [self pushViewController:districtVc animated:YES];
    
}
//显示排序方式
- (void)sortClick
{
    
}


#pragma mark - 通知方法
- (void)categoryChange:(NSNotification *)noti
{
    LCCategory *category = noti.userInfo[LCCategorySelectKey];
    NSString *subcategoryName = noti.userInfo[LCSubCategorySelectKey];
    
    //改变顶部文字
    [_categoryTopItem setIcon:category.icon highlightIcon:category.highlighted_icon];
    [_categoryTopItem setTitle:category.name];
    [_categoryTopItem setSubtitle:subcategoryName];
    
    if (subcategoryName == nil ||[subcategoryName isEqualToString:@"全部"]) {//点击了没有子分类的类别
        self.selectedCategoryName = category.name;
    }else{
        self.selectedCategoryName = subcategoryName;
    }
    
    
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    [self.tableView headerBeginRefreshing];

}

- (void)cityChange:(NSNotification *)noti
{
    self.selectedCityName = noti.userInfo[LCCitySelectCityKey];
    
    // 1更换区域item的文字
    [_districtTopItem setTitle:[NSString stringWithFormat:@"%@",_selectedCityName]];
    [_districtTopItem setSubtitle:nil];
    [self.tableView headerBeginRefreshing];
}

- (void)regionChange:(NSNotification *)noti
{
    LCRegion *region = noti.userInfo[LCRegionSelectKey];
    NSString *subRegionName = noti.userInfo[LCSubRegionSelectKey];
    
    //改变顶部文字
    [_districtTopItem setTitle:[NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name]];
    [_districtTopItem setSubtitle:subRegionName];
    if (subRegionName == nil ||[subRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    }else{
        self.selectedRegionName = subRegionName;
    }
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    [self.tableView headerBeginRefreshing];
}

- (void)startRequst
{
    NSString *urlString = @"v1/deal/find_deals";
    
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.selectedCityName;
    params[@"page"] = @(self.page);
    params[@"limit"] = @20;
    if (self.selectedCategoryName) {
                params[@"category"] = self.selectedCategoryName;
            }
        if (self.selectedRegionName) {
            params[@"region"] = self.selectedRegionName;
        }
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


- (void)dealloc
{
    [LCNotifiCationCenter removeObserver:self];
}

@end
