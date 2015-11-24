//
//  LCDeal.h
//  美团HD
//
//  Created by mac1 on 15/9/9.
//  Copyright (c) 2015年 BNDK. All rights reserved.
// 团购模型

#import <Foundation/Foundation.h>
@class LCRestrictions;

@interface LCDeal : NSObject
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;
/** 团购标题 */
@property (copy, nonatomic) NSString *title;
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;
/** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
/** 团购包含商品原价值 */
@property (strong, nonatomic) NSNumber *list_price;
/** 团购价格 */
@property (strong, nonatomic) NSNumber *current_price;
/** 团购当前已购买数 */
@property (assign, nonatomic) int purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;

/** string	团购单的截止购买日期 */
@property (nonatomic, copy) NSString *purchase_deadline;

@property (copy, nonatomic) NSString *publish_date;

@property (nonatomic, copy) NSString *deal_h5_url;

@property (nonatomic, copy) NSString *deal_url;

@property (nonatomic, strong) LCRestrictions *restrictions;

@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, assign, getter=isediting) BOOL editing;

@property (nonatomic, assign, getter=ischecking) BOOL checking;

@end