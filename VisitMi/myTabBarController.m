//
//  myTabBarController.m
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "myTabBarController.h"

@interface myTabBarController ()

@end

@implementation myTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hotelViewController.delegate = self;
    self.nearbyTableViewController.delegate = self;
    self.hotelViewController.delegateForMap = self.mapViewController;
    self.nearbyTableViewController.delegateForMap = self.mapViewController;

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
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
  
    [super viewWillAppear:animated];
    
    //Button customiztaion
    self.favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favButton setFrame:CGRectMake(0, 0, 25, 25)];
    [self.favButton addTarget:self action:@selector(addItemToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Assign colour to favourite button based on favourite availability
    if([self checkIfFavrouite])
    {
        
        [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        
    }
    
    else
    {
        
        [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    
    self.favBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.favButton];

    self.navigationItem.rightBarButtonItem = self.favBarButton;
   
    self.rightBarItems = [[NSMutableArray alloc]initWithArray:self.navigationItem.rightBarButtonItems];

}


//add to Favourite
-(void)addItemToFavorites:(id)sender
{
    if ([self checkIfFavrouite])
    {
        
        NSLog(@" item already a favourite ");
        
        
        NSString *FavDeleted = [[NSString alloc]initWithFormat:@"%@ has been removed from favourite",self.favoriteFilter ];
        
        
        //Favourite alert
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Favorite Removed"
                                      message:FavDeleted
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        NSMutableArray* tmpArray = [self.theFav copy];

        for (NSDictionary *favItem in tmpArray) {
            
            if ([_favoriteFilter isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
            {
                [self.theFav removeObject:favItem];
            }
            
        }
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        NSString *FavAdded = [[NSString alloc]initWithFormat:@"%@ has been added to favourite",self.favoriteFilter ];
        
        
        //Favourite alert
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Favorite Added"
                                      message:FavAdded
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        
        //Savve item to favourite
        if (_favoriteImgURL==nil) {
            _favoriteImgURL=@"null";
        }
        
        NSMutableDictionary *details = [NSMutableDictionary
                                        dictionaryWithDictionary:@{@"Name":_favoriteFilter,
                                                                   @"Type":_favoriteType,
                                                                   @"ImgUrl":_favoriteImgURL,
                                                                   @"ImgNO":_favoriteImgNO,
                                                                   @"Details":_favoriteDetails,
                                                                   @"CountryCode":_appDelegate.userCountry[@"CountryCode"],

                                                                   }];
        
        [_theFav addObject:details];
        
        [self.theFav writeToFile:_destinationPath atomically:YES];
        
        
        //Save Image folder
        [self.PO downloadImages:_favoriteImgURL :[_favoriteImgNO intValue] :_favoriteFilter :0];
        
        [self.favButton popObject:.1 option:UIViewAnimationOptionCurveEaseInOut];
        [self.favButton setImage:[UIImage imageNamed:@"filled_like.png"] forState:UIControlStateNormal];
        


    }


    
}


-(BOOL)checkIfFavrouite
{
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _destinationPath = _appDelegate.favoritePath;
    
    self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
    
    if(_destinationPath==NULL)
    {
        
        _destinationPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"favourites"] ofType:@"plist"];
        
        self.theFav =[[NSMutableArray alloc] initWithContentsOfFile:_destinationPath];
        
    }
    
    NSMutableArray* tmpArray = [self.theFav copy];
    
    for (NSDictionary *favItem in tmpArray) {
        
        if ([_favoriteFilter isEqualToString:favItem[@"Name"]] && [_favoriteType isEqualToString:favItem[@"Type"]])
        {

            NSLog(@"item exist in favourite file");

            return true;

        }
               
    }
    
  
    NSLog(@"item does not exist in favourite file");


    return false;
    
}


//Tour Destinations Delegate
-(void)tour_DestWithNameDownloaded:(id)placeObj
{
    
    self.PO = (PlaceObject *)placeObj;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.overviewViewController.name = self.PO.name;
    self.overviewViewController.desc = self.PO.desc;
    self.overviewViewController.phoneNumber = self.PO.number;
    self.overviewViewController.address = self.PO.address;
    self.overviewViewController.imageURLARR =self.PO.imageArr;
    
    self.mapViewController.address =self.PO.address;
    self.mapViewController.number = self.PO.number;
    self.mapViewController.state = self.PO.state;
    
    self.mapViewController.name = self.PO.name;
    self.mapViewController.longitude = self.PO.longitude;
    self.mapViewController.latitude = self.PO.latitude;

    self.hotelViewController.longitude = self.PO.longitude;
    self.hotelViewController.latitude = self.PO.latitude;
    
    DBConnect *conn = [[DBConnect alloc]init];
    conn.delegate = self;
    
    //Get Tours
    [conn GetTourForLocation:appDelegate.userCountry[@"CountryCode"] Latitude:self.PO.latitude Longitude:self.PO.longitude MaxDistance:15];
    
    //Get Hotels
    [conn GetHotels:appDelegate.userCountry[@"CountryCode"]  Latitude:self.PO.latitude Longitude:self.PO.longitude MaxDistance:15];
    
    // Get Nearby data
    self.NBO = [[NearByObject alloc]init];
    self.NBO.delegate = self;
    [self.NBO downloadItems:self.PO.longitude latitude:self.PO.latitude];
    
        
}


//Hotel Delegate method
-(void)hotelItemsDownloaded:(id)hotelOBJ :(int)hotelCount
{
    [self.mapViewController.hotelItems addObject:hotelOBJ];
    [self.mapViewController loadAnnotations :hotelCount :@"hotels"];
    self.mapViewController.hotelsCount = hotelCount;

    [self.hotelViewController.hotelsItems addObject:hotelOBJ];
    self.hotelViewController.hotelTotal = hotelCount;

           
    self.hotelViewController.HO = (HotelObject *)hotelOBJ;
    self.PO = [[PlaceObject alloc]init];
    self.PO.delegate = self.hotelViewController;
    
    [self.PO downloadImages:self.hotelViewController.HO.thumbnailURL :1 :self.hotelViewController.HO.name :[self.hotelViewController.hotelsItems count]-1];
    
    [self.hotelViewController checkHotelCount];
    
}


// Tour Delegate
-(void)tourItemsDownloaded:(id)tourOBJ :(int)tourCount
{

    [self.overviewViewController.tourItems addObject:tourOBJ];
    self.overviewViewController.tourCount = tourCount;
    
    self.overviewViewController.TO = (TourObject *)tourOBJ;
    self.PO = [[PlaceObject alloc]init];
    self.PO.delegate = self;
    
    [self.PO downloadImages:self.overviewViewController.TO.thumbnailURL :1 :self.overviewViewController.TO.title :[self.overviewViewController.tourItems count]-1];
    
    [self.overviewViewController updateTableData];

    
}


//Tours Imaage Download Delegate
-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    [self.overviewViewController loadTourImages:imageDATA :index];
}


//NearBy delegate methods
-(void)nearByDownloaded:(id)nearByOBJ :(int)nearByCount
{
    [self.nearbyTableViewController.nearByItems addObject:nearByOBJ];
    self.nearbyTableViewController.NBOount = nearByCount;
    [self.nearbyTableViewController checkNBOdataCount];

    [self.mapViewController.pointsItems addObject:nearByOBJ];
    [self.mapViewController loadAnnotations :nearByCount :@"points"];
    
    self.mapViewController.pointsCount = nearByCount;

    
}

//Hotel showmapview delegate
-(void)showMapViewFromHotel
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self setSelectedViewController:self.mapViewController];

                   });
    

}

//Nearby showmapview delegate
-(void)showMapViewFromNearby
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self setSelectedViewController:self.mapViewController];
                       
                   });
    
    
}


//Hotel scroll Delegate
-(void)hoScrollViewAction:(UITableView *)tableView
{
    _selectedTableView = tableView;

    [self scrollViewAction:tableView];
}

// nearby scroll delegate
-(void)nbScrollViewAction:(UITableView *)tableView
{
    _selectedTableView = tableView;

    [self scrollViewAction:tableView];

}

- (void)scrollViewAction:(UITableView *)tableView
{
    
    if (tableView.contentOffset.y > 100) {
        
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



- (IBAction)scrollUpAction:(id)sender
{
    
    [self.selectedTableView scrollRectToVisible:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) animated:YES];
    
    NSLog(@"scrolled to tp");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
