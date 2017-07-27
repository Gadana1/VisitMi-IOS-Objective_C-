//
//  ViewController.m
//  VisitMi
//
//  Created by Samuel on 10/18/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIActivityIndicatorView *loading ;

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.navigationItem.title = self.item_title;
    self.navigationItem.prompt = @"Select Preferred Location:";

  
    [self.backBT.layer setCornerRadius:5];
    [self.backBT.layer setMasksToBounds:YES];
    
    loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading startAnimating];
    [loading setHidesWhenStopped:YES];
    
    [self.view setUserInteractionEnabled:FALSE];
    
    loading.center = self.locTableView.center;
    [self.locTableView setBackgroundView:loading];
    
    self.locTableView.delegate = self;
    self.locTableView.dataSource = self;
    self.locTableView.estimatedRowHeight = 210.f;
    self.locTableView.rowHeight = 210.f;
    [self.locTableView registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locCell"];
    
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.locData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PlaceObject *place = (PlaceObject *)[self.locData objectAtIndex:indexPath.row];
    
    //dpwnload Imaes
    if (!place.img) {
        
        place.delegate = self;
        [place downloadImages:place.stateImage :0 :place.state :indexPath.row];

    }
    
    _locCell = [tableView dequeueReusableCellWithIdentifier:@"locCell" forIndexPath:indexPath];
    
    
    _locCell.loc_NameLB.text = place.state;
    _locCell.loc_ImageView.contentMode = place.img!=NULL?UIViewContentModeScaleToFill:UIViewContentModeScaleAspectFit;
    _locCell.loc_ImageView.image = place.img!=NULL?[UIImage imageWithData:place.img]:[UIImage imageNamed:@"image_file.png"];
    
    return _locCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataDynamicTableTableViewController *itemList = [self.storyboard instantiateViewControllerWithIdentifier:@"itemList"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    PlaceObject *placeObj = (PlaceObject *)[self.locData objectAtIndex:indexPath.row];
    
    itemList.presentCount = 0;
    itemList.count = 0;
    itemList.displayRegion = self.item_title;
    itemList.finalDataArr = [[NSMutableArray alloc]init];
    itemList.displayRegionArr = [[NSMutableArray alloc]init];
    itemList.scopes = [[NSMutableArray alloc]init];
    [itemList.scopes addObject:@"All"];

    if([self.item_title isEqualToString:@"Attractions"])
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = itemList;
        [conn GetTour_Destinations:app.userCountry[@"CountryCode"] LocCode:placeObj.stateCode ForLoc:TRUE];
        
    }
    else if([self.item_title isEqualToString:@"Tours & Activities"])
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = itemList;
        [conn GetTour:app.userCountry[@"CountryCode"]  LocCode:placeObj.stateCode ForLoc:TRUE];
        

    }
    
    [self.navigationController pushViewController:itemList animated:YES];

}

-(void)stateDownloaded:(id)placeObj
{
    [self.locData addObject:placeObj];

    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        
        [self.locTableView reloadData];
        [loading stopAnimating];
        [self.view setUserInteractionEnabled:TRUE];

        
    });
    
}

-(void)imagesDownloaded:(NSData *)imageDATA :(NSInteger)index
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if(index < [self.locData  count])
                       {
                           ((PlaceObject *)[self.locData objectAtIndex:index]).img = imageDATA;
                           
                           [self.locTableView reloadData];
                           
                       }
                   });
    
    
}
- (IBAction)skipAction:(id)sender
{
    
    DataDynamicTableTableViewController *itemList = [self.storyboard instantiateViewControllerWithIdentifier:@"itemList"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    itemList.displayRegion = self.item_title;
    itemList.displayRegionArr = [[NSMutableArray alloc]init];
    itemList.finalDataArr = [[NSMutableArray alloc]init];
    itemList.scopes = [[NSMutableArray alloc]init];
    [itemList.scopes addObject:@"All"];

    if([self.item_title isEqualToString:@"Attractions"])
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = itemList;
        [conn GetTour_Destinations:app.userCountry[@"CountryCode"] LocCode:NULL ForLoc:FALSE];
      
    }
    else if([self.item_title isEqualToString:@"Tours & Activities"])
    {
        DBConnect *conn = [[DBConnect alloc]init];
        conn.delegate = itemList;
        [conn GetTour:app.userCountry[@"CountryCode"]  LocCode:NULL ForLoc:FALSE];
        

    }
    [self.navigationController pushViewController:itemList animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
