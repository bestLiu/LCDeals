//
//  LCBaseViewController.h
//  LCDeals
//
//  Created by mac1 on 15/11/18.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCBaseViewController.h"



@interface LCBaseViewController : UIViewController

//导航栏
@property (nonatomic, assign)BOOL showNavigationBar;
@property (nonatomic, readonly)UIImageView *customNavigationBar;
@property (nonatomic, readonly)UIButton *backButton;
@property (nonatomic, strong)NSString *navigationTitle;

//64像素背景色view
@property (nonatomic, strong)UIView *sixtyFourPixelsView;

@end
