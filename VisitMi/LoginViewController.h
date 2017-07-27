//
//  LoginViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"

@protocol loginDelegate <NSObject>

-(void)logInSuccessfull;

@end

@interface LoginViewController : UIViewController <UITextFieldDelegate,dbConnDelegate,regDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) id<loginDelegate>delegate;

@property (strong, nonatomic) UIViewController *presentingVC;

@property (strong, nonatomic) IBOutlet UITextField *emailTXT;

@property (strong, nonatomic) IBOutlet UITextField *passwordTXT;

@property (strong, nonatomic) IBOutlet UILabel *messageLB;
@property (strong, nonatomic) IBOutlet UIButton *continueBT;

@property (strong, nonatomic) IBOutlet UIImageView *emailValid;
@property (strong, nonatomic) IBOutlet UIImageView *passwordValid;

@property (strong, nonatomic) IBOutlet UIView *loadingOverlay;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backACC:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)registerAcc:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
