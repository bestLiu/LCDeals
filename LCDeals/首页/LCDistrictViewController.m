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
//#import "LCCityViewController.h"
//#import "LCNavigationViewController.h"
#import "LCRegion.h"

@interface LCDistrictViewController ()<LCHomeDropViewDataSource, LCHomeDropViewDelegate>
- (IBAction)changeCity;

@end

@implementation LCDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建下拉菜单
    UIView *titleView =  [self.view.subviews firstObject];
    LCHomeDropView *dropView = [LCHomeDropView dropView];
    dropView.dataSource = self;
    dropView.delegate = self;
    dropView.autoresizingMask = UIViewAutoresizingNone;
    dropView.y = titleView.height;
    [self.view addSubview:dropView];
    

    self.preferredContentSize = CGSizeMake(dropView.width, CGRectGetMaxY(dropView.frame));

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
    }
}
- (void)homeDropView:(LCHomeDropView *)homeDropView didSelectRowInSubTable:(int)row inMainTable:(int)mainRow
{
    LCRegion *region = self.regions[mainRow];
    NSString *subRegionName = region.subregions[row];
    [LCNotifiCationCenter postNotificationName:LCRegionDidChangeNotification object:self userInfo:@{LCRegionSelectKey:region,LCSubRegionSelectKey:subRegionName}];
}



/**
 *  切换城市
 */
//- (IBAction)changeCity {
//    //关闭popover
////    [self.popover dismissPopoverAnimated:YES];
//
//    LCCityViewController *cityVc = [[LCCityViewController alloc] init];
//    LCNavigationViewController *nav = [[LCNavigationViewController alloc] initWithRootViewController:cityVc];
//    nav.modalPresentationStyle = UIModalPresentationFormSheet;
////    [self presentViewController:nav animated:YES completion:nil]
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];//为了关闭popover让窗口的根视图控制器来modal nav。
//    
////    self.presentedViewController 会引用着被modal出来的控制器
//}
@end
