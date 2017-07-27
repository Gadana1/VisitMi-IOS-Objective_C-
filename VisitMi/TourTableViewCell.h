//
//  TourTableViewCell.h
//  VisitMi
//
//  Created by Samuel Gabriel on 17/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TourTableViewCell : UITableViewCell

@property (strong, nonatomic) AppDelegate *appDelegate ;
@property (retain, nonatomic)PlaceObject *PO;

@property (strong, nonatomic) IBOutlet UIImageView *activityIMG;
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *durationLB;
@property (strong, nonatomic) IBOutlet UILabel *currencyLB;
@property (strong, nonatomic) IBOutlet UILabel *priceLB;
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIView *tabView;


@end
