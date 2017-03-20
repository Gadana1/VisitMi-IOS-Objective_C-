//
//  BookingDetailsViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 01/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "BookingDetailsViewController.h"

@interface BookingDetailsViewController ()

@end

@implementation BookingDetailsViewController

BOOL getDirectionsActivatad;
BOOL bookTaxiActivatd;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //statusView Shadow
    self.statusView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.statusView.layer.shadowOpacity = .6;
    self.statusView.layer.shadowRadius = 3.f;
    self.statusView.layer.shadowOffset = CGSizeMake(0, 2);
   
    //priceView Shadow
    self.priceView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.priceView.layer.shadowOpacity = .6;
    self.priceView.layer.shadowRadius = 3.f;
    self.priceView.layer.shadowOffset = CGSizeMake(0, 0);
    
    //passSubView Shadow
    self.passSubView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.passSubView.layer.shadowOpacity = .6;
    self.passSubView.layer.shadowRadius = 5.f;
    self.passSubView.layer.shadowOffset = CGSizeMake(0, 0);
        
    [self.cancelBT.layer setMasksToBounds:YES];
    [self.cancelBT.layer setCornerRadius:5];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.passView addGestureRecognizer:tapGestureRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint touchPoint =[tapGestureRecognizer locationInView:self.passSubView];
    if (touchPoint.y<0 || touchPoint.y > self.passSubView.frame.size.height || touchPoint.x<0 || touchPoint.x > self.passSubView.frame.size.width)
    {
        [self.passView removeWithZoomOutAnimation:.1 option:UIViewAnimationOptionCurveEaseOut];

    }
}


-(void)bookingsDownloaded:(id)bookingOBj
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   
                   {
                       AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                       self.BO = (BookingObject *)bookingOBj;
                       
                       self.navigationItem.title = self.BO.bookingTitle;

                       self.bookingStatusLB.text = self.BO.bookingStatus;
                       if (!self.BO.passID || [self.BO.passID isKindOfClass:[NSNull class]])
                       {
                           self.statusView.backgroundColor = [UIColor darkGrayColor];
                           [self.activeItemsView setHidden:YES];
                           [self.cancelBT setHidden:YES];
                       }
                       
                       if (![self.BO.tourCountryCode isEqualToString:appDelegate.userCountry[@"CountryCode"]]) {
                           
                           [self.infoBT setHidden:YES];
                           
                       }
                       
                       self.bookingDateLB.text =  self.BO.bookingDate;
                       self.tourTitleLB.text = self.BO.bookingTitle;
                       self.tourDateLB.text = self.BO.tourDate;
                       self.tourDetailsLB.text = self.BO.tourDetails;
                       self.currencyCodeLB.text = self.BO.currencyCode;
                       self.priceLB.text = [NSString stringWithFormat:@"%.2f",self.BO.price];
                       
                       
                   });
    
    
}

-(void)gpsLocationFailed
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Location Update Failed!"
                                      message:@"\"VisitMi\" Could not get device current location"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* retry = [UIAlertAction
                                actionWithTitle:@"Try Again"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self getUserLocation];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alert addAction:retry];
        [alert addAction:cancel];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    
        
        
    });
    

}
-(void)gpsNotActivated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Location Service disabled!"
                                      message:@"please enable location service and retry"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* retry = [UIAlertAction
                                actionWithTitle:@"Try Again"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self getUserLocation];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alert addAction:retry];
        [alert addAction:cancel];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    });
    
    
    
}
-(void)gpsLocationSuccessful:(CLLocationCoordinate2D)coordinate
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   
                   {
                       PlaceObject *PO = [[PlaceObject alloc]init];
                       CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.BO.latitude, self.BO.longitude);
                       
                       if(getDirectionsActivatad)
                       {
                           [PO getDirectionsFromCoordinate:coordinate TO_Coordinate:destCoordinate];
                       }
                       else if(bookTaxiActivatd)
                       {
                           [PO setPickUpCoordinate:coordinate DropOffCoordinate:destCoordinate];
                       }
                           
                       
                   });
}

- (IBAction)directionAcc:(id)sender {
   
    getDirectionsActivatad = YES;
    bookTaxiActivatd = NO;

    [self getUserLocation];

}

- (IBAction)taxiAcc:(id)sender {
    
    bookTaxiActivatd = YES;
    getDirectionsActivatad = NO;

    [self getUserLocation];
    
}

//Get user's geolocation
-(void)getUserLocation
{
    //GpsLocationObject *gps = [[GpsLocationObject alloc]init];
    GpsLocationObject *gps = [GpsLocationObject sharedSingleton];
    gps.delegate = self;
    
}

- (IBAction)bookingPassAcc:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.passImageView.image = [appDelegate qrCodeWith:self.BO.passID ImageSize:self.passImageView.frame.size];
    self.passView.frame = self.view.frame;
    [self.view addSubviewWithFadeAnimation:self.passView duration:.2 option:UIViewAnimationOptionCurveEaseIn];
    
}

- (IBAction)infoAcc:(id)sender {
    
    if ([self.BO.bookingType isEqualToString:@"Tour"])
    {
        
        TourViewController *tours = [self.storyboard instantiateViewControllerWithIdentifier:@"tourView"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       
        tours.title = self.BO.bookingTitle;
        tours.imageDownloadCount = 0;
        tours.favoriteType = @"Tours & Activities";
        tours.favoriteImgURL = self.BO.tourImgUrl;
        tours.favoriteName =  self.BO.bookingTitle;
        tours.favoriteImgNO = @"0";
        tours.favoriteDetails = self.BO.tourID;
        
        tours.imagesData = [[NSMutableArray alloc]init];
        tours.availabilities = [[NSMutableArray alloc]init];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = tours;
        [conn GetTourWithID:self.BO.tourID CountryCode:appDelegate.userCountry[@"CountryCode"]];
        
        [conn GetTourAvailabilities:self.BO.tourID CountryCode:appDelegate.userCountry[@"CountryCode"]];
        
        [self.navigationController pushViewController:tours animated:YES];
        
        
    }

}

- (IBAction)cancelBookingAcc:(id)sender {
    
    
    //Confirmation alert
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm Cancellation"
                                  message:@"Are you sure you want to continue?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              DBConnect *conn = [[DBConnect alloc]init];
                              conn.delegate = self;
                              [conn cancelBookingsWithID:self.BO.bookingID];
                              
                              [alert dismissViewControllerAnimated:YES completion:nil];
                              
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.view setUserInteractionEnabled:YES];
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)dbConnResponse:(id)placeObj
{
    PlaceObject *PO = (PlaceObject *)placeObj;
    if ([PO.dbstatus isEqualToString:@"success"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       
                       {
                           self.bookingStatusLB.text = @"Cancelled";
                           self.statusView.backgroundColor = [UIColor darkGrayColor];
                           [self.activeItemsView setHidden:YES];
                           [self.cancelBT setHidden:YES];
                           
                       });

        
    }
    
}

@end
