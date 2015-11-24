//
//  LCStoreTableViewCell.m
//  LCDeals
//
//  Created by mac1 on 15/11/24.
//  Copyright © 2015年 BNDK. All rights reserved.
//

#import "LCStoreTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface LCStoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end

@implementation LCStoreTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setStore:(LCStore *)store
{
    _store = store;
    NSRange nameRange = [store.name rangeOfString:@"("];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:store.s_photo_url]];
    self.nameLabel.text = [store.name substringWithRange:NSMakeRange(0, nameRange.location)];
    [self.starImageView sd_setImageWithURL:[NSURL URLWithString:store.rating_s_img_url]];
    self.avgLabel.text = [NSString stringWithFormat:@"人均消费￥%@元",store.avg_price];
    self.distanceLabel.text = store.distance;
    
    for (NSString *str in store.categories) {
        self.categoryLabel.text = str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
