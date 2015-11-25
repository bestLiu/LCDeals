
//
//  LCTool.h
//  美团HD
//
//  Created by mac1 on 15/9/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
// 元数据工具类：管理所有的元数据


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCDeal.h"
#import "LCCategory.h"

@interface LCTool : NSObject

/**
 *  返回所有城市
 *
 *  @return 城市
 */
+ (NSArray *)cities;

+ (NSArray *)categories;
+ (LCCategory *)categoryWithDeal:(LCDeal *)deal;

+ (NSArray *)sorts;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
