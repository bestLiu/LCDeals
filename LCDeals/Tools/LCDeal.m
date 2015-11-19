//
//  LCDeal.m
//  美团HD
//
//  Created by mac1 on 15/9/9.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCDeal.h"
#import "MJExtension.h"
#import "LCBusiness.h"

@implementation LCDeal

- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}


- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" :[LCBusiness class]};
}

- (BOOL)isEqual:(LCDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

MJCodingImplementation;

@end
