//
//  DataDynamicTableTableViewController.m
//  VisitMi
//
//  Created by Samuel on 10/20/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "DataDynamicTableTableViewController.h"


@interface DataDynamicTableTableViewController ()



@end

NSString *city;
NSString *administrativeArea;
NSString *favouriteName;
NSString *favouriteType;
NSString *favouriteImgUrl;
NSString *favouriteImgNo;
NSString *favouriteDetails;
CGFloat maxDistance;

static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear
};

@implementation DataDynamicTableTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.rightBarItems = [[NSMutableArray alloc]initWithArray:self.navigationItem.rightBarButtonItems];
    
    _spinnerView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-20,([UIScreen mainScreen].bounds.size.height/2)-84, 40.0, 40.0);
    
    
    [self.tableView setBackgroundView:_spinnerView];
    
   /* self.backgroundView.center = self.view.center;
    CGRect frame = self.backgroundView.frame;
    frame.origin.y = self.view.frame.size.height/2 - self.backgroundView.frame.size.height/2; */
    self.backgroundView.frame = self.view.frame;
    
    [self.scrollUpBt setHidden:YES];
    [self.scrollUpBt.layer setCornerRadius:10.0f];
    [self.scrollUpBt.layer setMasksToBounds:YES];
    
    //check for internet connection
    if(![CheckInternet isInternetConnectionAvailable:NULL]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"NO INTERNET ACCESS!"
                                      message:@"Please check your device connectivity settings"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        
    }

    self.title = self.displayRegion;
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    NSLog(@"display region %@", _displayRegion);
    
    //Perform specific actions for specific fuctions
    if([_displayRegion isEqualToString:@"Attractions"])
    {

        [self.filterBt setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];

        if ([self.rightBarItems containsObject:_locationBarBt])
        {
            [self.rightBarItems removeObject:_locationBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
            
        }
        
        //Create Search Controller
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        self.searchController.searchResultsUpdater = self;
        

        self.navigationItem.titleView = _searchController.searchBar;
        
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        
        [self.searchController.searchBar sizeToFit];
        [self.searchController.searchBar clipsToBounds];
        [self.searchController.searchBar setReturnKeyType:UIReturnKeyDone];
        [self.searchController.searchBar setEnablesReturnKeyAutomatically:YES];

        self.searchController.searchBar.placeholder=@"Type to Search";
        self.searchController.searchBar.showsCancelButton = false;
        
        self.definesPresentationContext = YES;
        
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
        //setup cell
        self.tableView.estimatedRowHeight = 215.f;
        self.tableView.rowHeight = 215.f;
        [self.tableView registerNib:[UINib nibWithNibName:@"ItemsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
        
        self.PO.delegate = self;
        
    }
    else if([_displayRegion isEqualToString:@"Tours & Activities"])
    {
        
        [self.filterBt setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];

        if ([self.rightBarItems containsObject:_locationBarBt])
        {

            [self.rightBarItems removeObject:_locationBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
            
        }
        
        //Create Search Controller
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        self.searchController.searchResultsUpdater = self;
        
        
        self.navigationItem.titleView = _searchController.searchBar;
        
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        
        [self.searchController.searchBar sizeToFit];
        [self.searchController.searchBar clipsToBounds];
        [self.searchController.searchBar setReturnKeyType:UIReturnKeyDone];
        [self.searchController.searchBar setEnablesReturnKeyAutomatically:YES];

        self.searchController.searchBar.placeholder=@"Type to Search";
        self.searchController.searchBar.showsCancelButton = false;
        
        self.definesPresentationContext = YES;
        
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
        
        
        //setup cell
        self.tableView.estimatedRowHeight = 215.f;
        self.tableView.rowHeight = 215.f;
        [self.tableView registerNib:[UINib nibWithNibName:@"TourTableViewCell" bundle:nil] forCellReuseIdentifier:@"tourCell"];
        
        
    }
    else if([_displayRegion isEqualToString:@"Nearby"])
    {
        
        [self.filterBt setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
        
        if (!([self.rightBarItems containsObject:_locationBarBt]))
        {
            [self.rightBarItems addObject:_locationBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
            
        }
        
        [self getUserLocation];
        
        //Create Search Controller
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        self.searchController.searchResultsUpdater = self;
        
        
        self.navigationItem.titleView = _searchController.searchBar;
        
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        
        [self.searchController.searchBar sizeToFit];
        [self.searchController.searchBar clipsToBounds];
        [self.searchController.searchBar setReturnKeyType:UIReturnKeyDone];
        [self.searchController.searchBar setEnablesReturnKeyAutomatically:YES];
        
        self.searchController.searchBar.placeholder=@"Type to Search";
        self.searchController.searchBar.showsCancelButton = false;
        
        self.definesPresentationContext = YES;
        
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
        UIImageView *footerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"poweredby-one-color-cdf070cc7ae72b3f482cf2d075a74c8c.png"]];
        CGRect frame = footerImg.frame;
        frame.size.height = 44;
        footerImg.frame = frame;
        footerImg.contentMode = UIViewContentModeScaleAspectFit;
        
        self.tableView.tableFooterView = footerImg;
        
        //setup cell
        self.tableView.estimatedRowHeight = 110.f;
        self.tableView.rowHeight = 110.f;
        [self.tableView registerNib:[UINib nibWithNibName:@"NearByTableViewCell" bundle:nil] forCellReuseIdentifier:@"NBItemCell"];
        
    }
    else
    {
        
        if (!([self.rightBarItems containsObject:_locationBarBt]))
        {
            [self.rightBarItems addObject:_locationBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
            
        }
        
        [self getUserLocation];

        
        //Perform specific actions for specific fuctions
        if([_displayRegion isEqualToString:@"Lodging"])
        {
            //setup cell
            self.tableView.estimatedRowHeight = 170.f;
            self.tableView.rowHeight = 170;
            [self.tableView registerNib:[UINib nibWithNibName:@"HotelTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotelCell"];
            
            UIImageView *footerImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Expedia_TripAdvisor.png"]];
            [footerImg setBackgroundColor:[UIColor clearColor]];
            
            footerImg.contentMode = UIViewContentModeScaleAspectFit;
            CGRect frame = footerImg.frame;
            frame.size.height = 44;
            footerImg.frame = frame;
            self.tableView.tableFooterView = footerImg;

        }
        
        else
        {
            //setup cell
            self.tableView.estimatedRowHeight = 130.f;
            self.tableView.rowHeight = 130.f;
            [self.tableView registerNib:[UINib nibWithNibName:@"PlaceSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"placeCell"];
            self.DO.delegate = self;


        }
        
        //Create Search Controller
        _acController = [[GMSAutocompleteResultsViewController alloc] init];
        _acController.delegate = self;
        _acController.tintColor = [UIColor orangeColor];
        
        // Set up the autocomplete filter.
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        filter.country = app.userCountry[@"CountryCode"];
        _acController.autocompleteFilter = filter;
        
        
        
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:_acController];
        
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        self.searchController.searchResultsUpdater = _acController;

        self.navigationItem.titleView = _searchController.searchBar;
        
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        
        self.searchController.dimsBackgroundDuringPresentation = NO;
        
        [self.searchController.searchBar sizeToFit];
        [self.searchController.searchBar clipsToBounds];
        
        self.searchController.searchBar.placeholder=@"Search Location";
        self.searchController.searchBar.showsCancelButton = false;
        
        self.definesPresentationContext = YES;
        
        self.tableView.contentOffset = CGPointMake(0.0,0.0);
    

    }
   
 
    
    //Refresh Control Settings
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl =refreshControl;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView setUserInteractionEnabled:YES];

    
}



- (IBAction)myLocAction:(id)sender
{

    [self getUserLocation];
    
}

//Get user's geolocation
-(void)getUserLocation
{
    _searchActivated =  false;
    
    [self.locationBt bounce:1 option:curveValues[1]];
    
    [self.tableView setBackgroundView:_spinnerView];
    [_spinnerView startAnimating];
    [self.spinnerView setHidden:NO];
    

    //GpsLocationObject *gps = [[GpsLocationObject alloc]init];
    GpsLocationObject *gps = [GpsLocationObject sharedSingleton];
     gps.delegate = self;

}


-(void)gpsNotActivated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Location Service disabled!"
                                      message:@"please enable location service and retry"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* retry = [UIAlertAction
                                actionWithTitle:@"Try Again"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self.tableView setBackgroundView:_spinnerView];
                                    [self getUserLocation];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self.tableView setBackgroundView:_backgroundView];
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [alert addAction:retry];
        [alert addAction:cancel];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    
    });
    
    
    

}

-(void)gpsLocationSuccessful:(CLLocationCoordinate2D)coordinate
{
    
    self.location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             
             NSLog(@"Monday");
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
             
             AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

             if ([placemark.ISOcountryCode isEqualToString:app.userCountry[@"CountryCode"]]) {
                 
                 self.coordinate = coordinate;
                 self.gpsActivated = YES;
                 
                 [self downloadData];
                 
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 
                 [self.locationBt popObject:.1 option:UIViewAnimationOptionCurveEaseIn];
                 [self.locationBt setImage:[UIImage imageNamed:@"location_filled.png"] forState:UIControlStateNormal];
                 [self.locationBt setEnabled:true];
             }
             else
             {
                 if ([self.displayRegion isEqualToString:@"Nearby"]) {
                     
                     self.bgViewText.text = @"This function is only available for the selected country";
                 }
                 
                 [self.tableView setBackgroundView:_backgroundView];

             }
             
             
         }];
        
       
        
    });
    

}

