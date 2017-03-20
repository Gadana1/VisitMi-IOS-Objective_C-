//
//  BookingTableViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 05/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "BookingTableViewController.h"

@implementation BookingTableViewController

UIActivityIndicatorView *loading;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.revealViewController.delegate = self;
    SWRevealViewController *revealViewController = self.revealViewController;

    if ( revealViewController )
    {
        [self.sidebarButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    
    loading.center = self.tableView.center;
    [self.tableView setBackgroundView:loading];
    
    
    //setup cell
    self.tableView.rowHeight = 145.f;
    [self.tableView registerNib:[UINib nibWithNibName:@"BookingTableViewCell" bundle:nil] forCellReuseIdentifier:@"bookingCell"];
    
    
    //Refresh Control Settings
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self update];
                   });
    
}
-(void)updateTable
{
    
    [self performSelector:@selector(update) withObject:nil afterDelay:1];
    [self.refreshControl endRefreshing];

}

-(void)update
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.bookings = [[NSMutableArray alloc]init];
    
    if (!app.bookingUpdated)
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        [conn GetBookingsForUser:app.userDetails[@"Email"]];
        
    }
    else
    {
        if (app.userDetails[@"Email"] == NULL) {
            
            app.userBookings = [[NSMutableArray alloc]init];
            app.bookingUpdated = false;

        }
        
        self.bookings = app.userBookings;
    }

    [self.tableView reloadData];
}


-(void)bookingsDownloaded:(id)bookingOBj
{
    [self.bookings addObject:bookingOBj];
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self.tableView reloadData];
                       [loading stopAnimating];

                   });
}

-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    [self.sidebarButton downUnder:.5 option:UIViewAnimationOptionCurveEaseIn];
    
    if (position == 3)
    {
        [self.tableView setUserInteractionEnabled:TRUE];
        [self update];
    }
    else if (position == 4)
    {
        [self.tableView setUserInteractionEnabled:false];
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
 
    return self.bookings.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookingTableViewCell *bCell = [tableView dequeueReusableCellWithIdentifier:@"bookingCell"];

    if (bCell == nil)
    {
        return [[UITableViewCell alloc]init];
    }
    
    BookingObject *BO = (BookingObject *)[self.bookings objectAtIndex:indexPath.row];
    
    bCell.bookingTitleLB.text = BO.bookingTitle;
    bCell.bookingTypeLB.text = BO.bookingType;
    bCell.bookingDateLB.text = BO.bookingDate;
    bCell.currencyCodeLB.text = BO.currencyCode;
    bCell.priceLB.text = [NSString stringWithFormat:@"%.2f", BO.price];
    bCell.statusLB.text = BO.bookingStatus;
    [bCell.statusLB setBackgroundColor:BO.bookingStatusColor];
    

    
    return bCell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookingDetailsViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"bookingDetailView"];
    BookingObject *BO = (BookingObject *)[self.bookings objectAtIndex:indexPath.row];
    DBConnect *conn = [[DBConnect alloc]init];
    conn.delegate = detailView;

    [conn GetBookingsWithID:BO.bookingID Type:BO.bookingType];
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    
    

    
}

@end
