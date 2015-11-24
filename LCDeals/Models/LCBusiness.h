//
//  LCBusiness.h
//  美团HD
//
//  Created by mac1 on 15/9/16.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCBusiness : NSObject

/** 店名 */
@property (nonatomic, copy) NSString *name;
/** 纬度 */
@property (nonatomic, assign) float latitude;
/** 经度 */
@property (nonatomic, assign) float longitude;


@end
