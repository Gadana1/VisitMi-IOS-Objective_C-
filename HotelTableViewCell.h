//
//  HotelTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 02/02/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *cityLB;
@property (strong, nonatomic) IBOutlet UIImageView *hotelthumbnail;
@property (strong, nonatomic) IBOutlet UIButton *bookBT;
@property (strong, nonatomic) IBOutlet UIImageView *ratingIMG;

@property (strong, nonatomic) IBOutlet UIImageView *distanceImg;
@property (strong, nonatomic) IBOutlet UILabel *distanceLB;

@property (strong, nonatomic) IBOutlet UIButton *mapBt;
@property (strong, nonatomic) IBOutlet UIImageView *mapImg;

@property (strong, nonatomic) IBOutlet UILabel *currencyCode;
@property (strong, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIButton *locationBT;


@property (strong, nonatomic) IBOutlet UIImageView *taxiImg;
@property (strong, nonatomic) IBOutlet UIButton *taxiBT;

@end
