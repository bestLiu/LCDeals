//
//  LCPersonalTableHeaderView.h
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPersonalTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

+ (instancetype)headerView;

@end
