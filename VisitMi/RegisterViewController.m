//
//  RegisterViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    NSString *email;
    NSString *password;
    NSString *fName;
    NSString *lName;
    NSString *number;
    NSString *countryCode;

    BOOL doneFName;
    BOOL doneLName;
    BOOL doneEmail;
    BOOL doneNumber;
    BOOL donePassword;
    BOOL doneRetypePass;
    UITextField* activeTextField;
    
    
    BOOL keyboardIsShown;
    double kTabBarHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    
    
    self.firstnameTXT.delegate = self;
    [self.firstnameTXT.layer setCornerRadius:15.0f];
    [self.firstnameTXT.layer setMasksToBounds:YES];
    self.firstnameTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"First Name" attributes:attrDict];

    self.lastnameTXT.delegate = self;
    [self.lastnameTXT.layer setCornerRadius:15.0f];
    [self.lastnameTXT.layer setMasksToBounds:YES];
    self.lastnameTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Last Name" attributes:attrDict];

    self.emailTXT.delegate = self;
    [self.emailTXT.layer setCornerRadius:15.0f];
    [self.emailTXT.layer setMasksToBounds:YES];
    self.emailTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:attrDict];
    
    [self.phoneExtTXT.layer setCornerRadius:15.0f];
    [self.phoneExtTXT.layer setMasksToBounds:YES];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    countryCode = app.userCountry[@"CountryCode"];
    self.phoneExtTXT.text = app.userCountry[@"DialingCode"];
    
    self.phoneTXT.delegate = self;
    [self.phoneTXT.layer setCornerRadius:15.0f];
    [self.phoneTXT.layer setMasksToBounds:YES];
    self.phoneTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Phone" attributes:attrDict];
    [self.phoneTXT addTarget:self action:@selector(validatePhoneNumber) forControlEvents:UIControlEventEditingChanged];
    
    self.passwordTXT.delegate = self;
    [self.passwordTXT.layer setCornerRadius:15.0f];
    [self.passwordTXT.layer setMasksToBounds:YES];
    self.passwordTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:attrDict];
    [self.passwordTXT addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];

    self.retypePassTXT.delegate = self;
    [self.retypePassTXT.layer setCornerRadius:15.0f];
    [self.retypePassTXT.layer setMasksToBounds:YES];
    self.retypePassTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Retype Password" attributes:attrDict];
    [self.retypePassTXT addTarget:self action:@selector(validatePassword) forControlEvents:UIControlEventEditingChanged];

    [self.doneBT.layer setCornerRadius:15.0f];
    [self.doneBT.layer setMasksToBounds:YES];
    
    
    //SetUpOverlayView
    UIViewController *overlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"overlay"];

    self.loadingOverlay = overlayViewController.view;
    
    
    // register for keyboard notifications
   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
    
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    /* */
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.scrollView.delegate = self;
    CGSize scrollContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.bounds.size.height + 50 + ((self.doneBT.frame.origin.y + self.doneBT.frame.size.height) - self.scrollView.bounds.size.height));
    
    [self.scrollView setContentSize:scrollContentSize];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
}
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
    [activeTextField resignFirstResponder];

}


- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
   
    if ([self.navigationController.tabBarController isBeingPresented]) {
        
        kTabBarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    }
    
    else kTabBarHeight = 0;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollView.contentOffset = CGPointMake(0,0);
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
    
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    if ([self.navigationController.tabBarController isBeingPresented]) {
        
        kTabBarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    }
    
    else kTabBarHeight = 0;

    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height+self.messageLB.frame.size.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollView.contentOffset = CGPointMake(0, activeTextField.frame.origin.y - keyboardSize.height);

    [self.scrollView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    if(touch.phase == UITouchPhaseBegan) {
        [activeTextField resignFirstResponder];
    }
    NSLog(@"Touch");
    NSLog(@"Time stamp = %f",touch.timestamp);
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;

}

