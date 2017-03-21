//
//  WelcomeViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 04/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface WelcomeViewController : ViewController <loginDelegate,regDelegate,dbConnDelegate>

@property (strong, nonatomic) IBOutlet UIButton *regBT;
@property (strong, nonatomic) IBOutlet UIButton *loginBt;
@property (strong, nonatomic) IBOutlet UIButton *skipBt;
@property (strong, nonatomic) IBOutlet UILabel *countryTXT;

@property (strong, nonatomic) NSString *countryText;

- (IBAction)skipBtAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
