//
//  LoginViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

{
    BOOL doneEmail;
    BOOL donePassword;
    UITextField* activeTextField;
    
    
    BOOL keyboardIsShown;
    double kTabBarHeight;
}

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};

    self.emailTXT.delegate = self;
    [self.emailTXT.layer setCornerRadius:15.0f];
    [self.emailTXT.layer setMasksToBounds:YES];
    self.emailTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Email Address" attributes:attrDict];
   
    self.passwordTXT.delegate = self;
    [self.passwordTXT.layer setCornerRadius:15.0f];
    [self.passwordTXT.layer setMasksToBounds:YES];
    self.passwordTXT.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Password" attributes:attrDict];

    [self.continueBT.layer setCornerRadius:15.0f];
    [self.continueBT.layer setMasksToBounds:YES];
    
    self.loadingOverlay.center = self.view.center;
    
    //SetUpOverlayView
    //UIViewController *overlayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"overlay"];
    
    //self.loadingOverlay = overlayViewController.view;
    
    
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
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.scrollView.contentOffset = CGPointMake(0, 0);
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



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (![textField.text isEqualToString:@""])
    {
        [self.emailValid setImage:NULL];
        doneEmail = YES;
        self.messageLB.text = NULL;
    }
    if (![textField.text isEqualToString:@""])
    {
        [self.passwordValid setImage:NULL];
        donePassword = YES;
        self.messageLB.text = NULL;
        
    }
    
}


// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)backACC:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgotPassword:(id)sender {
 
}



- (IBAction)loginAction:(id)sender
{
    if (doneEmail && donePassword)
    {
        
        NSString *email = self.emailTXT.text;
        NSString *password = self.passwordTXT.text;
        
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view addSubview:self.loadingOverlay];
          
            //Login DB call
            [conn LoginUser:email Password:password];
            
        });
       
    }
    else
    {
        for (UIView *view in [self.view subviews])
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)view;
                
                if ([textField.text isEqualToString:@""])
                {
                    self.messageLB.text = @"Fields can't be empty";
                }
            }
        }
    }
        
    
}

//Response from login database call
-(void)dbConnResponse:(id)placeObj
{
    
    PlaceObject *PO = (PlaceObject *)placeObj;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadingOverlay removeFromSuperview];
        self.messageLB.text = PO.dbmessage;
        
        
        if ([PO.dbstatus isEqualToString:@"success"])
        {
            //Dissmiss login modall view
            [self dismissViewControllerAnimated:YES completion:^(void){
                
                //Initiate delegate method
                if (self.delegate)
                {
                    [self.delegate logInSuccessfull];
                }
                
            }];
           
            
        }
        
     
    });
    
  

}

- (IBAction)registerAcc:(id)sender
{
    RegisterViewController *reg = [self.storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    reg.delegate = self;
    [self presentViewController:reg animated:YES completion:nil];
}


//Register Delegate Method
-(void)regSuccessfull:(NSString *)email Password:(NSString *)password
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.emailTXT.text = email;
        self.passwordTXT.text = password;
        
        //Login User right away
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        [self.view addSubview:self.loadingOverlay];
        [conn LoginUser:email Password:password];
        
    });
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
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
