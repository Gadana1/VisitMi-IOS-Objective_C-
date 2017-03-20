//
//  MoreTableViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 13/03/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    revealViewController.delegate = self;
    
    if ( revealViewController )
    {
        [self.sidebarButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    

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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MoreViewController *more = [segue destinationViewController];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if ([segue.identifier isEqualToString:@"aboutSegue"]) {
        
        more.detailsText = app.appData[@"AboutUs"];
        more.navigationItem.title = @"About VisitMi";
    }
    else if ([segue.identifier isEqualToString:@"termsSegue"])
    {
        more.detailsText = app.appData[@"Terms"];
        more.navigationItem.title = @"Terms And Conditions";

    }
    

}


@end
