//
//  LCPersonalTableViewCell.m
//  LCDeals
//
//  Created by mac1 on 15/11/23.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCPersonalTableViewCell.h"
@interface LCPersonalTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation LCPersonalTableViewCell

- (void)awakeFromNib {
    
}

- (void)setDatas:(NSDictionary *)datas
{
    _iconImageView.image = [UIImage imageNamed:datas[kPersonal_Cell_Icon]];
    _titleLabel.text = datas[kPersonal_Cell_Title];
    _countLabel.text = datas[kPersonal_Cell_Count];
    _arrowImageView.image = [UIImage imageNamed:datas[kPersonal_Cell_Arrow]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
