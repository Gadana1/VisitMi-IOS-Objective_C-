//
//  PlaceSearchTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 10/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "PlaceSearchTableViewCell.h"

@implementation PlaceSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.provider.layer setCornerRadius:5.0f];
    [self.provider.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
