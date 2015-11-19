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

@interface LCMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic)  LCHomeTopItem *categoryTopItem;
@property (weak, nonatomic)  LCHomeTopItem *districtTopItem;
@property (weak, nonatomic)  LCHomeTopItem *sortTopItem;

@property (nonatomic, copy) NSString *selectedCityName;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, copy) NSString *selectedRegionName;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"首页";
    
    [self setupSubViews];
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
    

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text= @"liuchun";
    return cell;
}

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
    [self presentViewController:categoryVC animated:YES completion:nil];
    
    
}

//显示区域
- (void)districtClick
{
    [UIView animateWithDuration:0.3 animations:^{
        UIView *districtDropView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), self.view.frame.size.width, CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_headView.frame) - 49)];
        districtDropView.backgroundColor = [UIColor grayColor];
        districtDropView.alpha = 0.5;
        districtDropView.userInteractionEnabled = YES;
        [self.view addSubview:districtDropView];
        
        LCDistrictViewController *disVC = [[LCDistrictViewController alloc] init];
        [districtDropView addSubview:disVC.view];
    }];
    
}
- (void)sortClick
{
    
}




@end
