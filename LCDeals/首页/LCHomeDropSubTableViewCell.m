//
//  LCHomeDropSubTableViewCell.m
//  美团HD
//
//  Created by mac1 on 15/9/7.
//  Copyright (c) 2015年 BNDK. All rights reserved.
//

#import "LCHomeDropSubTableViewCell.h"

@implementation LCHomeDropSubTableViewCell

+ (instancetype)cellWithTableViw:(UITableView *)tableView
{
    LCHomeDropSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub_cell"];
    if (cell == nil) {
        cell = [[LCHomeDropSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub_cell"];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
