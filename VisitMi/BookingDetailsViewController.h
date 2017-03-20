//
//  BookingDetailsViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 01/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BookingObject.h"
#import "TourViewController.h"
#import "GpsLocationObject.h"

@interface BookingDetailsViewController : UIViewController <dbConnDelegate,gpsLocationDelegate,UIGestureRecognizerDelegate>


@property (strong, nonatomic) BookingObject *BO;
@property (weak, nonatomic) IBOutlet UILabel *bookingDateLB;
@property (weak, nonatomic) IBOutlet UILabel *bookingStatusLB;
@property (weak, nonatomic) IBOutlet UILabel *tourTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *tourDateLB;
@property (weak, nonatomic) IBOutlet UILabel *tourDetailsLB;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *activeItemsView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBT;
@property (weak, nonatomic) IBOutlet UIButton *infoBT;

@property (weak, nonatomic) IBOutlet UIView *passView;
@property (strong, nonatomic) IBOutlet UIView *passSubView;
@property (weak, nonatomic) IBOutlet UIImageView *passImageView;


- (IBAction)directionAcc:(id)sender;
- (IBAction)taxiAcc:(id)sender;
- (IBAction)bookingPassAcc:(id)sender;
- (IBAction)infoAcc:(id)sender;
- (IBAction)cancelBookingAcc:(id)sender;

@end
