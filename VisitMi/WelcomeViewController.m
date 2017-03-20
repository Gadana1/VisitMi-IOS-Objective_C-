//
//  WelcomeViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 04/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.regBT.layer setCornerRadius:10.0f];
    [self.regBT.layer setMasksToBounds:YES];
    
    
    [self.loginBt.layer setCornerRadius:10.0f];
    [self.loginBt.layer setMasksToBounds:YES];
    
    [self.skipBt.layer setCornerRadius:10.0f];
    [self.skipBt.layer setMasksToBounds:YES];
    
    self.countryTXT.text = self.countryText;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


/*// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}*/

-(void)logInSuccessfull
{
    NSLog(@"Login Successful Delegaate Method initiated");

    id home = [self.storyboard instantiateViewControllerWithIdentifier:@"revealHomeView"];
    [self.navigationController showViewController:home sender:nil];
}

//Registeration delegate method
-(void)regSuccessfull:(NSString *)email Password:(NSString *)password
{
    NSLog(@"Reg Successful Delegaate Method initiated");

    dispatch_async(dispatch_get_main_queue(), ^{
        
        //Login user
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        [conn LoginUser:email Password:password];
        
    });
    
    
}

//Response from Database Login call
-(void)dbConnResponse:(id)placeObj
{
    NSLog(@"DB Delegaate Method initiated");
    PlaceObject *PO = (PlaceObject *)placeObj;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //If login success
        if ([PO.dbstatus isEqualToString:@"success"])
        {
            //Lauch Home view
            id home = [self.storyboard instantiateViewControllerWithIdentifier:@"revealHomeView"];
            [self.navigationController showViewController:home sender:nil];
            
        }
        
        
    });
    
    
    
}


- (IBAction)skipBtAction:(id)sender
{
    
    id home = [self.storyboard instantiateViewControllerWithIdentifier:@"revealHomeView"];
    [self.navigationController showViewController:home sender:nil];
    
}

- (IBAction)registerAction:(id)sender {
    
    RegisterViewController *reg = [self.storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    reg.delegate =self;
    [self presentViewController:reg animated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    
    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    login.delegate = self;
    [self presentViewController:login animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
}
@end
