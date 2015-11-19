//
//  LCHomeDropView.h
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCHomeDropView;
//@protocol LCHomeDropViewData <NSObject>
//
//- (NSString *)title;
//- (NSString *)icon;
//- (NSString *)selectedIcon;
//- (NSArray *)subdata;
//
//@end


@protocol LCHomeDropViewDataSource <NSObject>

@required
/**
 *  告诉下拉菜单左边的表格有多少行
 */
- (NSInteger) numberOfRowsInMainTable:(LCHomeDropView *)homeDropView;
/**
 *  左边表格每一行的具体数据
 *
 *  @param homeDropView
 *  @param row          行号
 *
 *  @return
 */
//- (id<LCHomeDropViewData>)homeDropView:(LCHomeDropView *)homeDropView dataForRowInMainTable:(NSInteger)row;
- (NSString *)homeDropView:(LCHomeDropView *)homeDropView titleForRowInMainTable:(NSInteger)row;
- (NSArray *)subdataForRowInMainTable:(NSInteger)row;

@optional
- (NSString *)homeDropView:(LCHomeDropView *)homeDropView iconForRowInMainTable:(NSInteger)row;
- (NSString *)homeDropView:(LCHomeDropView *)homeDropView selectedIconForRowInMainTable:(NSInteger)row;
@end

@protocol LCHomeDropViewDelegate <NSObject>

@optional
- (void)homeDropView:(LCHomeDropView *)homeDropView didSelectRowInMainTable:(int)row;
- (void)homeDropView:(LCHomeDropView *)homeDropView didSelectRowInSubTable:(int)row inMainTable:(int)mainRow;

@end

@interface LCHomeDropView : UIView

//@property (nonatomic, strong) NSArray *categroies;

+ (instancetype)dropView;

@property (nonatomic, weak) id<LCHomeDropViewDataSource> dataSource;
@property (nonatomic, weak) id<LCHomeDropViewDelegate> delegate;

@end
