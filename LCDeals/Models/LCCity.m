//
//  LCCity.m
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCCity.h"
#import "LCRegion.h"
@implementation LCCity


//MJExtentsion的使用
- (NSDictionary *)objectClassInArray
{
    return @{@"regions":[LCRegion class]};
}

@end
