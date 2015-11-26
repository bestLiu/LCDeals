//
//  LCCityViewController.m
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "LCCity.h"
#import "MJExtension.h"
#import "LCCityGroup.h"
#import "UIView+AutoLayout.h"
#import "LCSearchResultTableViewController.h"
#import "LCDiscoverViewController.h"



@interface LCCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *cityGroups;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) LCSearchResultTableViewController *searchResultVc;

@end

@implementation LCCityViewController

- (LCSearchResultTableViewController *)searchResultVc
{
    if (!_searchResultVc) {
        self.searchResultVc = [[LCSearchResultTableViewController alloc] init];
        [self addChildViewController:self.searchResultVc]; //为了在searchResultVc dismiss导航控制器
       
         [self.view addSubview:self.searchResultVc.view]; //先加载父视图上
        [self.searchResultVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.searchResultVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];
    }
    return _searchResultVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"切换城市";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    
    self.tableView.sectionIndexColor = [UIColor cyanColor];
    
    //遮盖
    self.coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.0;
    [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)]];
    [self.view addSubview:_coverView];
    _coverView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_coverView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [_coverView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];
    
    //加载城市数据
    self.cityGroups = [LCCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    self.searchBar.tintColor = [UIColor colorWithRed:32/255.0 green:191/255.0 blue:179/255.0 alpha:1];//设置searchBar光标和取消按钮的颜色
}

- (void)close
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 表的数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.cityGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LCCityGroup *group = self.cityGroups[section];
    return group.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    LCCityGroup *group = self.cityGroups[indexPath.section];
    
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}

#pragma mark - 表代理

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LCCityGroup *group = self.cityGroups[section];
    return group.title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCCityGroup *group = self.cityGroups[indexPath.section];
    NSString *cityName = group.cities[indexPath.row];
    
    
    if (self.navigationController.viewControllers.count > 1) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"LCDiscoverViewController")]) {
                LCDiscoverViewController *disVC = (LCDiscoverViewController *)vc;
                disVC.cityName = cityName;
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    [LCNotifiCationCenter postNotificationName:LCCityDidSelectNotification object:self userInfo:@{LCCitySelectCityKey:cityName}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *titles = [NSMutableArray array];
//    for (LCCityGroup *group in self.cityGroups) {
//        [titles addObject:group.title];
//    }
    
//    kvc返回装有title数组
    return [self.cityGroups valueForKeyPath:@"title"];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 1、隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    // 2、显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5f;
    }];

    
//    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tableView.mas_left);
//        make.right.equalTo(self.tableView.mas_right);
//        make.top.equalTo(self.tableView.mas_top);
//        make.bottom.equalTo(self.tableView.mas_bottom);
//        
//    }];
    
    // 3、修改搜索框的背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
    // 4、显示搜索框的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 1、显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
    // 2、移除遮盖
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.0;
    }];
    
    // 3、修改搜索框的背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    // 4、影藏搜索框的取消按钮
     [searchBar setShowsCancelButton:NO animated:YES];
    
    // 5、移除搜索结果
    self.searchResultVc.view.hidden = YES;
    searchBar.text = @"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
   
}

/**
 *  当搜索框文字变化的时候调用，包含取消按钮
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length) {
        self.searchResultVc.view.hidden = NO;
        _searchResultVc.searchText = searchText;
        
    }else{
        self.searchResultVc.view.hidden = YES;
    }
    
    
}

@end
