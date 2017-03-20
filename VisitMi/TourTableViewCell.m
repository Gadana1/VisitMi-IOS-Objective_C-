//
//  TourTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 17/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TourTableViewCell.h"

@implementation TourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    //TabView Shadow
    self.tabView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tabView.layer.shadowOpacity = 1;
    self.tabView.layer.shadowRadius = 3.f;
    self.tabView.layer.shadowOffset = CGSizeMake(0, -2);
    
    //Image View Shadow
    self.activityIMG.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.activityIMG.layer.shadowOpacity = 1;
    self.activityIMG.layer.shadowRadius = 3.f;
    self.activityIMG.layer.shadowOffset = CGSizeMake(0, 0);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
