//
//  LCRegion.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRegion : NSObject

/**
 *  区域名
 */
@property (copy, nonatomic) NSString *name;
/**
 *  子区域
 */
@property (strong, nonatomic) NSArray *subregions;

@end
