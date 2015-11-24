//
//  LCMoreViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//



#import "LCMoreViewController.h"
#import "LCMoreTableViewCell.h"

@interface LCMoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation LCMoreViewController

static NSString *const reuseIdentifier = @"moreCell";

- (NSMutableArray *)datas
{
    if (!_datas) {
        NSMutableArray *section1 = @[@{kCell_Title : @"扫一扫",kCell_Arrow : @"right_arrow"}].copy;
        NSMutableArray *section2 = @[@{kCell_Title : @"省流量模式", kCell_Switch : @"1"},
                                     @{kCell_Title : @"分享",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"消息设置",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"清空缓存", kCell_count : @"count"}].copy;
        NSMutableArray *section3 = @[@{kCell_Title : @"意见反馈",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"关于我们",kCell_Arrow : @"right_arrow"},
                                     @{kCell_Title : @"帮助",kCell_Arrow : @"right_arrow"}].copy;
        NSMutableArray *section4 = @[@{kCell_Title : @"安全退出"}].copy;
        _datas = [[NSMutableArray alloc] initWithObjects:section1,section2,section3,section4, nil];
    }
    
    return _datas;
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

@end
