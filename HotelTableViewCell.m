//
//  HotelTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 02/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "HotelTableViewCell.h"

@implementation HotelTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
    [self.hotelthumbnail.layer setCornerRadius:5.0f];
    [self.hotelthumbnail.layer setMasksToBounds:YES];
    
    self.hotelthumbnail.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.hotelthumbnail.layer.shadowOpacity = 1;
    self.hotelthumbnail.layer.shadowRadius = 4.f;
    self.hotelthumbnail.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    self.bookBT.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.bookBT.layer.shadowOpacity = 1;
    self.bookBT.layer.shadowRadius = 3.f;
    self.bookBT.layer.shadowOffset = CGSizeMake(0, 0);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bookBT:(id)sender {
}
@end
