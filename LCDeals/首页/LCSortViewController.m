//
//  LCSortViewController.m
//  美团HD
//
//  Created by mac1 on 15/9/8.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCSortViewController.h"
#import "LCSort.h"
#import "UIView+Extension.h"

#pragma mark - 自定义按钮,让一个按钮绑定一个排序模型
@interface LCSortButton : UIButton
@property (nonatomic, strong) LCSort *sort;

@end

@implementation LCSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateSelected];
    }
    
    return self;
}

- (void)setSort:(LCSort *)sort
{
    _sort = sort;
    [self setTitle:sort.label forState:UIControlStateNormal];
}

@end

@interface LCSortViewController ()


@end

@implementation LCSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    
    CGFloat height = 0;
    NSArray *sorts = [LCTool sorts];
    NSInteger count = sorts.count;
    for (int i = 0; i < count; i ++) {
        LCSort *sort = sorts[i];
        
        LCSortButton *button = [[LCSortButton alloc] init];
        button.sort = sort;//绑定sort
        button.x = btnX;
        button.y = btnStartY + i*(btnH + btnMargin);
        button.width = btnW;
        button.height = btnH;
        
        [button setTitle:sort.label forState:UIControlStateNormal];
       
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    //设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}
- (void)buttonClick:(LCSortButton *)button
{
    [LCNotifiCationCenter postNotificationName:LCSortDidChangeNotification object:self userInfo:@{LCSortSelectKey:button.sort}];
}


@end
