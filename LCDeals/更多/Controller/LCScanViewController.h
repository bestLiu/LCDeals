//
//  LCScanViewController.h
//  LCDeals
//
//  Created by mac1 on 15/11/27.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCBaseViewController.h"
#import "LBXScanView.h"
#import "LBXScanWrapper.h"
//#import "LBXAlertAction.h"

@interface LCScanViewController : LCBaseViewController


/**
 @brief  扫码功能封装对象
 */
@property (nonatomic,strong) LBXScanWrapper* scanObj;



#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) LBXScanView* qRScanView;


/**
 @brief  扫码当前图片
 */
@property(nonatomic,strong)UIImage* scanImage;


/**
 *  界面效果参数
 */
@property (nonatomic, strong) LBXScanViewStyle *style;

/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign)BOOL isOpenInterestRect;



/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

/**
 @brief  闪关灯开启状态
 */
@property(nonatomic,assign)BOOL isOpenFlash;

//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

@end
