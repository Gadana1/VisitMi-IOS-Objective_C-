//
//  ItemsTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 13/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "ItemsTableViewCell.h"

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.itemImage setTag:99];
    
    [self.nameLB setTag:98];
    
    [self.stateLB setTag:98];
    
    [self.favButton setTag:97];
    
    //TabView Shadow
    self.tabView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tabView.layer.shadowOpacity = 1;
    self.tabView.layer.shadowRadius = 4.f;
    self.tabView.layer.shadowOffset = CGSizeMake(0, -2);
   
    //Image View Shadow
    self.itemImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.itemImage.layer.shadowOpacity = 1;
    self.itemImage.layer.shadowRadius = 3.f;
    self.itemImage.layer.shadowOffset = CGSizeMake(0, 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
