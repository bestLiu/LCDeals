//
//  LCBaseViewController.m
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCBaseViewController.h"


@interface LCBaseViewController ()

@property (nonatomic, readonly)UILabel *navigationLabel;
@property (nonatomic, assign)BOOL initialized;

@end

@implementation LCBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
    
}

- (void)initialize
{
    if (_initialized) {
        return;
    }
    _initialized = YES;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //六十四像素的背景view
    _sixtyFourPixelsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _sixtyFourPixelsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _sixtyFourPixelsView.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [self.view insertSubview:_sixtyFourPixelsView atIndex:1];
    
    
    //init custom navigation bar
    _customNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    _customNavigationBar.userInteractionEnabled = YES;
    _customNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_sixtyFourPixelsView addSubview:_customNavigationBar];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, _customNavigationBar.frame.size.height-1, _customNavigationBar.frame.size.width, 1)];
    line.tag = 10001;
    line.backgroundColor = UIColor_GrayLine;
    [_customNavigationBar addSubview:line];
    
    //title
    _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 120, 44)];
    _navigationLabel.tag = 10002;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin;
    _navigationLabel.font = [UIFont systemFontOfSize:16];
    _navigationLabel.textColor = [UIColor blackColor];
    _navigationLabel.text = _navigationTitle;
    _navigationLabel.backgroundColor = [UIColor clearColor];
    _navigationLabel.textAlignment = NSTextAlignmentCenter;
    _navigationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_customNavigationBar addSubview:_navigationLabel];
    
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 60, 44);
    _backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"Main_Back_btn"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"Main_Back_btn_select"] forState:UIControlStateHighlighted];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -13.0, 0.0, 0.0)];
    [_customNavigationBar addSubview:_backButton];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    if (![_navigationTitle isEqualToString:navigationTitle]) {
        _navigationTitle = navigationTitle;
        _navigationLabel.text = _navigationTitle;
    }
}

- (void)backButtonClicked:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:animated];
}

@end
