//
//  LCPersonalViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCPersonalViewController.h"
#import "LCPersonalTableViewCell.h"
#import "LCPersonalTableHeaderView.h"
#import "LCCollectViewController.h"
#import "LCPersonalInfoViewController.h"


@interface LCPersonalViewController ()<UITableViewDataSource, UITableViewDelegate, LCPersonalInfoViewControllerdDelegete>

@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) LCPersonalTableHeaderView *headView;

@end

@implementation LCPersonalViewController

static NSString *const reuseIdentifier = @"personalCell";

- (NSArray *)dataArray
{
    if (!_dataArray) {
        NSArray *section1 = @[@{kPersonal_Cell_Icon : @"Me_Balence", kPersonal_Cell_Title : @"我的钱包",kPersonal_Cell_Count : @"0.00", kPersonal_Cell_Arrow : @"right_arrow"},
                              @{kPersonal_Cell_Icon : @"Me_BankCard", kPersonal_Cell_Title : @"我的银行卡", kPersonal_Cell_Arrow : @"right_arrow"}];
        
        NSArray *section2 = @[@{kPersonal_Cell_Icon : @"Me_OrderCenter", kPersonal_Cell_Title : @"订单中心", kPersonal_Cell_Arrow : @"right_arrow"}];
        
        NSArray *section3 = @[@{kPersonal_Cell_Icon : @"Me_Collect", kPersonal_Cell_Title : @"我的收藏", kPersonal_Cell_Arrow : @"right_arrow"}];
        _dataArray = @[section1, section2, section3];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backButton.hidden = YES;
    self.navigationTitle = @"个人中心";

    [self setupSubViews];
}

- (void)setupSubViews
{
    LCPersonalTableHeaderView *headerView = [LCPersonalTableHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewAcion)];
    NSDictionary *info = [userDefaults objectForKey:kUserInfoKey];
    [headerView.headButton setBackgroundImage:[UIImage imageWithData:info[@"headImage"]] forState:UIControlStateNormal];
    headerView.nickNameLabel.text = info[@"nickName"];
    headerView.addressLabel.text = [NSString stringWithFormat:@"常居地：%@",info[@"address"]];
    [headerView addGestureRecognizer:tap];
    _headView = headerView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [tableView registerNib:[UINib nibWithNibName:@"LCPersonalTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    
}

#pragma mark - UITableView  delegate  and  datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArr = self.dataArray[section];
    return rowArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.datas = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //我的收藏
                    LCCollectViewController *collectVC = [[LCCollectViewController alloc] init];
                    [self pushViewController:collectVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)headerViewAcion
{
    LCPersonalInfoViewController *infoVC = [[LCPersonalInfoViewController alloc] init];
    infoVC.delegte = self;
    [self pushViewController:infoVC animated:YES];
}

- (void)updatePersonalInfoComplition:(NSDictionary *)info
{
    [_headView.headButton setBackgroundImage:[UIImage imageWithData:info[@"headImage"]] forState:UIControlStateNormal];
    _headView.nickNameLabel.text = info[@"nickName"];
    _headView.addressLabel.text = [NSString stringWithFormat:@"常居地：%@",info[@"address"]];
    
}

@end
