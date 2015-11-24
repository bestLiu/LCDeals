//
//  LCMoreTableViewCell.h
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCell_Title @"title"
#define kCell_Switch @"switch"
#define kCell_Arrow @"arrow"
#define kCell_count @"count"

@interface LCMoreTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *datas;

@end
