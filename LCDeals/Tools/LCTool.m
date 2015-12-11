//
//  LCTool.m
//  美团HD
//
//  Created by mac1 on 15/9/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCTool.h"
#import "LCCity.h"
#import "MJExtension.h"
#import "LCSort.h"

@implementation LCTool

static NSArray *_cities;

+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [LCCity objectArrayWithFilename:@"cities.plist"];
    }
    
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [LCCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [LCSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

+ (LCCategory *)categoryWithDeal:(LCDeal *)deal
{
    NSArray *category = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (LCCategory *ct in category) {
        if ([ct.name isEqualToString:cname]) {
            return ct;
        }
        if ([ct.subcategories containsObject:cname]) {
            return ct;
        }
    }
    
    return nil;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

+ (CGFloat)getTextHeightwithText:(NSString *)text sizeFont:(CGFloat)font
{
   CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return ceilf(rect.size.height);
}


@end
