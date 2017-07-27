//
//  LocationTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 08/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    //TabView Shadow
    self.loc_ImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.loc_ImageView.layer.shadowOpacity = 1;
    self.loc_ImageView.layer.shadowRadius = 3.f;
    self.loc_ImageView.layer.shadowOffset = CGSizeMake(0, 0);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
