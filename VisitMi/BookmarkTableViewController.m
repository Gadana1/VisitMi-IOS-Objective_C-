//
//  BookmarkTableViewController.m
//  VisitMi
//
//  Created by Samuel on 10/25/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "BookmarkTableViewController.h"

@interface BookmarkTableViewController ()

@end

@implementation BookmarkTableViewController

NSString *city;
NSString *administrativeArea;

@synthesize theFavorites;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    //setup cell
    self.tableView.estimatedRowHeight = 115.f;
    self.tableView.rowHeight = 115.f;
    [self.tableView registerNib:[UINib nibWithNibName:@"BookmarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"favCell"];
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    //Get favorite file into theFavourite array
    _fileManager = [NSFileManager defaultManager];
    NSError *errror;
    _destinationPath = _appDelegate.favoritePath;
    
    
    //copy Favourite file to destinatioinPath is it doesn't exist
    
    if ([_fileManager fileExistsAtPath:_destinationPath])
    {
        NSLog(@" File Exist in destination Path = %@", _destinationPath);
    }
    else
    {
        NSString *sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"favourites.plist"];
        
        NSLog(@" source Path = %@", sourcePath);
        
        [_fileManager copyItemAtPath:sourcePath toPath:_destinationPath error:&errror];
        
    }
    
    self.theFavorites = [[NSMutableArray alloc]init];
    NSArray *tempFav = [NSArray arrayWithContentsOfFile:_destinationPath];
    
    if (tempFav.count > 0) {
        
        for (NSDictionary *fav in tempFav) {
            
            if ([fav[@"CountryCode"] isEqualToString:_appDelegate.userCountry[@"CountryCode"]]) {
                
                [self.theFavorites addObject:fav];
                
            }
            
        }
        
        [self.tableView setBackgroundView:NULL];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;

    }
    else
    {
        self.backgroundView.center = self.view.center;
        [self.tableView setBackgroundView:self.backgroundView];
        self.navigationItem.rightBarButtonItem = nil;

    }
    
    //Get Image folder path
    _fileManager = [NSFileManager defaultManager];
    _imgageDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Images"];
    
    BOOL isDirectory;
    
    
    //check if image directory has been created
    if (![_fileManager fileExistsAtPath:_imgageDir isDirectory:&isDirectory] || !isDirectory)
    {
        
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [_fileManager createDirectoryAtPath:_imgageDir
               withIntermediateDirectories:YES
                                attributes:attr
                                     error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
    
    
    self.revealViewController.delegate = self;
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
   
    //Refresh Control Settings
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateFavorites:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl =refreshControl;
    
    
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

//Methods for Refreshing table

-(void)updateFavorites:(id)sender{
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}


//Update Table when Refresh is trigerred
-(void)updateTable
{
    
    //Get favorite file into theFavourite array
    _fileManager = [NSFileManager defaultManager];
    NSError *errror;
    
    //copy Favourite file to destinatioinPath is it doesn't exist
    if ([_fileManager fileExistsAtPath:_destinationPath])
    {
        NSLog(@" File Exist in destination Path = %@", _destinationPath);
    }
    else
    {
        NSString *sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"favourites.plist"];
        
        NSLog(@" source Path = %@", sourcePath);
        
        [_fileManager copyItemAtPath:sourcePath toPath:_destinationPath error:&errror];
        
    }
    
    self.theFavorites = [[NSMutableArray alloc]init];
    NSArray *tempFav = [NSArray arrayWithContentsOfFile:_destinationPath];
    if (tempFav.count > 0) {
        
        for (NSDictionary *fav in tempFav) {
            
            if ([fav[@"CountryCode"] isEqualToString:_appDelegate.userCountry[@"CountryCode"]]) {
                
                [self.theFavorites addObject:fav];
                
            }
            
        }
        
        [self.tableView setBackgroundView:NULL];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;

    }
    else
    {
        self.backgroundView.center = self.view.center;
        [self.tableView setBackgroundView:self.backgroundView];
        self.navigationItem.rightBarButtonItem = nil;

    }
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index{
    
    NSLog(@"imaged recieved");
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTable];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//set number of sections in table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//set number of row in sections
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.theFavorites.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.itemsCell = [tableView dequeueReusableCellWithIdentifier:@"favCell" forIndexPath:indexPath];
    
    NSDictionary *favItem = (NSDictionary *)[self.theFavorites objectAtIndex:indexPath.row];
    
    NSString *imageName = [[NSString alloc]initWithFormat:@"%lu%d",(unsigned long)((NSString *)favItem[@"Name"]).hash,[favItem[@"ImgNO"] intValue]];
    NSLog(@"%@",imageName);
    _imagePath = [_imgageDir stringByAppendingPathComponent:imageName];
    
    [self.itemsCell.itemImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:_imagePath]]];
    
    if (_imagePath==nil || self.itemsCell.itemImage.image==NULL) {
        
        [self.itemsCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
        
    }
    
    self.itemsCell.itemName.text =favItem[@"Name"];
    
    self.itemsCell.itemType.text =favItem[@"Type"];
    
    [self.itemsCell.spinner setHidden:YES];

    return self.itemsCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *favItem = (NSDictionary *)[self.theFavorites objectAtIndex:indexPath.row];
    
    if ([favItem[@"Type"] isEqualToString:@"Attractions"])
    {
        
        self.tabBarController  = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsTab"];
        
        self.tabBarController.overviewViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        self.tabBarController.mapViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        self.tabBarController.hotelViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        self.tabBarController.nearbyTableViewController = [self.tabBarController.viewControllers objectAtIndex:3];
        
        //Set values for sub views
        self.tabBarController.isFavourites = YES;
        self.tabBarController.favoriteFilter = favItem[@"Name"];
        self.tabBarController.favoriteType = favItem[@"Type"];
        self.tabBarController.favoriteImgURL = favItem[@"ImgUrl"];
        self.tabBarController.favoriteImgNO = favItem[@"ImgNO"];
        self.tabBarController.favoriteDetails = favItem[@"Name"];
        self.tabBarController.navigationItem.title = favItem[@"Name"];
        
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
        NSString *imageName = [[NSString alloc]initWithFormat:@"%@%d.png",favItem[@"Name"],1];
        _imagePath = [_imgageDir stringByAppendingPathComponent:imageName];
        self.tabBarController.mapViewController.imgData =  [[NSData alloc] initWithContentsOfFile:_imagePath];
        
        self.tabBarController.nearbyTableViewController.nearByItems = [[NSMutableArray alloc]init];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = self.tabBarController;
        
        [conn GetTour_DestWithName:favItem[@"Name"] CountryCode:_appDelegate.userCountry[@"CountryCode"] Caller:self.tabBarController CallBack:^(id callingObject)
         {
             dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                myTabBarController *tab = (myTabBarController *)callingObject;
                                
                                [self.navigationController pushViewController:tab animated:YES];
                            });
             
         }];


    }
    
    else if ([favItem[@"Type"] isEqualToString:@"Lodging"])
    {
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = favItem[@"Name"];
        self.svwWebView.favoriteType = @"Lodging";
        self.svwWebView.favoriteImgURL = favItem[@"ImgUrl"];
        self.svwWebView.favoriteImgNO = favItem[@"ImgNO"];
        self.svwWebView.title = favItem[@"Name"];
        
        [self.svwWebView loadWebPage:favItem[@"Details"]];
        
        self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];

        
    }
    else if([favItem[@"Type"] isEqualToString:@"Tours & Activities"])
    {
        
        TourViewController *tours = [self.storyboard instantiateViewControllerWithIdentifier:@"tourView"];
        
        tours.title = favItem[@"Name"];
        tours.imageDownloadCount = 0;
        tours.favoriteName = favItem[@"Name"];
        tours.favoriteType = favItem[@"Type"];
        tours.favoriteImgURL = favItem[@"ImgUrl"];
        tours.favoriteImgNO = favItem[@"ImgNO"];
        tours.favoriteDetails = favItem[@"Details"];
        
        tours.imagesData = [[NSMutableArray alloc]init];
        tours.availabilities = [[NSMutableArray alloc]init];
        
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = tours;
        [conn GetTourWithID:favItem[@"Details"] CountryCode:_appDelegate.userCountry[@"CountryCode"]];
        [conn GetTourAvailabilities:favItem[@"Details"] CountryCode:_appDelegate.userCountry[@"CountryCode"]];

        [self.navigationController pushViewController:tours animated:YES];

    }
    else
    {
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter =favItem[@"Name"];
        self.svwWebView.favoriteType = favItem[@"Type"];
        self.svwWebView.favoriteImgURL =favItem[@"ImgUrl"];
        self.svwWebView.favoriteImgNO = @"0";
        self.svwWebView.title = favItem[@"Name"];
        
        [self.svwWebView loadWebPage:favItem[@"Details"]];
        
        self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];

    }

    
    
}


