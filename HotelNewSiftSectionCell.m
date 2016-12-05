//
//  HotelNewSiftViewCell.m
//  TCTravel_IPhone
//
//  Created by skladmin on 2016/11/20.
//  Copyright © 2016年 www.ly.com. All rights reserved.
//

#import "HotelNewSiftSectionCell.h"

@interface HotelNewSiftSectionCell ()

@property (nonatomic, weak)IBOutlet UILabel *lblTitle;
@property (nonatomic, weak)IBOutlet UILabel *lblSelectNum;
@property (nonatomic, weak)IBOutlet UIImageView *ivSelectIcon;
@end

@implementation HotelNewSiftSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self hiddenSelectNum];
    // Initialization code
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self hiddenSelectIcon];
    [self hiddenSelectNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureData:(id)data selectForSection:(BOOL)bSelect
{
    self.lblTitle.text = [data titleForShow];
    if ([data arraySections].count > 0) {
        //树枝
        NSInteger iSelectNum = 0;
        if ([data arrayForItems].count > 0) {
            for (id<ItemTagDataSource> item in [data arrayForItems]) {
                if ([item getSelectStatus]) {
                    iSelectNum++;
                }
            }
        }
        [self showSelectNum:iSelectNum];
    }
    else {
        //叶子
        [self showSelectIcon:bSelect];
    }
    
}

- (void)hiddenSelectNum
{
    
}

- (void)showSelectNum:(NSInteger)iSelectNum
{
    if (iSelectNum > 0) {
        self.lblSelectNum.hidden = NO;
        self.lblSelectNum.text = [NSString stringWithFormat:@"%ld",(long)iSelectNum];
    }else {
        [self hiddenSelectNum];
    }
}


- (void)hiddenSelectIcon
{
    
}

- (void)showSelectIcon:(BOOL)bSelect
{
    
}
@end
