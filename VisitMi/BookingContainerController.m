//
//  BookingContainerController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 21/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "BookingContainerController.h"

@interface BookingContainerController ()

@end

@implementation BookingContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.ticketsView = (TicketsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ticketsView"];
   
    self.bookingView = (TourBookingController*)[self.storyboard instantiateViewControllerWithIdentifier:@"bookingView"];

    
    self.ticketsView.tickets = [[NSMutableArray alloc]init];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    DBConnect *conn = [[DBConnect alloc]init];
    conn.delegate = self.ticketsView;
    [conn GetTourTickets:self.tourID CountryCode:app.userCountry[@"CountryCode"]];
    
    NSLog(@"%@",app.bookingData);
    
    self.ticketsView.bookingDelegate = self;

    self.ticketsView.view.frame = self.viewContainer.frame;
    [self.viewContainer addSubview:self.ticketsView.view];
    [self addChildViewController:self.ticketsView];
    [self.ticketsView didMoveToParentViewController:self];
    
    self.bookingView.tourBookingDelegate = self;
    [self addChildViewController:self.bookingView ];
    [self.bookingView didMoveToParentViewController:self];
    
}

-(void)displayBooking
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                      
                       [self.ticketsView.view removeWithZoomOutAnimation:.2 option:UIViewAnimationOptionCurveEaseOut];
                       self.bookingView.view.center = self.viewContainer.center;
        
                       [self.viewContainer addSubviewWithFadeAnimation:self.bookingView.view duration:.1 option:UIViewAnimationOptionTransitionFlipFromRight];
                       
                      
                       
                   });
    
}

-(void)completeBooking:(id)placeobj
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       PlaceObject *PO = (PlaceObject *)placeobj;
                       AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                       
                       self.qrCodeIMGView.image = [app qrCodeWith:PO.dbmessage ImageSize:self.qrCodeIMGView.frame.size];

                       [self.bookingView.view removeWithZoomOutAnimation:.2 option:UIViewAnimationOptionCurveEaseOut];
                       self.ticketQRView.center= CGPointMake(self.viewContainer.frame.size.width/2, self.viewContainer.frame.size.height/2 - 44);
                       [self.viewContainer addSubviewWithFadeAnimation:self.ticketQRView duration:.1 option:UIViewAnimationOptionTransitionFlipFromRight];
                       [self.okImg popObject:.2 option:UIViewAnimationOptionCurveEaseInOut];
                       
                   });
    
    
}



- (IBAction)closeAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
