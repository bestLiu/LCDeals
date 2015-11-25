//
//  LCSortButton.h
//  LCDeals
//
//  Created by mac1 on 15/11/25.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSort.h"

#pragma mark - 自定义按钮,让一个按钮绑定一个排序模型
@interface LCSortButton : UIButton
@property (nonatomic, strong) LCSort *sort;

@end

@interface LCSortViewController : UIViewController

@end