-(void)gpsLocationFailed
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.gpsActivated = NO;

        [self.locationBt setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self.locationBt setEnabled:true];
        [self.tableView setBackgroundView:_backgroundView];
        
        if (!self.searchActivated)
        {
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Location Update Failed!"
                                          message:@"\"VisitMi\" Could not get device current location"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* retry = [UIAlertAction
                                    actionWithTitle:@"Try Again"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self.tableView setBackgroundView:_spinnerView];
                                        [self getUserLocation];
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self.tableView setBackgroundView:_backgroundView];
                                         
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:retry];
            [alert addAction:cancel];
            
            [self.navigationController presentViewController:alert animated:YES completion:nil];
            
            
            
        }

        
    });
    
   
    
}

// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [resultsController dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.searchController setActive:NO];
        [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        
        //shows gps location deactivated for manaul mode
        [self.locationBt setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        
        self.coordinate= place.coordinate;
        
        [self.tableView setBackgroundView:_spinnerView];
        [_spinnerView startAnimating];
        [self.spinnerView setHidden:NO];
        
        _searchActivated =  true;
        [self downloadData];
        
    });
   
  
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [resultsController dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.searchController setActive:NO];
        [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        
        //shows gps location deactivated for manaul mode
        [self.locationBt setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        
        
        // TODO: handle the error.
        NSLog(@"Error: %@", [error description]);
    });
   
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    _searchActivated =  true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    _searchActivated =  true;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//Api call to download data
-(void)downloadData
{
   
    if([self.displayRegion isEqualToString:@"Dining"])
    {
        _count = 0;
        _presentCount = 0;
        self.displayRegionArr = NULL;
        self.displayRegionArr = [[NSMutableArray alloc]init];
        
        [self.tableView reloadData];
        
        self.DO = [[DinningObject alloc]init];
        self.DO.delegate = self;
        self.DO .doneGoogle = false;
        self.DO .doneForeSquare = false;
        self.DO .doneZomato = false;
        
        [self.DO downloadItems:self.coordinate.longitude latitude:self.coordinate.latitude];
        
    }
    else if([self.displayRegion isEqualToString:@"Shopping"])
    {
        _count = 0;
        _presentCount = 0;
        self.displayRegionArr = NULL;
        self.displayRegionArr = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
        
        self.SHOP = [[ShoppingObject alloc]init];
        self.SHOP.delegate = self;
        self.SHOP .doneGoogle = false;
        self.SHOP .doneForeSquare = false;
        
        [self.SHOP downloadItems:self.coordinate.longitude latitude:self.coordinate.latitude];
        
    }
    
    else if([self.displayRegion isEqualToString:@"Lodging"])
    {
        _count = 0;
        _presentCount = 0;
        self.displayRegionArr = NULL;
        self.displayRegionArr = [[NSMutableArray alloc]init];
        [self.tableView reloadData];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self;
        
        if (maxDistance <= 0) maxDistance = 10;
        
        [conn GetHotels:app.userCountry[@"CountryCode"]  Latitude:self.coordinate.latitude Longitude:self.coordinate.longitude MaxDistance:maxDistance];
        
    }
    else if([self.displayRegion isEqualToString:@"Nearby"])
    {
        _count = 0;
        _presentCount = 0;
        self.displayRegionArr = NULL;
        self.displayRegionArr = [[NSMutableArray alloc]init];
        self.finalDataArr = [[NSMutableArray alloc]init];
        self.scopes = [[NSMutableArray alloc]init];
        [self.scopes addObject:@"All"];
        [self.tableView reloadData];
        
        self.NBO = [[NearByObject alloc]init];
        self.NBO.delegate = self;
        [self.NBO downloadItems:self.coordinate.longitude latitude:self.coordinate.latitude];
        
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

//update data
-(void)updateTableData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.isFilltered)
        {
            _presentCount = self.displayRegionArr.count;
            
            
            
            if (_presentCount!= 0 && _count != _presentCount)
            {
                [self.tableView beginUpdates];
                
                self.indexPaths = [[NSMutableArray alloc] init];
                
                
                for (NSUInteger i = _count; i < _presentCount; i++)
                {
                    [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.tableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [self.tableView endUpdates];
                
                _count = _presentCount;
                
                
            }
            
            else
            {
                [_spinnerView stopAnimating];
                [self.spinnerView setHidden:YES];
                [self.tableView reloadData];
                
            }
            
            
        }
        else
        {
            _presentCount = self.searchArr.count;
            
            
            if (_presentCount!= 0 && _count != _presentCount)
            {
                [self.tableView beginUpdates];
                
                self.indexPaths = [[NSMutableArray alloc] init];
                
                
                for (NSUInteger i = _count; i < _presentCount; i++)
                {
                    [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.tableView insertRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
                [self.tableView endUpdates];
                
                _count = _presentCount;
                
                
            }
            
            else
            {
                [_spinnerView stopAnimating];
                [self.spinnerView setHidden:YES];
                [self.tableView reloadData];

            }
            
        }
        
        
        
    });
    
    

}


//Methods for Refreshing table

-(void)update:(id)sender
{
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}


//Update Table when Refresh is trigerred
-(void)updateTable
{
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    if (self.displayRegionArr.count != 0)
    {
        [_spinnerView stopAnimating];
        [self.spinnerView setHidden:YES];
        [self updateTableData];

        
    }
    else
    {

        [self updateTableData];
    }
    NSLog(@" Display region array count %lu",(unsigned long)self.displayRegionArr.count);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{

    [self.searchController setActive:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.searchController.searchBar setShowsCancelButton:YES animated:YES];
    _searchActivated =  true;

}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar

{
    _searchActivated =  false;
    
}

//Search bar cancel button actions
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
    _searchActivated =  false;
    if([_displayRegion isEqualToString:@"Attractions"] || [_displayRegion isEqualToString:@"Tours & Activities"])
    {
        [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.searchController setActive:NO];
        self.isFilltered = NO;
        _presentCount = 0;
        _count = 0;
        [self.tableView reloadData];
        
        [self updateTableData];
        

    }
    else
    {
        [self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.searchController setActive:NO];

    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 100) {
        
        if (!([self.rightBarItems containsObject:_scrollUpBarBt]))
        {
            [self.rightBarItems addObject:_scrollUpBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
            [self.scrollUpBt fadeInObject:self.scrollUpBt duration:.2 option:UIViewAnimationOptionCurveEaseIn];
            //[self.scrollUpBt popObject:.1 option:curveValues[1]];
        }
    }
    else
    {
        
        if ([self.rightBarItems containsObject:_scrollUpBarBt])
        {
            [self.scrollUpBt fadeOutObject:self.scrollUpBt duration:.2 option:UIViewAnimationOptionCurveEaseOut];
            [self.rightBarItems removeObject:_scrollUpBarBt];
            self.navigationItem.rightBarButtonItems = self.rightBarItems;
        }
        
    }
    
}



//Search action
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController

{
    self.searchText = searchController.searchBar.text;
    
    if(self.searchText.length == 0)
    {
        self.isFilltered = NO;
       // _count = 0;
        //_presentCount = 0;
        //[self.tableView reloadData];
        
        [self updateTableData];

    }
    else
    {
        self.isFilltered = YES;
        
        _count = 0;
        _presentCount = 0;
        [self.tableView reloadData];

        self.searchArr = [[NSMutableArray alloc]init];
        
        if([_displayRegion isEqualToString:@"Attractions"])
        {
            for (PlaceObject *searchObj in self.displayRegionArr)
            {
                
                NSRange stringRange = [searchObj.name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                
                if(stringRange.location!=NSNotFound)
                {
                    [self.searchArr addObject:searchObj];
                    
                    [self updateTableData];

                }
                
            }
            
        }
        else  if([_displayRegion isEqualToString:@"Tours & Activities"])
        {

            for (TourObject *searchObj in self.displayRegionArr)
            {
                
                NSRange stringRange = [searchObj.title  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];

                if(stringRange.location!=NSNotFound || [searchObj.category containsString:self.searchText])
                {
                    [self.searchArr addObject:searchObj];
                    
                    [self updateTableData];

                }
                
            }
            
            return;

        }
        else  if([_displayRegion isEqualToString:@"Nearby"])
        {
            
            for (NearByObject *searchObj in self.displayRegionArr)
            {
                
                NSRange stringRange = [searchObj.name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                
                if(stringRange.location!=NSNotFound || [searchObj.cat_name containsString:self.searchText])
                {
                    [self.searchArr addObject:searchObj];
                    
                    [self updateTableData];
                    
        
                }
                
            }
            
            return;
            
        }

        
    }
    

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return _presentCount;
    
}

//Attraction place Deleggate Method
-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    
    if([_displayRegion isEqualToString:@"Attractions"])
    {
        if(!self.isFilltered)
        {
            if(index < [self.displayRegionArr count])
            {
                ((PlaceObject *)[self.displayRegionArr objectAtIndex:index]).img = imageDATA;
            }
        }
        else
        {
            if(index < [self.searchArr count])
            {
                ((PlaceObject *)[self.searchArr objectAtIndex:index]).img = imageDATA;

            }

        }

    }
    else  if([_displayRegion isEqualToString:@"Tours & Activities"])
    {
        
        if(!self.isFilltered)
        {
            
            if(index < [self.displayRegionArr count])
            {
                ((TourObject *)[self.displayRegionArr objectAtIndex:index]).thumbnailData = imageDATA;
            }
        }
        else
        {
            if(index < [self.searchArr count])
            {
                ((TourObject *)[self.searchArr objectAtIndex:index]).thumbnailData = imageDATA;

            }

        }
    }
    
    else if([_displayRegion isEqualToString:@"Lodging"])
    {
        if(index < [self.displayRegionArr count])
        {
            ((HotelObject *)[self.displayRegionArr objectAtIndex:index]).thumbnailData = imageDATA;
        }
        

    }
    
    [self updateTableData];

}

//Attractions Delegate
-(void)tour_DestDownloaded:(id)placeObj
{
    [self.displayRegionArr addObject:placeObj];
    [self.finalDataArr addObject:placeObj];
    

    //Tours_Dest interest Types
    self.PO = (PlaceObject *)placeObj;
    if (![self.scopes containsObject:self.PO.int_type]) {
        [self.scopes addObject:self.PO.int_type];
        
    }
    
    [self updateTableData];

    
}

//Tour delegate methods
-(void)tourItemsDownloaded:(id)tourOBJ :(int)tourCount
{
    if (self.displayRegionArr.count!=tourCount) {
        
        [self.displayRegionArr addObject:tourOBJ];
        [self.finalDataArr addObject:tourOBJ];
        self.itemsTotal = tourCount;
        
        //Tours Category Types
        self.TO = (TourObject *)tourOBJ;
        if (![self.scopes containsObject:self.TO.category]) {
            [self.scopes addObject:self.TO.category];
            
        }
        
        [self updateTableData];

    }
    
}



//Hotel Delegate methods
-(void)hotelItemsDownloaded:(id)hotelOBJ :(int)hotelCount
{
    if (self.displayRegionArr.count!=hotelCount) {
       
        [self.displayRegionArr addObject:hotelOBJ];
        self.itemsTotal = hotelCount;
        
        [self updateTableData];

    }
  
}

//Dinning Delegate methods
-(void)DinnigsDownloaded:(id)nearByOBJ :(int)nearByCount
{
    if (self.displayRegionArr.count!=nearByCount)
    {
        [self.displayRegionArr addObject:nearByOBJ];
        self.itemsTotal = nearByCount;
       
        [self updateTableData];

    }
   
}

//Shopping Delegate methods
-(void)shoppingDownloaded:(id)nearByOBJ :(int)nearByCount
{
    if (self.displayRegionArr.count!=nearByCount) {
        
        [self.displayRegionArr addObject:nearByOBJ];
        self.itemsTotal = nearByCount;

        [self updateTableData];

    }

}

//Nearby delegate methods
-(void)nearByDownloaded:(id)nearByOBJ :(int)nearByCount
{
    if (self.displayRegionArr.count!=nearByCount) {
        
        [self.displayRegionArr addObject:nearByOBJ];
        [self.finalDataArr addObject:nearByOBJ];
        self.itemsTotal = nearByCount;
        
        //Tours Category Types
        self.NBO = (NearByObject *)nearByOBJ;
        if (![self.scopes containsObject:self.NBO.cat_name]) {
            [self.scopes addObject:self.NBO.cat_name];
            
        }
        
        
        
        [self updateTableData];
        
    }
    else
    {
        NSArray *sortedLocations;
        
        sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(NearByObject *N1, NearByObject *N2) {
            return [[NSNumber numberWithDouble:N1.distance] compare:[NSNumber numberWithDouble:N2.distance]];
        }];
        
        self.displayRegionArr = [NSMutableArray arrayWithArray:sortedLocations];
        [self.tableView reloadData];
    }
    
}

-(void)nearByWithIdDownloaded:(id)nearByOBJ
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       
                       self.NBO = (NearByObject *)nearByOBJ;
                       [self.svwWebView loadWebPage:self.NBO.canonicalURL];
                       
                   });
    
}



