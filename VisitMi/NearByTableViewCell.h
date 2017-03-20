//
//  NearByTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 09/06/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *catLB;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *distanceLB;
@property (strong, nonatomic) IBOutlet UIButton *locationBT;
@property (strong, nonatomic) IBOutlet UIButton *taxiBT;
@property (strong, nonatomic) IBOutlet UIImageView *taxiImg;

@end
