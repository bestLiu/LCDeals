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
    
    if (datas[@"islast"]) {
        
        //遍历约束
        NSArray* constrains = self.contentView.constraints;
        for (NSLayoutConstraint* constraint in constrains) {
            if (constraint.firstAttribute == NSLayoutAttributeLeading) {
                // 默认左右加了8的空白所以屏幕宽度实际上是小了16
                constraint.constant = (SCREEN_WIDTH- 16 - CGRectGetWidth(_titleLabel.frame))*0.5;
                break;
            }
            
        }
        _titleLabel.textAlignment = 1;
        _titleLabel.textColor = [UIColor redColor];
    }
}


@end
