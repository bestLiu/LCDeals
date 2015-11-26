//
//  LCPersonalInfoViewController.h
//  LCDeals
//
//  Created by mac1 on 15/11/26.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCBaseViewController.h"

@protocol  LCPersonalInfoViewControllerdDelegete <NSObject>

@optional

- (void)updatePersonalInfoComplition:(NSDictionary *)info;

@end

@interface LCPersonalInfoViewController : LCBaseViewController

@property (nonatomic, weak) id <LCPersonalInfoViewControllerdDelegete> delegte;

@end
