//
//  AppDelegate.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "AppDelegate.h"
#import "LCTabBarController.h"
#import "UMFeedback.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "LCDiscoverViewController.h"
#import "LCMoreViewController.h"
#import "LCBaseNavgationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMFeedback setAppkey:@"566786b7e0f55a0f5200207a"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialData setAppKey:@"566786b7e0f55a0f5200207a"];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LCTabBarController alloc] init];
    
    
    //添加3DTouch功能
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0 ) {
        UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
        UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"搜索" localizedSubtitle:nil icon:icon1 userInfo:nil];
        
        UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_homepage_scan"];
        UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:icon2 userInfo:nil];
        
        application.shortcutItems = @[item1,item2];
        
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        
        
        
    }
    return result;
}



- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    BOOL isSucceeded = [self handleShortcutItemPressed:shortcutItem];
    completionHandler(isSucceeded);
}

- (BOOL)handleShortcutItemPressed:(UIApplicationShortcutItem *)shortcutItem
{
    if ([shortcutItem.localizedTitle isEqualToString:@"搜索"]) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)app.window.rootViewController;
        tabBarController.selectedIndex = 1;
    }else{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UITabBarController *tabBarController = (UITabBarController *)app.window.rootViewController;
        tabBarController.selectedIndex = 4;
        LCBaseNavgationController *nav = tabBarController.selectedViewController;
        for (UIViewController *viewController in nav.viewControllers) {
            if ([viewController isKindOfClass:NSClassFromString(@"LCMoreViewController")]) {
                LCMoreViewController *moreViewController = (LCMoreViewController *)viewController;
                [moreViewController push2ScanViewController];
            }
        }

    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
