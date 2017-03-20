//
//  MenuTableView.m
//  VisitMi
//
//  Created by Samuel Gabriel on 08/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "MenuTableView.h"

@interface MenuTableView ()

@end

@implementation MenuTableView

UIColor *menuLabelColor;
UIColor *menuCellColor;
NSInteger selectedRow;
NSInteger selectedSection;
NSInteger unSelectedRow;
NSInteger unSelectedSection;
AppDelegate *app;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    UIImageView *bgIMG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vmBG.jpg"]];
    [bgIMG setAlpha:.6f];
    self.tableView.backgroundView = bgIMG;
    
    //set default selected cell
    selectedRow = 0;
    selectedSection = 1;
    
    //get default color of default selected cell
    menuCellColor = [UIColor colorWithWhite:1 alpha:0.9];
    menuLabelColor = [UIColor darkGrayColor];
    
    
    [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection]] setSelected:false];

    self.userImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.userImage.layer.shadowOpacity = .6;
    self.userImage.layer.shadowRadius = 3.f;
    self.userImage.layer.shadowOffset = CGSizeMake(0, 0);
    [self.userImage.layer setCornerRadius:self.userImage.frame.size.height/2];
    [self.userImage.layer setMasksToBounds:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Set Color to identify  default selected cell
    for (UIView *view in [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection]] contentView] subviews])
    {
        //View Shadow
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 8.f;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        
    }
    
    
    
}

-(void)checkLogInStatus
{
    
    self.userImage.image  = app.userImage!=NULL ? [UIImage imageWithData:app.userImage]:[UIImage imageNamed:@"user_male_circle.png"];
    
    self.userName.text = app.userDetails[@"Name"];
    
    NSString *CRSymbol = @"Copyright © ";
    self.copyrightLB.text = [NSString stringWithFormat:@"%@%@",CRSymbol,app.appData[@"Copyright"]];
    
    if (app.userDetails[@"Name"]) {
        [self.loginLB setText:@"Log Out"];
        self.loginIMG.image =[UIImage imageNamed:@"exit.png"];
        self.logInStatus = true;
    }
    else
    {
        [self.loginLB setText:@"Log In or Sign Up"];
        self.loginIMG.image =[UIImage imageNamed:@"enter.png"];
        self.logInStatus = false;

    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1)
     {
         if (indexPath.row != selectedRow && indexPath.row != 5)
         {
             
             //Set Color to identify selected cell
             for (UIView *view in [[[tableView cellForRowAtIndexPath:indexPath] contentView] subviews])
             {
                 //View Shadow
                 view.layer.shadowColor = [[UIColor blackColor] CGColor];
                 view.layer.shadowOpacity = 1;
                 view.layer.shadowRadius = 8.f;
                 view.layer.shadowOffset = CGSizeMake(0, 0);
                 
             }
             
             selectedRow = indexPath.row;
             selectedSection = indexPath.section;
             NSLog(@"row %lu section %lu selected",indexPath.row, indexPath.section);
             
             
             //Unselect other cells
             for (int index = 0; index <=5; index++)
             {
                 if (indexPath.row != index)
                 {
                     //Set color to default to identify unselected Cell
                    
                     for (UIView *view in [[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]] contentView] subviews])
                     {
                         //View Shadow
                         view.layer.shadowColor = [[UIColor clearColor] CGColor];
                        
                     }
                     
                     NSLog(@"row %d section %lu unselected",index, indexPath.section);
                 }
                
             }
            
             
         }
         else if (indexPath.row == 5) {
             
             AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
             
             NSString *phNo = app.appData[@"CallUs"];
             
             NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt://%@",phNo]];
             
             if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
             {
                 [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:nil];
             }
             else
             {
                 UIAlertController * alert=   [UIAlertController
                                               alertControllerWithTitle:@"Call facility not available !!"
                                               message:@"please try again later"
                                               preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleCancel
                                      handler:^(UIAlertAction * action)
                                      {
                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                      }];
                 
                 [alert addAction:ok];
                 
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }
         
         
     }
    
}


-(void)logInSuccessfull
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self checkLogInStatus];

                   });
    

}

-(void)dbConnResponse:(id)placeObj
{
    PlaceObject *PO = (PlaceObject *)placeObj;
    if ([PO.dbstatus isEqualToString:@"success"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [self checkLogInStatus];
                           
                       });
        

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self checkLogInStatus];
                       [self.navigationController setNavigationBarHidden:YES];
                       self.tableView.contentOffset = CGPointMake(0, 0);

                   });
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAcc:(id)sender
{
    
    //Perform function
    if (self.logInStatus)
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        [conn LogOutUser:app.userDetails[@"Email"] SessionID:app.userDetails[@"SessionID"]];
        
    }
    else
    {
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
        login.delegate =self;
        [self presentViewController:login animated:YES completion:nil];
        
        SWRevealViewController *home = self.revealViewController;
        [home revealToggle:sender];
    }
}


@end
