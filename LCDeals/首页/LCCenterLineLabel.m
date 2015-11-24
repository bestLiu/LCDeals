//
//  LCCenterLineLabel.m
//  美团HD
//
//  Created by mac1 on 15/9/9.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCCenterLineLabel.h"

@implementation LCCenterLineLabel


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];//label的文字是画出来的
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    //起点
    CGContextMoveToPoint(context, 0, rect.size.height/2.0);
    
    //连线到另一个点
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2.0);
    CGContextStrokePath(context);
   
    
    //可以直接画矩形框
 //   UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));

}


@end
