//
//  BookingTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 23/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "BookingTableViewCell.h"

@implementation BookingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    [self.statusLB.layer setCornerRadius:5.0f];
    [self.statusLB.layer setMasksToBounds:YES];
    
    //TabView Shadow
    self.tabView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tabView.layer.shadowOpacity = .6;
    self.tabView.layer.shadowRadius = 3.f;
    self.tabView.layer.shadowOffset = CGSizeMake(0, 0);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
