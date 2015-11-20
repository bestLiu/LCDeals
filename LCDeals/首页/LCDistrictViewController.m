//
//  LCDistrictViewController.m
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCDistrictViewController.h"
#import "LCHomeDropView.h"
#import "UIView+Extension.h"
#import "LCCityViewController.h"
#import "LCRegion.h"

@interface LCDistrictViewController ()<LCHomeDropViewDataSource, LCHomeDropViewDelegate>
- (IBAction)changeCity;

@end

@implementation LCDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = self.navName?self.navName:@"选择城市";
    //创建下拉菜单
    LCHomeDropView *dropView = [[LCHomeDropView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT -108)];
    dropView.dataSource = self;
    dropView.delegate = self;
    [self.view addSubview:dropView];
}


#pragma mark -LCHomeDropViewDataSource
- (NSInteger) numberOfRowsInMainTable:(LCHomeDropView *)homeDropView
{
   
    return self.regions.count;
}

- (NSString *)homeDropView:(LCHomeDropView *)homeDropView titleForRowInMainTable:(NSInteger)row
{
    LCRegion *region = self.regions[row];
    return region.name;
}
- (NSArray *)subdataForRowInMainTable:(NSInteger)row
{
    LCRegion *region = self.regions[row];
    return region.subregions;
}


#pragma mark - LCHomeDropViewDelegate
- (void)homeDropView:(LCHomeDropView *)homeDropView didSelectRowInMainTable:(int)row
{
    LCRegion *region = self.regions[row];
    if (region.subregions.count == 0) {
        [LCNotifiCationCenter postNotificationName:LCRegionDidChangeNotification object:self userInfo:@{LCRegionSelectKey:region}];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)homeDropView:(LCHomeDropView *)homeDropView didSelectRowInSubTable:(int)row inMainTable:(int)mainRow
{
    LCRegion *region = self.regions[mainRow];
    NSString *subRegionName = region.subregions[row];
    [LCNotifiCationCenter postNotificationName:LCRegionDidChangeNotification object:self userInfo:@{LCRegionSelectKey:region,LCSubRegionSelectKey:subRegionName}];
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 *  切换城市
 */
- (IBAction)changeCity {
    LCCityViewController *cityVc = [[LCCityViewController alloc] init];
    [self pushViewController:cityVc animated:YES];
}
@end
