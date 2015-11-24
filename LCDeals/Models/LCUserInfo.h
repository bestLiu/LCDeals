//
//  LCUserInfo.h
//  LCDeals
//
//  Created by mac1 on 15/11/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface LCUserInfo : NSObject

@property (copy, nonatomic) NSString *selectedCityName;

singleton_interface(LCUserInfo);
@end
