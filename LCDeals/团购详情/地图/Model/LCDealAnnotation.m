//
//  LCDealAnnotation.m
//  美团HD
//
//  Created by mac1 on 15/9/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCDealAnnotation.h"

@implementation LCDealAnnotation

- (BOOL)isEqual:(LCDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}



@end
