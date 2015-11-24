//
//  LCMoreTableViewCell.m
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCMoreTableViewCell.h"

@interface LCMoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end

@implementation LCMoreTableViewCell



- (void)awakeFromNib {
}

- (void)setDatas:(NSDictionary *)datas
{
    _datas = datas;
    _titleLabel.text = datas[kCell_Title];
    if (datas[kCell_Arrow]) {
        _rightArrow.image = [UIImage imageNamed:datas[kCell_Arrow]];
    }
    if (datas[kCell_Switch]) {
        UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61, 6.5, 51, 31)];
        [self.contentView addSubview:mySwitch];
    }
    if (datas[kCell_count]) {
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 70, 25)];
        countLabel.text = @"0.00";
        countLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:countLabel];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
