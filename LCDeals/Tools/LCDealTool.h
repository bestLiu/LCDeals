//
//  LCDealTool.h
//  美团HD
//
//  Created by mac1 on 15/9/14.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCDealTool : NSObject

// 返回第page页的团购数据:page从1开始
+ (NSArray *)collectDeals:(int)page;

//返回收藏团购的个数
+ (int)collectDealsCount;

//收藏一个团购
+ (void)addCollect:(LCDeal *)deal;

//取消一个收藏
+ (void)removeCollect:(LCDeal *)deal;

//是否收藏
+ (BOOL)isCollect:(LCDeal *)deal;






//最近团购数据
+ (NSArray *)recentDeals:(int)page;

//添加一个最近访问的团购数据
+ (void)addRecent:(LCDeal *)deal;

//取消一个最近访问
+ (void)removeRecent:(LCDeal *)deal;

//最近访问的数据是否在表中
+ (BOOL)recentIsExist:(LCDeal *)deal;

@end
