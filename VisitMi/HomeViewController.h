//
//  HomeViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 06/07/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeTableViewCell.h"
#import "ViewController.h"
#import "FlightObject.h"
#import "SWRevealViewController.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIPickerViewDelegate,flightDelegate,imageDelegate>

@property(strong, nonatomic)SVWebViewController *svwWebView;

@property (strong, nonatomic) IBOutlet UIImageView *homeImage;
@property (strong, nonatomic) IBOutlet UIButton *nearByButton;

@property (strong, nonatomic) IBOutlet UIButton *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *homeTableView;

@property (weak, nonatomic) IBOutlet UIView *homeItemsView;

//Flight Options View
@property (weak, nonatomic) IBOutlet UIView *flightOptView;
@property (weak, nonatomic) IBOutlet UIView *flightOptSubView;
@property (weak, nonatomic) IBOutlet UITableView *autoCompTableView;
@property (weak, nonatomic) IBOutlet UIButton *doneBt;
@property (weak, nonatomic) IBOutlet UITextField *orignTXT;
@property (weak, nonatomic) IBOutlet UITextField *destinationTXT;
@property (weak, nonatomic) IBOutlet UIDatePicker *departDate;
@property (weak, nonatomic) IBOutlet UILabel *returnLB;
@property (weak, nonatomic) IBOutlet UIImageView *returnImg;
@property (weak, nonatomic) IBOutlet UIDatePicker *returnDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *flightTypeOpt;

@property(strong, nonatomic) NSMutableArray *autoComplete;


@property(weak, nonatomic)HomeTableViewCell *hCell;
@property(weak, nonatomic)ViewController *loc_ViewController;
@property(weak, nonatomic)DataDynamicTableTableViewController *itemList;
@property(strong, nonatomic)GMSPlacesClient *placeClient;
@property (strong, nonatomic)CLLocationManager *locationManager;

@property(strong, nonatomic)NSArray *menuData;
@property(strong, nonatomic)NSArray *menuIMG;

-(void)updateCountryImage;

- (IBAction)nearByAction:(id)sender;
- (IBAction)doneBtAction:(id)sender;
- (IBAction)flightTypeAction:(id)sender;

@end