// Action whent cell is highlighted
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.itemsCell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Show spinner on highlighted cell
    [self.itemsCell.spinner setHidden:NO];
    [self.itemsCell.spinner startAnimating];
    
    
}



// Action whent cell is not highlighted
-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.itemsCell = [tableView cellForRowAtIndexPath:indexPath];
    
    //hide spinner
    [self.itemsCell.spinner stopAnimating];
    [self.itemsCell.spinner setHidden:YES];
    
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark -Table view data source

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   if (editingStyle == UITableViewCellEditingStyleDelete) {
       
       [self updateTable];
       
       /*//Delete images
       NSDictionary *favItem = (NSDictionary *)[self.theFavorites objectAtIndex:indexPath.row];
       if (![favItem[@"Type"] isEqualToString:@"Attraction"])
       {
           self.PO = [[PlaceObject alloc]init];
           [self.PO deleteImages:[favItem[@"ImgNO"] intValue] :favItem[@"Name"]];
       }*/
       
       //remove deleted object from array
        [self.theFavorites removeObjectAtIndex:indexPath.row];
       
       //reloads the favourites file with the udated array
        [self.theFavorites writeToFile:_destinationPath atomically:YES];
     
       //remove the deleted item from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      
      
    }
    
    
    
}






#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
 
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *destinationPath = appDelegate.favoritePath;
    self.theFavorites = [NSMutableArray arrayWithContentsOfFile:destinationPath];
    id object = [self.theFavorites objectAtIndex:fromIndexPath.row];
    [self.theFavorites removeObjectAtIndex:fromIndexPath.row];
    
    [self.theFavorites replaceObjectAtIndex:fromIndexPath.row withObject:@"Dummy"];
    [self.theFavorites insertObject:object atIndex:toIndexPath.row];
    
 
}

 
  */

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


*/

@end
