//
//  LCSearchResultTableViewController.m
//  美团HD
//
//  Created by mac1 on 15/9/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCSearchResultTableViewController.h"
#import "LCCity.h"

@interface LCSearchResultTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LCSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString; //(忽略大小写)
   // self.dataArray = [NSMutableArray array];// 每次搜索需重新初始化数组
    
    //1 、根据关键字搜索想要的城市数据 （这种方法较简单）
//    for (LCCity *city in self.cities) {
//        //城市的neme中包含了searchText
//        //城市的pinYin包含 searchText
//        //城市的pinYinHead
//        if ([city.name containsString:searchText] || [city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
//            [self.dataArray addObject:city];
//        }
//    }
    
    //2 、利用谓词:能根据一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.dataArray = [[LCTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    LCCity *city = self.dataArray[indexPath.row];
    cell.textLabel.text = city.name;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果",self.dataArray.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCCity *city = self.dataArray[indexPath.row];
    [LCNotifiCationCenter postNotificationName:LCCityDidSelectNotification object:self userInfo:@{LCCitySelectCityKey:city.name}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
