//
//  LCCity.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface LCCity : NSObject

/**
 *  城市名
 */
@property (copy, nonatomic) NSString *name;
/**
 *  城市的拼音
 */
@property (copy, nonatomic) NSString *pinYin;
/**
 *  拼音缩写
 */
@property (copy, nonatomic) NSString *pinYinHead;
/**
 *  地区(存放的都是LCRegion模型)
 */
@property (strong, nonatomic) NSArray *regions;

@end
