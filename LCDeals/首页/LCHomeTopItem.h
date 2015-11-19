//
//  LCHomeTopItem.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface LCHomeTopItem : UIView


+ (instancetype)item;

- (void)addTarget:(id)target action:(SEL)action;


- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setIcon:(NSString *)icon highlightIcon:(NSString *)highlightIcon;

@end
