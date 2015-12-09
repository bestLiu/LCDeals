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
#import "LCHomeTopItem.h"
#import "LCCity.h"
#import "LCRegion.h"

#import "LCCategoryViewController.h"
#import "LCDistrictViewController.h"

@interface LCStroeViewController ()<DPRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic)  LCHomeTopItem *categoryTopItem;
@property (weak, nonatomic) LCHomeTopItem *districtTopItem;
@property (weak, nonatomic)  LCHomeTopItem *sortTopItem;

@property (strong, nonatomic) NSMutableArray *stores;
@property (copy, nonatomic) NSString *selectedCityName;
@property (copy, nonatomic) NSString *selectedCategoryName;
@property (copy, nonatomic) NSString *selectedRegionName;


@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *headView;


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
    if ([[userDefaults objectForKey:kUDCityNameKey] length] > 0) {
        self.selectedCityName = [userDefaults objectForKey:kUDCityNameKey];
    }
    [self setupSubViews];
    [self startRequest];
}

- (void)setupSubViews
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 35)];
    [self.view addSubview:headView];
    _headView = headView;
    
    //类别
    CGFloat itemWith = SCREEN_WIDTH/3.0;
    _categoryTopItem = [LCHomeTopItem item];
    _categoryTopItem.frame = CGRectMake(0, 0, itemWith, 35);
    [_categoryTopItem setTitle:@"全部分类"];
    [_categoryTopItem setIcon:@"icon_category_-1" highlightIcon:@"icon_category_highlighted_-1"];
    [_categoryTopItem addTarget:self action:@selector(categoryClick)];
    [headView addSubview:_categoryTopItem];
    
    //地区
    LCHomeTopItem *districtTopItem = [LCHomeTopItem item];
    districtTopItem.frame = CGRectMake(itemWith, 0, itemWith, 35);
    [districtTopItem setIcon:@"icon_map" highlightIcon:@"icon_map_highlighted"];
    [districtTopItem setTitle:@"全城"];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    [headView addSubview:districtTopItem];
    _districtTopItem = districtTopItem;
    
    //排序方式
    _sortTopItem = [LCHomeTopItem item];
    _sortTopItem.frame = CGRectMake(itemWith * 2, 0, itemWith, 35);
    [_sortTopItem setTitle:@"智能排序"];
    [_sortTopItem setIcon:@"icon_sort" highlightIcon:@"icon_sort_highlighted"];
    [_sortTopItem addTarget:self action:@selector(sortClick)];
    [headView addSubview:_sortTopItem];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, SCREEN_HEIGHT - 99 - 49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerNib:[UINib nibWithNibName:@"LCStoreTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:tableView];
    _tableView = tableView;
   
}

//显示分类
- (void)categoryClick
{
    __weak typeof(self) weakSelf = self;
    LCCategoryViewController *categoryVC = [[LCCategoryViewController alloc] init];
    [categoryVC setSelectedCategoryComplicionBlock:^(NSDictionary *categoryDic) {
        LCCategory *category = categoryDic[LCCategorySelectKey];
        NSString *subcategoryName = categoryDic[LCSubCategorySelectKey];
        
        
        if (subcategoryName == nil ||[subcategoryName isEqualToString:@"全部"]) {//点击了没有子分类的类别
            weakSelf.selectedCategoryName = category.name;
        }else{
            weakSelf.selectedCategoryName = subcategoryName;
        }
        //改变顶部文字
        [_categoryTopItem setIcon:category.icon highlightIcon:category.highlighted_icon];
        [_categoryTopItem setTitle:self.selectedCategoryName];
        
        if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
            self.selectedCategoryName = nil;
        }
        [weakSelf startRequest];
    }];
    [self pushViewController:categoryVC animated:YES];
    
}

//显示区域
- (void)districtClick
{
    __weak typeof(self) weakSelf = self;
    LCDistrictViewController *districtVc = [[LCDistrictViewController alloc] init];
    if (self.selectedCityName) {
        LCCity *city = [[[LCTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]] firstObject];
        
        //获得当前选中城市的区域
        districtVc.regions = city.regions;
        districtVc.navName = self.selectedCityName;
        [districtVc setSelectedRegionComplicionBlock:^(NSDictionary *regionDic) {
            LCRegion *region = regionDic[LCRegionSelectKey];
            NSString *subRegionName = regionDic[LCSubRegionSelectKey];
            
            
            if (subRegionName == nil ||[subRegionName isEqualToString:@"全部"]) {
                weakSelf.selectedRegionName = region.name;
            }else{
                weakSelf.selectedRegionName = subRegionName;
            }
            if ([weakSelf.selectedRegionName isEqualToString:@"全部"]) {
                weakSelf.selectedRegionName = nil;
            }
            //改变顶部文字
            [_districtTopItem setTitle:self.selectedRegionName];
            [weakSelf startRequest];

        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        return;
    }
    [self pushViewController:districtVc animated:YES];
    
}


#pragma mark - UITabelViewDataSource Delegate
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
    
        if (self.selectedCityName.length > 0) {
       params[@"city"] = self.selectedCityName;
        }else{
            [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
        }
    if (self.selectedCategoryName.length > 0) {
        params[@"category"] = self.selectedCategoryName;
    }
    if (self.selectedRegionName.length > 0) {
        params[@"region"] = self.selectedRegionName;
    }
    [api requestWithURL:urlString params:params delegate:self];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *deals = [LCStore objectArrayWithKeyValuesArray:result[@"businesses"]];
//    if (self.page == 1) {//第一页数据,清除之前的旧数据
        [self.stores removeAllObjects];
//    }
    [self.stores addObjectsFromArray:deals];
    [self.tableView reloadData];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    
}

@end