-(void)validatePhoneNumber
{
    if ([activeTextField isEqual:self.phoneTXT])
    {
        
        NSString *phoneRegex = @"[0-9]{9,11}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL validate = [phoneTest evaluateWithObject:activeTextField.text];
        
        if (validate)
        {
            [self.phoneNumValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            doneNumber = YES;
            self.messageLB.text = NULL;
            
        }
        else if ([activeTextField.text isEqualToString:@""])
        {
            [self.phoneNumValid setImage:NULL];
            doneNumber = NO;
            self.messageLB.text = NULL;
            
        }
        else
        {
            NSMutableString *editedTXT = [NSMutableString stringWithString:activeTextField.text];

            [self.phoneNumValid setImage:[UIImage imageNamed:@"multiply_filled.png"]];
            doneNumber = NO;
            self.messageLB.text = @"Invalid Phone Number";
            
            if (activeTextField.text.length > 11)
            {
                
                [editedTXT deleteCharactersInRange:NSMakeRange(editedTXT.length-1, 1)];
                activeTextField.text = editedTXT;
                [self validatePhoneNumber];
            }
        }
        
        
    }
}
-(void)validatePassword
{
    if ([activeTextField isEqual:self.passwordTXT])
    {
        if (activeTextField.text.length >= 6)
        {
            [self.passwordValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            donePassword = YES;
            self.messageLB.text = NULL;
            
        }
        else if ([activeTextField.text isEqualToString:@""])
        {
            [self.passwordValid setImage:NULL];
            donePassword = NO;
            self.messageLB.text = NULL;
            
        }
        else
        {
            [self.passwordValid setImage:[UIImage imageNamed:@"multiply_filled.png"]];
            donePassword = NO;
            self.messageLB.text = @"Password should be 6 characters and above";

        }
        
        
    }
    else if ([activeTextField isEqual:self.retypePassTXT])
    {
        if (activeTextField.text.length >= 6 && [activeTextField.text isEqualToString:self.passwordTXT.text])
        {
            [self.retypePassValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            doneRetypePass = YES;
            self.messageLB.text = NULL;

        }
        else if ([activeTextField.text isEqualToString:@""])
        {
            [self.retypePassValid setImage:NULL];
            doneRetypePass = NO;
            self.messageLB.text = NULL;
            
        }
        else
        {
            [self.retypePassValid setImage:[UIImage imageNamed:@"multiply_filled.png"]];
            doneRetypePass = NO;
            self.messageLB.text = @"Password doesn't match";
            
            if (self.passwordTXT.text.length < 6)
            {
                self.messageLB.text = @"Password should be 6 characters and above";

                
            }

        }
        
        
    }

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    
    
    if ([textField isEqual:self.firstnameTXT])
    {
        
        
        if (![textField.text isEqualToString:@""])
        {
            [self.fnameValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            doneFName = YES;

        }
        else
        {
            [self.fnameValid setImage:NULL];
            doneFName = NO;

        }
    }
    else if ([textField isEqual:self.lastnameTXT])
    {
        
        if (![textField.text isEqualToString:@""])
        {
            [self.lnameValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            doneLName = YES;

            
        }
        else
        {
            [self.lnameValid setImage:NULL];
            doneLName = NO;

        }
    }
    else if ([textField isEqual:self.emailTXT])
    {
        
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        BOOL validate = [emailTest evaluateWithObject:textField.text];
        
        if (validate)
        {
            [self.emailValid setImage:[UIImage imageNamed:@"checkmark_filled.png"]];
            doneEmail = YES;
            self.messageLB.text = NULL;

        }
        else if ([textField.text isEqualToString:@""] || textField.text==NULL)
        {
            [self.emailValid setImage:NULL];
            doneEmail = NO;
            self.messageLB.text = NULL;

        }
        else
        {
            [self.emailValid setImage:[UIImage imageNamed:@"multiply_filled.png"]];
            doneEmail = NO;
            self.messageLB.text = @"Incorrect email format";

        }
        
    }


}


// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backACC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)proceedReg:(id)sender
{
    if (doneFName && doneLName && doneNumber && doneEmail && donePassword && doneRetypePass)
    {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        email = self.emailTXT.text;
        password = self.passwordTXT.text;
        fName = self.firstnameTXT.text;
        lName = self.lastnameTXT.text;
        number = self.phoneTXT.text;
        countryCode = app.userCountry[@"CountryCode"];
    
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        
        //Get Main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //register
            [self.view addSubview:self.loadingOverlay];
            [conn RegisterUser:fName SecondName:lName Email:email PhoneNumber:[NSString stringWithFormat:@"%@%@",app.userCountry[@"DialingCode"],number] Password:password CountryCode:countryCode];

        });
        
    
    }
    else
    {
        //Check for null fields
        for (UIView *view in [self.view subviews])
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)view;
                
                if ([textField.text isEqualToString:@""])
                {
                    self.messageLB.text = @"Fields can't be empty";
                }
                else self.messageLB.text = NULL;
            }
        }
    }
    
    

    
}

//Response from register Database call
-(void)dbConnResponse:(id)placeObj
{

    PlaceObject *PO = (PlaceObject *)placeObj;
    NSLog(@"Delegate response complete message = %@",PO.dbmessage);

    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageLB.text = PO.dbmessage;
        [self.loadingOverlay removeFromSuperview];
        
        //if registration successfull
        if ([PO.dbstatus isEqualToString:@"success"])
        {
            //Closs modal view
            [self dismissViewControllerAnimated:YES completion:^(void){
                
                
                //call delegate method
                if (self.delegate)
                {
                    [self.delegate regSuccessfull:email Password:password];
                }
                
            }];
            
        }
       
        
        
        
    });
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
   
    
}
@end
