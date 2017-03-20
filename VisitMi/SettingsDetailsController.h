//
//  SettingsDetailsController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 06/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CountryCell.h"

@interface SettingsDetailsController : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,dbConnDelegate>


@property (assign, nonatomic) BOOL isUserSettings;

//User Settings
@property (weak, nonatomic) IBOutlet UIScrollView *userSettingView;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTXT;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTXT;
@property (weak, nonatomic) IBOutlet UILabel *phoneExtTXT;
@property (weak, nonatomic) IBOutlet UITextField *phoneTXT;

@property (weak, nonatomic) IBOutlet UITextField *passwordTXT;
@property (weak, nonatomic) IBOutlet UITextField *retypePassTXT;
@property (weak, nonatomic) IBOutlet UIButton *doneBT;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *editBt;

//Country Settings
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;

- (IBAction)editAction:(id)sender;

- (IBAction)doneAction:(id)sender;

- (IBAction)photeBTAction:(id)sender;


@end