//Set up cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    
    if(!self.isFilltered)
    {

        
        if([_displayRegion isEqualToString:@"Attractions"])
        {
            
            self.itemsCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

            self.PO= (PlaceObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
            //Download images
            if(!self.PO.img)
            {
                
                self.PO.delegate = self;
                [self.PO downloadImages:self.PO.thumbnailUrl :0 :self.PO.name :indexPath.row];
                
            }
            
            //set up spinner for image to indicate loading
            [self.itemsCell.spinner startAnimating];
            

            //Custumise cell image view

            if (self.PO.img!=NULL) {
                [self.itemsCell.itemImage setImage:[UIImage imageWithData:self.PO.img]];
                if(self.itemsCell.itemImage.image==NULL)
                {
                    self.itemsCell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
                    [self.itemsCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
                }

                
            }
            
            //customize cell name label
            self.itemsCell.nameLB.text =self.PO.name;
            
            //customize cell state label
            self.itemsCell.stateLB.text =self.PO.state;
            
            //Favourite set
            favouriteName = self.PO.name;
            favouriteType = self.displayRegion;
            favouriteImgNo = @"0";
            favouriteDetails = self.PO.name;
            favouriteImgUrl = self.PO.thumbnailUrl;
            
            self.itemsCell.favButton.tag = indexPath.row;
            [self.itemsCell.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            if([self checkIfFavrouite:indexPath.row])
            {
                
                [self.itemsCell.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
                
            }
            
            else
            {
                
                [self.itemsCell.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                
            }
            
            return self.itemsCell;

        }
        
        else if([_displayRegion isEqualToString:@"Dining"])
        {
            self.placeCell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];

            self.DO= (DinningObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
           
            //customize cell name label
            self.placeCell.nameLb.text =self.DO.name;
            
            //customize cell state label
            self.placeCell.address.text =self.DO.address;
            
            [self.placeCell.provider setImage:self.DO.provider_icon];

            self.placeCell.distanceLB.text = self.DO.place_distance;
            
            self.placeCell.direction.tag = indexPath.row;
            [self.placeCell.direction addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
            
            self.placeCell.taxiBT.tag = indexPath.row;
            [self.placeCell.taxiBT addTarget:self action:@selector(callToTaxiApp:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.placeCell setAccessoryType:UITableViewCellAccessoryDetailButton];

            return self.placeCell;

        }
        else if([_displayRegion isEqualToString:@"Shopping"])
        {
            self.placeCell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];
            
            self.SHOP= (ShoppingObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
            //customize cell name label
            self.placeCell.nameLb.text =self.SHOP.name;
            
            //customize cell state label
            self.placeCell.address.text =self.SHOP.address;
            
            [self.placeCell.provider setImage:self.SHOP.provider_icon];
            
            self.placeCell.distanceLB.text = self.SHOP.place_distance;
            
            self.placeCell.direction.tag = indexPath.row;
            [self.placeCell.direction addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
            
            self.placeCell.taxiBT.tag = indexPath.row;
            [self.placeCell.taxiBT addTarget:self action:@selector(callToTaxiApp:) forControlEvents:UIControlEventTouchUpInside];
            
            return self.placeCell;
            
        }
        else if([_displayRegion isEqualToString:@"Nearby"])
        {
            self.nearbyCell = [tableView dequeueReusableCellWithIdentifier:@"NBItemCell" forIndexPath:indexPath];
            
            self.NBO= (NearByObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
            if (self.displayRegionArr.count>0)
            {
                
                [self.nearbyCell.itemImage setImage:[UIImage imageWithData:self.NBO.thumbnailData]];
                if (self.NBO.thumbnailData == NULL) {
                    
                    [self.nearbyCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
                    
                }
                
                self.nearbyCell.itemImage.backgroundColor = [UIColor clearColor];
                self.nearbyCell.itemImage.tintColor = [UIColor greenColor];
                [self.nearbyCell.itemImage.layer setCornerRadius:8.0f];
                [self.nearbyCell.itemImage.layer setMasksToBounds:YES];
                self.nearbyCell.nameLB.text =self.NBO.name;
                self.nearbyCell.catLB.text =self.NBO.cat_name;
                self.nearbyCell.distanceLB.text = self.NBO.place_distance;
                
                [self.nearbyCell.locationBT setTag:indexPath.row];
                [self.nearbyCell.locationBT addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.nearbyCell.taxiBT setTag:indexPath.row];
                [self.nearbyCell.taxiBT addTarget:self action:@selector(callToTaxiApp:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            
            
            return self.nearbyCell;
        }
        
        else if([_displayRegion isEqualToString:@"Lodging"])
        {
            self.hotelCell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
            
            self.HO= (HotelObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
            //Download images
            if(!self.HO.thumbnailData)
            {
                self.PO = [[PlaceObject alloc]init];
                self.PO.delegate = self;
                [self.PO downloadImages:self.HO.thumbnailURL :1 :self.HO.name :indexPath.row];
                
            }
            
            self.hotelCell.nameLB.text = self.HO.name;
            self.hotelCell.cityLB.text = self.HO.city;
            
            self.hotelCell.hotelthumbnail.backgroundColor = [UIColor clearColor];
           
            //Customize Image view
            if (self.HO.thumbnailData !=NULL) {
                
                self.hotelCell.hotelthumbnail.contentMode = UIViewContentModeScaleToFill;
                [self.hotelCell.hotelthumbnail setImage:[UIImage imageWithData:self.HO.thumbnailData]];
                if(self.hotelCell.hotelthumbnail.image==NULL)
                {
                    self.hotelCell.hotelthumbnail.contentMode = UIViewContentModeScaleAspectFit;
                    [self.hotelCell.hotelthumbnail setImage:[UIImage imageNamed:@"image_file.png"]];
                    
                }
                
            }
           
            self.hotelCell.currencyCode.text = self.HO.rateCurrencyCode;
            self.hotelCell.price.text = [NSString stringWithFormat:@"%.2f",self.HO.lowRate];
            
            
            double rating = [self.HO.starRating doubleValue];
            
            if (rating == 1) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"1star.png"]];
                
            }
            if (rating >= 1.5) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"1.5star.png"]];
                
            }
            if (rating >= 2) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"2star.png"]];
                
            }
            if (rating >= 2.5) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"2.5star.png"]];
                
            }
            if (rating >= 3) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"3star.png"]];
                
            }
            if (rating >= 3.5) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"3.5star.png"]];
                
            }
            if(rating >= 4) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"4star.png"]];
                
            }
            if(rating >= 5) {
                
                [self.hotelCell.ratingIMG setImage:[UIImage imageNamed:@"5star.png"]];
                
            }
            
            self.hotelCell.bookBT.tag = indexPath.row;
            [self.hotelCell.bookBT addTarget:self action:@selector(openWebView:) forControlEvents:UIControlEventTouchUpInside];
           
            self.hotelCell.locationBT.tag = indexPath.row;
            [self.hotelCell.locationBT addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
            
            self.hotelCell.taxiBT.tag = indexPath.row;
            [self.hotelCell.taxiBT addTarget:self action:@selector(callToTaxiApp:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.hotelCell.mapImg setImage:[UIImage imageNamed:@"center_direction.png"]];
            [self.hotelCell.mapBt setTitle:@"Direction" forState:UIControlStateNormal];
            
            self.hotelCell.distanceLB.text = self.HO.place_distance;
            
            return self.hotelCell;
            
        }
        else if([_displayRegion isEqualToString:@"Tours & Activities"])
        {
            self.tourCell = [tableView dequeueReusableCellWithIdentifier:@"tourCell" forIndexPath:indexPath];
            self.TO= (TourObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
            //Download Images
            if(!self.TO.thumbnailData)
            {
                self.PO = [[PlaceObject alloc]init];
                self.PO.delegate = self;
                [self.PO downloadImages:self.TO.thumbnailURL :0 :self.TO.title :indexPath.row];
                
            }

            self.tourCell.nameLB.text = self.TO.title;
            self.tourCell.durationLB.text = self.TO.duration;
            self.tourCell.currencyLB.text = self.TO.currencyCode;
            self.tourCell.priceLB.text = [NSString stringWithFormat:@"%.2f",self.TO.priceRange];
            
            //Image set
            if (self.TO.thumbnailData!=NULL) {
                self.tourCell.activityIMG.image = [UIImage imageWithData:self.TO.thumbnailData];
                if(self.tourCell.activityIMG.image==NULL)
                {
                    self.tourCell.activityIMG.contentMode = UIViewContentModeScaleAspectFit;
                    [self.tourCell.activityIMG setImage:[UIImage imageNamed:@"image_file.png"]];
                    
                }
            }
            
            //favorite set
            favouriteName = self.TO.title;
            favouriteType = self.displayRegion;
            favouriteImgNo = @"1";
            favouriteDetails = self.TO.activityID;
            favouriteImgUrl = self.TO.thumbnailURL;
            
            self.tourCell.favButton.tag = indexPath.row;
            [self.tourCell.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            if([self checkIfFavrouite:indexPath.row])
            {
                
                [self.tourCell.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
                
            }
            
            else
            {
                
                [self.tourCell.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                
            }
            
            return self.tourCell;
        }
        
    }
    
    else

    {

        if([_displayRegion isEqualToString:@"Attractions"])
        {

            self.itemsCell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

            self.PO= (PlaceObject *)[self.searchArr objectAtIndex:indexPath.row];
            
            //Download images
            if(!self.PO.img)
            {
                
                
                self.PO.delegate = self;
                [self.PO downloadImages:self.PO.thumbnailUrl :0 :self.PO.name :indexPath.row];
                
            }
            
            //set up spinner for image to indicate loading
            [self.itemsCell.spinner startAnimating];
            
            //Custumise cell image view

            if (self.PO.img!=NULL) {
                [self.itemsCell.itemImage setImage:[UIImage imageWithData:self.PO.img]];
                if(self.itemsCell.itemImage.image==NULL)
                {
                    self.itemsCell.itemImage.contentMode = UIViewContentModeScaleAspectFit;
                    [self.itemsCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
                }
                
            }
            
            
            //customize cell name label
            self.itemsCell.nameLB.text =self.PO.name;
            
            //customize cell state label
            self.itemsCell.stateLB.text =self.PO.state;
            
            self.itemsCell.favButton.tag = indexPath.row;
            [self.itemsCell.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
            
            if([self checkIfFavrouite:indexPath.row])
            {
                
                [self.itemsCell.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
                
            }
            
            else
            {
                
                [self.itemsCell.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                
            }


            return self.itemsCell;
            
        }
        
        else if([_displayRegion isEqualToString:@"Tours & Activities"])
        {
            self.tourCell = [tableView dequeueReusableCellWithIdentifier:@"tourCell" forIndexPath:indexPath];
            self.TO= (TourObject *)[self.searchArr objectAtIndex:indexPath.row];
            
            //Download Images
            if(!self.TO.thumbnailData)
            {
                self.PO = [[PlaceObject alloc]init];
                self.PO.delegate = self;
                [self.PO downloadImages:self.TO.thumbnailURL :0 :self.TO.title :indexPath.row];
                
            }
            
            self.tourCell.nameLB.text = self.TO.title;
            self.tourCell.durationLB.text = self.TO.duration;
            self.tourCell.currencyLB.text = self.TO.currencyCode;
            self.tourCell.priceLB.text = [NSString stringWithFormat:@"%.2f",self.TO.priceRange];
            
            //Image set
            if (self.TO.thumbnailData!=NULL) {
                self.tourCell.activityIMG.image = [UIImage imageWithData:self.TO.thumbnailData];
                if(self.tourCell.activityIMG.image==NULL)
                {
                    self.tourCell.activityIMG.contentMode = UIViewContentModeScaleAspectFit;
                    [self.tourCell.activityIMG setImage:[UIImage imageNamed:@"image_file.png"]];
                    
                }
            }
            
            
            //favorite set
            favouriteName = self.TO.title;
            favouriteType = self.displayRegion;
            favouriteImgNo = @"1";
            favouriteDetails = self.TO.activityID;
            favouriteImgUrl = self.TO.thumbnailURL;
            
            self.tourCell.favButton.tag = indexPath.row;
            [self.tourCell.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
                        
            if([self checkIfFavrouite:indexPath.row])
            {
                [self.tourCell.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
                
            }
            
            else
            {
                
                [self.tourCell.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
                
            }
            
            return self.tourCell;
        }
        else if([_displayRegion isEqualToString:@"Nearby"])
        {
            self.nearbyCell = [tableView dequeueReusableCellWithIdentifier:@"NBItemCell" forIndexPath:indexPath];
            
            self.NBO= (NearByObject *)[self.searchArr objectAtIndex:indexPath.row];
            
            if (self.searchArr.count>0)
            {
                
                [self.nearbyCell.itemImage setImage:[UIImage imageWithData:self.NBO.thumbnailData]];
                if (self.NBO.thumbnailData == NULL) {
                    
                    [self.nearbyCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
                    
                }
                
                self.nearbyCell.itemImage.backgroundColor = [UIColor clearColor];
                self.nearbyCell.itemImage.tintColor = [UIColor greenColor];
                [self.nearbyCell.itemImage.layer setCornerRadius:8.0f];
                [self.nearbyCell.itemImage.layer setMasksToBounds:YES];
                self.nearbyCell.nameLB.text =self.NBO.name;
                self.nearbyCell.catLB.text =self.NBO.cat_name;
                self.nearbyCell.distanceLB.text = self.NBO.place_distance;
                
                [self.nearbyCell.locationBT setTag:indexPath.row];
                [self.nearbyCell.locationBT addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.nearbyCell.taxiBT setTag:indexPath.row];
                [self.nearbyCell.taxiBT addTarget:self action:@selector(callToTaxiApp:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            
            
            return self.nearbyCell;
        }
        

        
    }
    
  
    
    return self.placeCell;
}

//get Directions from user location
-(void)getDirections:(UIButton *)sender
{
    PlaceObject *PO = [[PlaceObject alloc]init];
   
    if([_displayRegion isEqualToString:@"Lodging"])
    {
        self.HO= (HotelObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.HO.latitude, self.HO.longitude);

        [PO getDirectionsFromCoordinate:self.coordinate TO_Coordinate:destCoordinate];
   
    }
    else if([_displayRegion isEqualToString:@"Dining"])
    {
        self.DO= (DinningObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.DO.latitude, self.DO.longitude);
        
        [PO getDirectionsFromCoordinate:self.coordinate TO_Coordinate:destCoordinate];
        
 
    }
    else if([_displayRegion isEqualToString:@"Shopping"])
    {
        self.SHOP= (ShoppingObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.SHOP.latitude, self.SHOP.longitude);
        
        [PO getDirectionsFromCoordinate:self.coordinate TO_Coordinate:destCoordinate];
        
    }
    else if([_displayRegion isEqualToString:@"Nearby"])
    {
        self.NBO= (NearByObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.NBO.place_latitude, self.NBO.place_longitude);
        
        [PO getDirectionsFromCoordinate:self.coordinate TO_Coordinate:destCoordinate];
        
    }

    

    
}

//call  taxi booking app
-(void)callToTaxiApp:(UIButton *)sender
{
    
    PlaceObject *PO = [[PlaceObject alloc]init];
    
    if([_displayRegion isEqualToString:@"Lodging"])
    {
        self.HO= (HotelObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.HO.latitude, self.HO.longitude);
        
        [PO setPickUpCoordinate:self.coordinate DropOffCoordinate:destCoordinate];
        
    }
    else if([_displayRegion isEqualToString:@"Dining"])
    {
        self.DO= (DinningObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.DO.latitude, self.DO.longitude);
        
        [PO setPickUpCoordinate:self.coordinate DropOffCoordinate:destCoordinate];
        
        
    }
    else if([_displayRegion isEqualToString:@"Shopping"])
    {
        self.SHOP= (ShoppingObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.SHOP.latitude, self.SHOP.longitude);
        
        [PO setPickUpCoordinate:self.coordinate DropOffCoordinate:destCoordinate];
        
    }
    else if([_displayRegion isEqualToString:@"Nearby"])
    {
        self.NBO= (NearByObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        CLLocationCoordinate2D destCoordinate = CLLocationCoordinate2DMake(self.NBO.place_latitude, self.NBO.place_longitude);
        
        [PO setPickUpCoordinate:self.coordinate DropOffCoordinate:destCoordinate];
        
    }

    
}

//add to Favourite
-(void)addItemToFavorites:(UIButton *)sender
{
    
    if([_displayRegion isEqualToString:@"Attractions"])
    {
        ItemsTableViewCell *IC = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        PlaceObject *PO= (PlaceObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        if (self.isFilltered) {
            PO= (PlaceObject *)[self.searchArr objectAtIndex:sender.tag];
        }
        
        //Favourite set
        favouriteName = PO.name;
        favouriteType = self.displayRegion;
        favouriteImgNo = @"0";
        favouriteDetails = PO.name;
        favouriteImgUrl = PO.thumbnailUrl;
        sender = IC.favButton;
        NSLog(@" selected rows BT name = %@ ",IC.nameLB.text);

    }
    else if([_displayRegion isEqualToString:@"Tours & Activities"])
    {
        TourTableViewCell *TC = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        TourObject *TO= (TourObject *)[self.displayRegionArr objectAtIndex:sender.tag];
        
        if (self.isFilltered) {
            TO= (TourObject *)[self.searchArr objectAtIndex:sender.tag];
        }
        
        favouriteName = TO.title;
        favouriteType = self.displayRegion;
        favouriteImgNo = @"0";
        favouriteDetails = TO.activityID;
        favouriteImgUrl = TO.thumbnailURL;
        
        sender = TC.favButton;
        NSLog(@" selected rows BT name = %@ ",TC.nameLB.text);

    }
    
    if ([self checkIfFavrouite:sender.tag])
    {
        
        NSLog(@" item %lu already a favourite ",(long)sender.tag);
        
        NSMutableArray* tmpArray = [self.theFav copy];
        
        for (NSDictionary *favItem in tmpArray) {
            
            if ([favouriteDetails isEqualToString:favItem[@"Details"]] && [favouriteType isEqualToString:favItem[@"Type"]])
            {
                [self.theFav removeObject:favItem];
               
            }
            
        }
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        
        [sender popObject:.1 option:UIViewAnimationOptionCurveEaseOut];
        [sender setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        NSMutableDictionary *details = [NSMutableDictionary
                                        dictionaryWithDictionary:@{@"Name":favouriteName,
                                                                   @"Type":favouriteType,
                                                                   @"ImgUrl":favouriteImgUrl,
                                                                   @"ImgNO":favouriteImgNo,
                                                                   @"Details":favouriteDetails,
                                                                   @"CountryCode":app.userCountry[@"CountryCode"]
                                                                   }];
        
        [self.theFav addObject:details];
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        [sender popObject:.1 option:UIViewAnimationOptionCurveEaseIn];
        [sender setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];

        //Save Image to folder
        PlaceObject *PO = [[PlaceObject alloc]init];
        
        [PO downloadImages:favouriteImgUrl :[favouriteImgNo intValue]:favouriteName :0];
        
        
        
        
    }
    
    
    
}


-(BOOL)checkIfFavrouite:(NSInteger)callerIndex
{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _destinationPath = appDelegate.favoritePath;
    
    self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
    
    if(_destinationPath==NULL)
    {
        
        _destinationPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"favourites"] ofType:@"plist"];
        
        self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
        
    }
    
    NSMutableArray* tmpArray = [self.theFav copy];
    
    for (NSDictionary *favItem in tmpArray) {
        
        if ([favouriteDetails isEqualToString:favItem[@"Details"]] && [favouriteType isEqualToString:favItem[@"Type"]])
        {
            
            return true;
            
        }
        
    }
    
    
    return false;
    
}


-(void)openWebView: (UIButton *)sender
{
    
    NSUInteger row = sender.tag;
    
    self.HO = (HotelObject *)[self.displayRegionArr objectAtIndex:row];
    
    self.svwWebView = [[SVWebViewController alloc]init];
    
    self.svwWebView.favoriteFilter = self.HO.name;
    self.svwWebView.favoriteType = @"Lodging";
    self.svwWebView.favoriteImgURL = self.HO.thumbnailURL;
    self.svwWebView.favoriteImgNO = @"0";
    self.svwWebView.title = self.HO.name;
    [self.svwWebView loadWebPage:self.HO.detailURL];
    
    self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self.navigationController pushViewController:self.svwWebView animated:YES];
    
    
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Extra Info !" message:@"sorry, no available website for selected place." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    
    if([_displayRegion isEqualToString:@"Dining"])
    {
        [self.tableView setUserInteractionEnabled:NO];

        self.DO = (DinningObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
        
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = self.DO.name;
        self.svwWebView.favoriteType = self.displayRegion;
        self.svwWebView.favoriteImgURL = nil;
        self.svwWebView.favoriteImgNO = @"1";
        self.svwWebView.title = self.DO.name;
       
        if ([self.DO.api_Type isEqualToString:@"G"]) {
            
            GMSPlacesClient *placesClient = [GMSPlacesClient new];
            [placesClient lookUpPlaceID:self.DO.place_id callback:^(GMSPlace *place, NSError *error) {
                if (error != nil) {
                    NSLog(@"Place Details error %@", [error localizedDescription]);
                    return;
                }
                
                if (place != nil) {
                    
                    if ([[UIApplication sharedApplication] canOpenURL:place.website])
                    {
                        [self.svwWebView loadWebPage:place.website.absoluteString];
                        
                        [self.navigationController pushViewController:self.svwWebView animated:YES];
                        
                    }
                    else
                    {
                        [self.navigationController presentViewController:alert animated:YES completion:nil];

                    }
                }
                else
                {
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
        else if ([self.DO.api_Type isEqualToString:@"Z"]) {
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.DO.canonicalURL]])
            {
                
                [self.svwWebView loadWebPage:self.DO.canonicalURL];
                
                [self.navigationController pushViewController:self.svwWebView animated:YES];
                
            }
            else
            {
                [self.navigationController presentViewController:alert animated:YES completion:nil];
                
            }
            
        }
        else if ([self.DO.api_Type isEqualToString:@"FS"]) {
            
            self.NBO = [NearByObject new];
            [self.NBO downloadItemsWithId:self.DO.place_id];
            self.NBO.delegate = self;
            
            [self.navigationController pushViewController:self.svwWebView animated:YES];
            
        }
        
        
        /*DistanceMatrixObject *distance = [[DistanceMatrixObject alloc]init];
         [distance getDistance:self.coordinate.latitude OrignLongitude:self.coordinate.longitude DistinationLatitude:self.DO.latitude DistinationLongitude:self.DO.longitude Modes:[NSArray arrayWithObjects:@"walking",nil]];*/
        
        
        [self.tableView setUserInteractionEnabled:YES];

    }
    
    else if([_displayRegion isEqualToString:@"Shopping"])
    {
        [self.tableView setUserInteractionEnabled:NO];
        
        self.SHOP = (ShoppingObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
        
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = self.SHOP.name;
        self.svwWebView.favoriteType = self.displayRegion;
        self.svwWebView.favoriteImgURL = nil;
        self.svwWebView.favoriteImgNO = @"1";
        self.svwWebView.title = self.SHOP.name;
        
        if ([self.SHOP.api_Type isEqualToString:@"G"]) {
            
            GMSPlacesClient *placesClient = [GMSPlacesClient new];
            [placesClient lookUpPlaceID:self.SHOP.place_id callback:^(GMSPlace *place, NSError *error) {
                if (error != nil) {
                    NSLog(@"Place Details error %@", [error localizedDescription]);
                    return;
                }
                
                if (place != nil) {
                    
                    if ([[UIApplication sharedApplication] canOpenURL:place.website])
                    {
                        [self.svwWebView loadWebPage:place.website.absoluteString];
                        
                        [self.navigationController pushViewController:self.svwWebView animated:YES];
                        
                    }
                    else
                    {
                        [self.navigationController presentViewController:alert animated:YES completion:nil];
                        
                    }
                }
                else
                {
                    [self.navigationController presentViewController:alert animated:YES completion:nil];
                }
            }];
        }
        else if ([self.SHOP.api_Type isEqualToString:@"FS"]) {
            
            self.NBO = [NearByObject new];
            [self.NBO downloadItemsWithId:self.SHOP.place_id];
            self.NBO.delegate = self;
            
            [self.navigationController pushViewController:self.svwWebView animated:YES];
            
        }
        
        
        [self.tableView setUserInteractionEnabled:YES];
        
    }


}

//Selecting a cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   
    
    if([_displayRegion isEqualToString:@"Attractions"])
    {
        [self.tableView setUserInteractionEnabled:NO];

        self.itemsCell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.itemsCell.loadCell setHidden:NO];
        [self.itemsCell.loadCell startAnimating];
        
        self.tabBarController  = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsTab"];
        
        
        if(self.isFilltered)
        {
            self.PO = (PlaceObject *)[self.searchArr objectAtIndex:indexPath.row];
            
        }
        else
        {
            self.PO = (PlaceObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
        }
        self.tabBarController.overviewViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarController.mapViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        self.tabBarController.hotelViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        self.tabBarController.nearbyTableViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        
        //Set values for sub views
        self.tabBarController.isFavourites = YES;
        self.tabBarController.favoriteFilter = self.PO.name;
        self.tabBarController.favoriteType = _displayRegion;
        self.tabBarController.favoriteImgURL = self.PO.thumbnailUrl;
        self.tabBarController.favoriteImgNO = @"0";
        self.tabBarController.favoriteDetails = self.PO.name;
        self.tabBarController.navigationItem.title=self.PO.name;
        
        self.tabBarController.overviewViewController.count = 0;
        self.tabBarController.overviewViewController.presentCount = 0;
        self.tabBarController.overviewViewController.tourItems = [[NSMutableArray alloc]init];
        
        self.tabBarController.hotelViewController.hotelCount = 0;
        self.tabBarController.hotelViewController.presentCount = 0;
        self.tabBarController.hotelViewController.hotelsItems = [[NSMutableArray alloc]init];

        self.tabBarController.mapViewController.pointsItems = [[NSMutableArray alloc]init];
        self.tabBarController.mapViewController.hotelItems = [[NSMutableArray alloc]init];
        self.tabBarController.mapViewController.markers = [[NSMutableDictionary alloc]init];
        self.tabBarController.mapViewController.addedMarkers = [[NSMutableArray alloc]init];
        self.tabBarController.mapViewController.imgData = self.PO.img;

        self.tabBarController.nearbyTableViewController.nearByItems = [[NSMutableArray alloc]init];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self.tabBarController;
        
        //Get Tour dest Data
        [conn GetTour_DestWithName:self.PO.name CountryCode:appDelegate.userCountry[@"CountryCode"] Caller:self.tabBarController CallBack:^(id callingObject)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                self.itemsCell = [tableView cellForRowAtIndexPath:indexPath];
                                [self.itemsCell.loadCell stopAnimating];
                                [self.itemsCell.loadCell setHidden:YES];
                                
                                myTabBarController *tab = (myTabBarController *)callingObject;
                                
                                [self.navigationController pushViewController:tab animated:YES];
                                
                                [self.tableView setUserInteractionEnabled:YES];

                            });
             
         }];
 
        
    }
    else if([_displayRegion isEqualToString:@"Tours & Activities"])
    {
        [self.tableView setUserInteractionEnabled:NO];

        TourViewController *tours = [self.storyboard instantiateViewControllerWithIdentifier:@"tourView"];
        
        if(self.isFilltered)
        {
            self.TO = (TourObject *)[self.searchArr objectAtIndex:indexPath.row];
            
        }
        else
        {
            self.TO = (TourObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
        }
        
        tours.title = self.TO.title;
        tours.imageDownloadCount = 0;
        tours.favoriteType = _displayRegion;
        tours.favoriteImgURL = self.TO.thumbnailURL;
        tours.favoriteName =  self.TO.title;
        tours.favoriteImgNO = @"0";
        tours.favoriteDetails = self.TO.activityID;
        
        tours.imagesData = [[NSMutableArray alloc]init];
        tours.availabilities = [[NSMutableArray alloc]init];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = tours;
        [conn GetTourWithID:self.TO.activityID CountryCode:appDelegate.userCountry[@"CountryCode"]];
        
        [conn GetTourAvailabilities:self.TO.activityID CountryCode:appDelegate.userCountry[@"CountryCode"]];
        
        [self.navigationController pushViewController:tours animated:YES];
        
        [self.tableView setUserInteractionEnabled:YES];

        
    }
    
   
    else if([_displayRegion isEqualToString:@"Nearby"])
    {
        [self.tableView setUserInteractionEnabled:NO];

        if(self.isFilltered)
        {
            self.NBO = (NearByObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
        }
        else
        {
            self.NBO = (NearByObject *)[self.displayRegionArr objectAtIndex:indexPath.row];
            
        }
        
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = self.NBO.name;
        self.svwWebView.favoriteType = self.NBO.cat_name;
        self.svwWebView.favoriteImgURL = self.NBO.icon_url;
        self.svwWebView.favoriteImgNO = @"1";
        self.svwWebView.title = self.NBO.name;
        
        [self.NBO downloadItemsWithId:self.NBO.place_id];
        self.NBO.delegate = self;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];
        
        [self.tableView setUserInteractionEnabled:YES];

    }
   
}



// Action whent cell is not highlighted
-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}



//select filtter action
- (IBAction)fillterAction:(id)sender {
    
   
    if([self.displayRegion isEqualToString:@"Attractions"] || [self.displayRegion isEqualToString:@"Tours & Activities"] || [self.displayRegion isEqualToString:@"Nearby"])
    {
        if (self.scopes.count > 0) {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Select your Interest:"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            for (int i = 0; i < self.scopes.count; i++) {
                
                UIAlertAction* interest = [UIAlertAction
                                           actionWithTitle:[self.scopes objectAtIndex:i]
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [self setFilteredInterest:i];
                                               
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                [alert addAction:interest];
                
                
            }
            UIAlertAction* close = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:close];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    else
    {
        if (self.scopes.count > 0) {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Sort by :"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
            
            
            
            for (int i = 0; i < self.scopes.count; i++) {
                
                UIAlertAction* interest = [UIAlertAction
                                           actionWithTitle:[self.scopes objectAtIndex:i]
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               if ([[self.scopes objectAtIndex:i] isEqualToString:@"Distance"]) {
                                                   
                                                   NSArray *sortedLocations;
                                                   
                                                   if ([self.displayRegion isEqualToString:@"Lodging"])
                                                   {
                                                       sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                           return [[NSNumber numberWithDouble:H1.distance] compare:[NSNumber numberWithDouble:H2.distance]];
                                                       }];
                                                       
                                                       
                                                   }
                                                   else if ([self.displayRegion isEqualToString:@"Dining"])
                                                   {
                                                       sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(DinningObject *D1, HotelObject *D2) {
                                                           return [[NSNumber numberWithDouble:D1.distance] compare:[NSNumber numberWithDouble:D2.distance]];
                                                       }];
                                                       
                                                       
                                                   }
                                                   else if ([self.displayRegion isEqualToString:@"Shopping"])
                                                   {
                                                       sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(ShoppingObject *S1, HotelObject *S2) {
                                                           return [[NSNumber numberWithDouble:S1.distance] compare:[NSNumber numberWithDouble:S2.distance]];
                                                       }];
                                                       
                                                       
                                                   }
                                                   
                                                   self.displayRegionArr = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                                   [self.tableView reloadData];

                                               }
                                               else if ([[self.scopes objectAtIndex:i] isEqualToString:@"Price"]) {
                                                   
                                                   NSArray *sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:H1.lowRate] compare:[NSNumber numberWithDouble:H2.lowRate]];
                                                   }];
                                                   
                                                   self.displayRegionArr = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                                   [self.tableView reloadData];
                                                   
                                               }
                                               else if ([[self.scopes objectAtIndex:i] isEqualToString:@"Star Ratings"]) {
                                                   
                                                   
                                                   NSArray *sortedLocations = [_displayRegionArr sortedArrayUsingComparator: ^(HotelObject *H1, HotelObject *H2) {
                                                       return [[NSNumber numberWithDouble:[H1.starRating doubleValue]] compare:[NSNumber numberWithDouble:[H2.starRating doubleValue]]];
                                                   }];
                                                   
                                                   self.displayRegionArr = [NSMutableArray arrayWithArray:sortedLocations];
                                                   
                                                   [self.tableView reloadData];
                                                   
                                               }

                                               
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                [alert addAction:interest];
                
                
            }
            
            UIAlertAction* close = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action)
                                    {
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
            [alert addAction:close];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        
    }
    

}

- (IBAction)scrollUpAction:(id)sender {
    
   // NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView scrollRectToVisible:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) animated:YES];
    
}


//Perform Fillter action
-(void)setFilteredInterest:(NSInteger)selectedScope{
        
    if([[self.scopes objectAtIndex:selectedScope]isEqualToString:@"All"])
    {
        
        
        _count = 0;
        _presentCount = 0;
        self.displayRegionArr = [[NSMutableArray alloc] init];
        [self.tableView reloadData];
        
        if ([_displayRegion isEqualToString:@"Attractions"])
        {
            for (PlaceObject *scopeObj in self.finalDataArr)
            {
                NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                
                [self.displayRegionArr addObject:scopeObj];
                scopeObj.delegate = self;
                
            }

        }
        else if([_displayRegion isEqualToString:@"Tours & Activities"])
        {
            for (TourObject *scopeObj in self.finalDataArr)
            {
                NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                
                [self.displayRegionArr addObject:scopeObj];
               
            }

            
        }
        else if([_displayRegion isEqualToString:@"Nearby"])
        {
            for (NearByObject *scopeObj in self.finalDataArr)
            {
                NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                
                [self.displayRegionArr addObject:scopeObj];
                
            }
            
            
        }
        
        
        if (self.isFilltered==YES)
        {
            _count = 0;
            _presentCount = 0;
            [self.tableView reloadData];

            self.searchArr = [[NSMutableArray alloc]init];
            
            if ([_displayRegion isEqualToString:@"Attractions"])
            {
                for (PlaceObject *searchObj in self.displayRegionArr)
                {
                    
                    NSRange stringRange = [searchObj.name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                        searchObj.delegate = self;
                        
                    }
                }
                
            }
            else if([_displayRegion isEqualToString:@"Tours & Activities"])
            {
                for (TourObject *searchObj in self.displayRegionArr)
                {
                    NSRange stringRange = [searchObj.title  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                       
                    }
                   
                   
                }
                
                
            }
            else if([_displayRegion isEqualToString:@"Nearby"])
            {
                for (NearByObject *searchObj in self.displayRegionArr)
                {
                    NSRange stringRange = [searchObj.name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
        [self updateTableData];
        
    }
    else
    {
        
        
        _count = 0;
        _presentCount = 0;
        [self.tableView reloadData];
        self.displayRegionArr = [[NSMutableArray alloc] init];
       
        if ([_displayRegion isEqualToString:@"Attractions"])
        {
            for (PlaceObject *scopeObj in self.finalDataArr)
            {
                
                if([scopeObj.int_type containsString:[self.scopes objectAtIndex:selectedScope]])
                {
                    NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                    [self.displayRegionArr addObject:scopeObj];
                    
                }
                
                
            }
            
        }
        else if([_displayRegion isEqualToString:@"Tours & Activities"])
        {
            for (TourObject *scopeObj in self.finalDataArr)
            {
                
                if([scopeObj.category containsString:[self.scopes objectAtIndex:selectedScope]])
                {
                    NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                    
                    [self.displayRegionArr addObject:scopeObj];
                   
                }
                
                
            }
            
            
        }
        else if([_displayRegion isEqualToString:@"Nearby"])
        {
            for (NearByObject *scopeObj in self.finalDataArr)
            {
                
                if([scopeObj.cat_name containsString:[self.scopes objectAtIndex:selectedScope]])
                {
                    NSLog(@"selected scope = %@",[self.scopes objectAtIndex:selectedScope]);
                    
                    [self.displayRegionArr addObject:scopeObj];
                    
                }
                
                
            }
            
            
        }
        

        if (self.isFilltered==YES)
        {
            
            _count = 0;
            _presentCount = 0;
            [self.tableView reloadData];

            self.searchArr = [[NSMutableArray alloc]init];
            
            if ([_displayRegion isEqualToString:@"Attractions"])
            {
                for (PlaceObject *searchObj in self.displayRegionArr)
                {
                    
                    NSRange stringRange = [searchObj.name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                        
                    }
                }
                
            }
            else if([_displayRegion isEqualToString:@"Tours & Activities"])
            {
                for (TourObject *searchObj in self.displayRegionArr)
                {
                    NSRange stringRange = [searchObj.title  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                        
                    }
                    
                    
                }
                
                
            }
            else if([_displayRegion isEqualToString:@"Nearby"])
            {
                for (NearByObject *searchObj in self.displayRegionArr)
                {
                    NSRange stringRange = [searchObj.cat_name  rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
                    
                    if(stringRange.location!=NSNotFound)
                    {
                        [self.searchArr addObject:searchObj];
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
        
        [self updateTableData];
        
    }
    
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
