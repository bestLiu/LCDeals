//
//  LCCategory.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCategory : NSObject
/**
 *  类别的名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  子类别的名称
 */
@property (nonatomic, strong) NSArray *subcategories;

/**
 *  显示在下拉菜单的小图标
 */
@property (nonatomic, copy) NSString *small_highlighted_icon;
@property (nonatomic, copy) NSString *small_icon;

/**
 *  显示在导航栏顶部的大图标
 */
@property (nonatomic, copy) NSString *highlighted_icon;
@property (nonatomic, copy) NSString *icon;

/**
 *  显示在地图上的图标
 */
@property (nonatomic, copy) NSString *map_icon;

@end
