//
//  BookingContainerController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 21/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TicketsViewController.h"
#import "TourBookingController.h"

@interface BookingContainerController : UIViewController <displayBookingDeegate,BookingCompleteDelegate>

@property(weak, nonatomic) TicketsViewController *ticketsView;
@property(weak, nonatomic) TourBookingController *bookingView;

@property(strong, nonatomic) NSString *tourID;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *ticketQRView;
@property (weak, nonatomic) IBOutlet UIImageView *okImg;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeIMGView;

- (IBAction)closeAction:(id)sender;

@end
