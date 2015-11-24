//
//  LCPersonalTableViewCell.h
//  LCDeals
//
//  Created by mac1 on 15/11/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPersonal_Cell_Icon @"icon"

#define kPersonal_Cell_Title @"title"

#define kPersonal_Cell_Count @"count"

#define kPersonal_Cell_Arrow @"arrow"

@interface LCPersonalTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *datas;

@end
