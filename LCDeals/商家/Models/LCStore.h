//
//  LCStore.h
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface LCStore : NSObject

//商户ID
@property (copy, nonatomic) NSString *business_id;

//店名
@property (copy, nonatomic) NSString *name;

//显示在表上的icon
@property (copy, nonatomic) NSString *s_photo_url;

//星星
@property (copy, nonatomic) NSString *rating_s_img_url;

//分类
@property (copy, nonatomic) NSArray *categories;

//距离
@property (copy, nonatomic) NSString *distance;

//人均消费
@property (copy, nonatomic) NSString *avg_price;


@property (copy, nonatomic) NSString *business_url;

@end
