//
//  CountryCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 12/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "CountryCell.h"

@implementation CountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.countryLB.layer setMasksToBounds:YES];
    [self.countryLB.layer setCornerRadius:5];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
