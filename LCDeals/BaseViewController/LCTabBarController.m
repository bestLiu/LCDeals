//
//  LCTabBarController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCBaseNavgationController.h"
#import "LCMainViewController.h"
#import "LCDiscoverViewController.h"
#import "LCStroeViewController.h"
#import "LCPersonalViewController.h"
#import "LCMoreViewController.h"

@interface LCTabBarController ()

@end

@implementation LCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    LCMainViewController *mainVC = [[LCMainViewController alloc] init];
 
    LCDiscoverViewController *discoverVC = [[LCDiscoverViewController alloc] init];
  
    LCStroeViewController *strVC = [[LCStroeViewController alloc] init];
    LCPersonalViewController  *personalCenterVC = [[LCPersonalViewController alloc] init];
    LCMoreViewController *moreVC = [[LCMoreViewController alloc] init];
    

    
    LCBaseNavgationController *mainNav = [[LCBaseNavgationController alloc] initWithRootViewController:mainVC];
    LCBaseNavgationController *discoverNav = [[LCBaseNavgationController alloc]initWithRootViewController:discoverVC];
    LCBaseNavgationController *strNav = [[LCBaseNavgationController alloc]initWithRootViewController:strVC];
    LCBaseNavgationController *personalNav  = [[LCBaseNavgationController alloc] initWithRootViewController:personalCenterVC];
    LCBaseNavgationController *moreNav  = [[LCBaseNavgationController alloc] initWithRootViewController:moreVC];
    
    
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_tabbar_homepage"] selectedImage:[UIImage imageNamed:@"icon_tabbar_homepage_selected"]];
    
    discoverVC.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"icon_tabbar_onsite"] selectedImage:[UIImage imageNamed:@"icon_tabbar_onsite_selected"]];
    
    strVC.tabBarItem         = [[UITabBarItem alloc] initWithTitle:@"商家" image:[UIImage imageNamed:@"icon_tabbar_merchant_normal"] selectedImage:[UIImage imageNamed:@"icon_tabbar_merchant_selected"]];
    
    personalCenterVC.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"icon_tabbar_mine"] selectedImage:[UIImage imageNamed:@"icon_tabbar_mine_selected"]];
    moreVC.tabBarItem  = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"icon_tabbar_misc"] selectedImage:[UIImage imageNamed:@"icon_tabbar_misc_selected"]];
    
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor orangeColor]];
    
    NSArray *viewControllers = @[mainNav,discoverNav,strNav,personalNav,moreNav];
    self.viewControllers = viewControllers;


}


@end
