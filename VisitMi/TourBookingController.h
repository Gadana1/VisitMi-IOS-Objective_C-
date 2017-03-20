//
//  TourBookingController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 21/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol BookingCompleteDelegate <NSObject>

-(void)completeBooking:(id)placeobj;

@end

@interface TourBookingController : UIViewController <UIScrollViewDelegate, dbConnDelegate>

@property (weak, nonatomic) id <BookingCompleteDelegate> tourBookingDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneLB;
@property (weak, nonatomic) IBOutlet UILabel *tourTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *tourDateLB;
@property (weak, nonatomic) IBOutlet UILabel *tourDetailsLB;
@property (weak, nonatomic) IBOutlet UILabel *toalPriceLB;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLB;
@property (weak, nonatomic) IBOutlet UIImageView *scrollDownImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

- (IBAction)finishBookingAction:(id)sender;

@end
