//
//  LCSortButton.m
//  LCDeals
//
//  Created by mac1 on 15/11/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCSortButton.h"
#import "UIView+Extension.h"

@implementation LCSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        //        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setSort:(LCSort *)sort
{
    _sort = sort;
    [self setTitle:sort.label forState:UIControlStateNormal];
}

@end
