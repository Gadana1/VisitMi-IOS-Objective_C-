//
//  PlaceSearchTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 10/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceSearchTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *nameLb;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIImageView *distanceImg;
@property (strong, nonatomic) IBOutlet UILabel *distanceLB;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadCell;
@property (strong, nonatomic) IBOutlet UIButton *direction;
@property (strong, nonatomic) IBOutlet UIImageView *provider;
@property (strong, nonatomic) IBOutlet UIButton *taxiBT;

@property (strong, nonatomic) IBOutlet UIButton *favButton;

@end
