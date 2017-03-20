//
//  BookmarkTableViewCell.m
//  VisitMi
//
//  Created by Samuel Gabriel on 08/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "BookmarkTableViewCell.h"

@implementation BookmarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.itemImage.layer setCornerRadius:5.0f];
    [self.itemImage.layer setMasksToBounds:YES];
    
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
