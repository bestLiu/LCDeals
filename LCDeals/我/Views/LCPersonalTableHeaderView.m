//
//  LCPersonalTableHeaderView.m
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCPersonalTableHeaderView.h"

@implementation LCPersonalTableHeaderView


+ (instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LCPersonalTableHeaderView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _headButton.layer.cornerRadius = CGRectGetWidth(_headButton.frame)/2.0;
    _headButton.layer.masksToBounds = YES;
    _headButton.backgroundColor = [UIColor grayColor];
}

@end
