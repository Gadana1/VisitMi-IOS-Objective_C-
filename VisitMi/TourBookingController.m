//
//  TourBookingController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 21/02/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TourBookingController.h"

@interface TourBookingController ()

@end

@implementation TourBookingController

double doneBtOrign,doneBtHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailsScrollView.delegate = self;
    
    //doneBT Shadow
    self.doneBT.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.doneBT.layer.shadowOpacity = .5f;
    self.doneBT.layer.shadowRadius = 3.f;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.nameLB.text = app.userDetails[@"Name"];
    self.emailLB.text = app.userDetails[@"Email"];
    self.phoneLB.text = app.userDetails[@"Phone"];
    
    self.tourTitleLB.text = app.bookingData[@"tourTitle"];
    self.tourDateLB.text = app.bookingData[@"valueDate"];
    self.tourDetailsLB.text = app.bookingData[@"tourDetails"];

    self.toalPriceLB.text = app.bookingData[@"price"];
    self.currencyCodeLB.text = app.bookingData[@"currencyCode"];


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    doneBtOrign = self.doneBT.frame.origin.y;
    doneBtHeight = self.doneBT.frame.size.height;
    
    self.detailsScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, doneBtOrign + doneBtHeight);

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y + doneBtOrign <  doneBtOrign + doneBtHeight) {
        
        [_scrollDownImage setHidden:NO];
    }
    else
    {
        [_scrollDownImage fadeOutObject:_scrollDownImage duration:.1 option:UIViewAnimationOptionCurveEaseOut];
   
    }
    
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

- (IBAction)finishBookingAction:(id)sender {
    
    [_loading startAnimating];
    [_loading setHidden:NO];
    [self.view setUserInteractionEnabled:NO];
    
     //Confirmation alert
     UIAlertController * alert=   [UIAlertController
     alertControllerWithTitle:@"Confirm Booking"
     message:@"Are you sure you want to continue?"
     preferredStyle:UIAlertControllerStyleAlert];
     
    
    UIAlertAction* yes = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                             DBConnect *conn = [[DBConnect alloc]init];
                             conn.delegate = self;
                             [conn insertTourBooking:app.bookingData[@"email"] TourID:app.bookingData[@"tourID"] TourTitle:app.bookingData[@"tourTitle"] CurrencyCode:app.bookingData[@"currencyCode"] Price:[app.bookingData[@"price"] doubleValue] ValueDate:app.bookingData[@"valueDate"] TourDetails:app.bookingData[@"tourDetails"]];
                             [alert dismissViewControllerAnimated:YES completion:nil];

                         }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [_loading stopAnimating];
                             [_loading setHidden:YES];
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
        
        
        if (self.tourBookingDelegate) {
            
            [self.tourBookingDelegate completeBooking:placeObj];
        }

    }
    else
    {
     
        dispatch_async(dispatch_get_main_queue(), ^(void){
           
            
            [_loading startAnimating];
            [_loading setHidden:NO];
            
            //Confirmation alert
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Booking failed !!"
                                          message:@"Booking could not be made at the moment, please try again later."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [_loading stopAnimating];
                                     [_loading setHidden:YES];
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        });
    }
}

@end
