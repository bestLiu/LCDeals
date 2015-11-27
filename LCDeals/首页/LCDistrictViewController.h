//
//  LCDistrictViewController.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseViewController.h"

@interface LCDistrictViewController : LCBaseViewController

@property (nonatomic, strong) NSArray *regions;

@property (nonatomic, copy) NSString *navName;

@property (copy, nonatomic) void (^selectedRegionComplicionBlock)(NSDictionary *RegionDic);
@end
