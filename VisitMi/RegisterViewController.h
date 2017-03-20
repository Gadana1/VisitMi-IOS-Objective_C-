//
//  RegisterViewController.h
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "AppDelegate.h"


@protocol regDelegate <NSObject>

-(void)regSuccessfull:(NSString *)email Password:(NSString *)password;

@end

@interface RegisterViewController : UIViewController <UITextFieldDelegate,dbConnDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) id<regDelegate>delegate;

@property (strong, nonatomic) IBOutlet UITextField *firstnameTXT;
@property (strong, nonatomic) IBOutlet UITextField *lastnameTXT;
@property (strong, nonatomic) IBOutlet UITextField *emailTXT;
@property (strong, nonatomic) IBOutlet UILabel *phoneExtTXT;
@property (strong, nonatomic) IBOutlet UITextField *phoneTXT;
@property (strong, nonatomic) IBOutlet UILabel *messageLB;

@property (strong, nonatomic) IBOutlet UITextField *passwordTXT;
@property (strong, nonatomic) IBOutlet UITextField *retypePassTXT;
@property (strong, nonatomic) IBOutlet UIButton *doneBT;

- (IBAction)backACC:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *emailValid;
@property (strong, nonatomic) IBOutlet UIImageView *passwordValid;
@property (strong, nonatomic) IBOutlet UIImageView *fnameValid;
@property (strong, nonatomic) IBOutlet UIImageView *lnameValid;
@property (strong, nonatomic) IBOutlet UIImageView *phoneNumValid;
@property (strong, nonatomic) IBOutlet UIImageView *retypePassValid;

@property (strong, nonatomic) IBOutlet UIView *loadingOverlay;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
