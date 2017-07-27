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
NSTimer *timer;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.bookingUpdated = false;
    
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
    [self.navigationController setNavigationBarHidden:NO];

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if (!app.bookingUpdated)
     {
         [self update];
     }
    
}

-(void)updateTable
{
    [self performSelector:@selector(update) withObject:nil afterDelay:1];

}

-(void)update
{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if (app.userDetails[@"Email"] == NULL || [app.userDetails[@"Email"] isEqualToString:@""])
    {
        [app.userBookings removeAllObjects];
        app.userBookings = [[NSMutableArray alloc]init];
        app.bookingUpdated = false;
        
        self.backgroundView.center = self.view.center;
        self.bgViewText.text = @"Please Login to view Bookings";
        [self.tableView setBackgroundView:self.backgroundView];
        
    }
    else
    {
        
        
        [self.bookings removeAllObjects];
        self.bookings = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        NSLog(@"called booking");
        [conn GetBookingsForUser:app.userDetails[@"Email"]];
        
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkBookingsCount) userInfo:nil repeats:NO];
       
    }
    

    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}

-(void)checkBookingsCount
{
    if (self.bookings.count < 1) {
        
        self.backgroundView.center = self.view.center;
        self.bgViewText.text = @"No Bookings found";
        [self.tableView setBackgroundView:self.backgroundView];
        

    }
    else
    {
        [self.tableView setBackgroundView:NULL];
    }
    
    [self.tableView reloadData];
    [timer invalidate];

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
