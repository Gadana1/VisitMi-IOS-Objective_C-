//
//  SettingsTableViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 06/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

AppDelegate *app;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    revealViewController.delegate = self;
    
    if ( revealViewController )
    {
        [self.sidebarButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self.userImgView.layer setCornerRadius:self.userImgView.frame.size.height/2];
    [self.userImgView.layer setMasksToBounds:YES];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self setData];

                   });
    


}

-(void)setData
{
    
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.nameLB.text = app.userDetails[@"Email"] != NULL? app.userDetails[@"Name"]:@"LogIn Or SignUp";
    
    self.versionLB.text = app.appData[@"Version"];
    NSString *CRSymbol = @"Copyright © ";
    self.copyrightLB.text = [NSString stringWithFormat:@"%@%@",CRSymbol,app.appData[@"Copyright"]];
    self.countryName.text = app.userCountry[@"CountryName"];
    
    self.userImgView.image  = app.userImage!=NULL? [UIImage imageWithData:app.userImage]:[UIImage imageNamed:@"user_male_circle.png"];

    
}


-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    [self.sidebarButton downUnder:.5 option:UIViewAnimationOptionCurveEaseIn];
    
    if (position == 3)
    {
        [self.tableView setUserInteractionEnabled:TRUE];
    }
    else if (position == 4)
    {
        [self.tableView setUserInteractionEnabled:false];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsDetailsController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"settingDetailView"];
    
    if(indexPath.section == 0)
    {
        if(app.userDetails[@"Email"] != NULL)
        {
            if (indexPath.row == 0) {
                
                details.navigationItem.title = @"User Profile";
                details.isUserSettings = YES;
                [self.navigationController pushViewController:details animated:YES];
            }

        }
        else
        {
            LoginViewController *logIn = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
            logIn.delegate = self;
            [self.navigationController presentViewController:logIn animated:YES completion:nil];
        }
        
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            details.navigationItem.title = @"Countries";
            details.navigationItem.prompt = @"Select preferred country :";
            details.isUserSettings = NO;
            [self.navigationController pushViewController:details animated:YES];
        }
        
    }
    

}

-(void)logInSuccessfull
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self setData];
                       
                   });
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
