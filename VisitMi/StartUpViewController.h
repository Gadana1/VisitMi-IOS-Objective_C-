//
//  StartUpViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "HomeViewController.h"
#import "WelcomeViewController.h"
#import "MenuTableView.h"
#import "AppDelegate.h"
#import "CountryCell.h"

@interface StartUpViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,dbConnDelegate,imageDelegate>

@property (strong, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) AppDelegate *app;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UILabel *selectCountryTXT;

-(void)checkConnection;

@end
