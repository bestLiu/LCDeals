//
//  LCHomeDropView.m
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//


#import "LCHomeDropView.h"
#import "LCHomeDropMainTableViewCell.h"
#import "LCHomeDropSubTableViewCell.h"

@interface LCHomeDropView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *followTableViw;
//@property (nonatomic, weak) id<LCHomeDropViewData>selectedData;
/**
 * 记录左边选中的行号
 */
@property (nonatomic, assign) NSInteger selectedMainRow;

@end


@implementation LCHomeDropView

+ (instancetype)dropView
{
    return [[NSBundle mainBundle] loadNibNamed:@"LCHomeDropView" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

#pragma mark 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowsInMainTable:self];
    }
    else{
        return [self.dataSource subdataForRowInMainTable:_selectedMainRow].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView)
    {
        cell = [LCHomeDropMainTableViewCell cellWithTableViw:tableView];
        
        //取出数据模型
    //   id<LCHomeDropViewData>data = [self.dataSource homeDropView:self dataForRowInMainTable:indexPath.row];
        //显示文字
        cell.textLabel.text = [self.dataSource homeDropView:self titleForRowInMainTable:indexPath.row];
        //图片
        if ([self.dataSource respondsToSelector:@selector(homeDropView:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed: [self.dataSource homeDropView:self iconForRowInMainTable:indexPath.row]];
        }
        //高亮图片
        if ([self.dataSource respondsToSelector:@selector(homeDropView:selectedIconForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropView:self selectedIconForRowInMainTable:indexPath.row]];
        }
       
        //附件箭头
        NSArray *subdatas = [self.dataSource subdataForRowInMainTable:indexPath.row];
        if (subdatas.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    else
    {
        NSArray *subdata = [self.dataSource subdataForRowInMainTable:_selectedMainRow];
        cell = [LCHomeDropSubTableViewCell cellWithTableViw:tableView];
        cell.textLabel.text = subdata[indexPath.row];
    }
    
    
    return cell;
}

#pragma mark -表的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        //哪一行被点击
        self.selectedMainRow = indexPath.row;
        [self.followTableViw reloadData];
        
        //通知代理点击了主表
        if ([self.delegate respondsToSelector:@selector(homeDropView:didSelectRowInMainTable:)]) {
            [self.delegate homeDropView:self didSelectRowInMainTable:indexPath.row];
        }
    }else
    {
        //通知代理点击了从表
        if ([self.delegate respondsToSelector:@selector(homeDropView:didSelectRowInSubTable:inMainTable:)]) {
            [self.delegate homeDropView:self didSelectRowInSubTable:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
}

@end
