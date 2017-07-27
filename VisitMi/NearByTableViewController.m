//
//  NearByTableViewController.m
//  VisitMi
//
//  Created by Samuel Gabriel on 09/06/2016.
//  Copyright © 2016 Mi S. All rights reserved.
//

#import "NearByTableViewController.h"

@interface NearByTableViewController ()

@end

@implementation NearByTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.clearsSelectionOnViewWillAppear = true;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    //setup cell
    self.tableView.estimatedRowHeight = 110.f;
    self.tableView.rowHeight = 110.f;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearByTableViewCell" bundle:nil] forCellReuseIdentifier:@"NBItemCell"];
    
    _spinner.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-20,([UIScreen mainScreen].bounds.size.height/2)-84, 40.0, 40.0);
    [self.tableView setBackgroundView:_spinner];


    _alert=   [UIAlertController
               alertControllerWithTitle:@"NO PLACE FOUND!"
               message:nil
               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* retry = [UIAlertAction
                            actionWithTitle:@"Retry"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [_alert dismissViewControllerAnimated:YES completion:nil];
                                
                                if ([self.spinner isHidden]) {
                                    
                                    [self.spinner setHidden:NO];
                                    [self.spinner startAnimating];
                                }
                                
                                [self performSelector:@selector(checkNBOdataCount) withObject:nil afterDelay:3];
                                [self.tableView reloadData];
                                
                            }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"close"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [_alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.spinner stopAnimating];
                                 [self.spinner setHidden:YES];
                             }];
    
    [_alert addAction:retry];
    [_alert addAction:cancel];
    
    
    //Refresh Control Settings
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl =refreshControl;
    
}


-(void)update:(id)sender{
    
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:1];
}

//Update Table when Refresh is trigerred
-(void)updateTable
{
    
    [self checkNBOdataCount];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}


-(void)checkNBOdataCount
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.NBOount==0)
        {
            
            [self presentViewController:_alert animated:YES completion:nil];
            
        }
        if ([self.nearByItems count ] == self.NBOount) {
            
            [self.spinner stopAnimating];
            [self.spinner setHidden:YES];
            
        }
        
        
               
    });
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _nearByItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.NBCell = [tableView dequeueReusableCellWithIdentifier:@"NBItemCell" forIndexPath:indexPath];
    
    self.NBO= (NearByObject *)[self.nearByItems objectAtIndex:indexPath.row];
    
    if (self.nearByItems.count>0)
    {
        
        
        [self.NBCell.itemImage setImage:[UIImage imageWithData:self.NBO.thumbnailData]];
        if (self.NBO.thumbnailData == NULL) {
            
            [self.NBCell.itemImage setImage:[UIImage imageNamed:@"image_file.png"]];
            
        }
        
        [self.NBCell.taxiImg setHidden:YES];
        [self.NBCell.taxiBT setHidden:YES];
        
        self.NBCell.itemImage.backgroundColor = [UIColor clearColor];
        self.NBCell.itemImage.tintColor = [UIColor greenColor];
        [self.NBCell.itemImage.layer setCornerRadius:8.0f];
        [self.NBCell.itemImage.layer setMasksToBounds:YES];
        self.NBCell.nameLB.text =self.NBO.name;
        self.NBCell.catLB.text =self.NBO.cat_name;
        self.NBCell.distanceLB.text = self.NBO.place_distance;
        
        [self.NBCell.locationBT setTag:indexPath.row];
        [self.NBCell.locationBT addTarget:self action:@selector(openMapView:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    


    return self.NBCell;
}

-(void)openMapView: (UIButton *)sender
{
    
    NSUInteger row = sender.tag;
    self.NBO = (NearByObject *)[self.nearByItems objectAtIndex:row];
        
    if (self.delegate) {
        
        [self.delegate showMapViewFromNearby];
    }
    
    if (self.delegateForMap) {
        
        [self.delegateForMap selectNearbyMarker:self.NBO.name];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    self.NBO = (NearByObject *)[self.nearByItems objectAtIndex:indexPath.row];
    
    self.svwWebView = [[SVWebViewController alloc]init];
    
    self.svwWebView.favoriteFilter = self.NBO.name;
    self.svwWebView.favoriteType = self.NBO.cat_name;
    self.svwWebView.favoriteImgURL = self.NBO.icon_url;
    self.svwWebView.favoriteImgNO = @"1";
    self.svwWebView.title = self.NBO.name;

    [self.NBO downloadItemsWithId:self.NBO.place_id];
    self.NBO.delegate = self;
    
    [self.navigationController pushViewController:self.svwWebView animated:YES];
    
    
    
}

-(void)nearByWithIdDownloaded:(id)nearByOBJ
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       
                       self.NBO = (NearByObject *)nearByOBJ;
                       [self.svwWebView loadWebPage:self.NBO.canonicalURL];
                       
                   });
  
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (self.delegate) {
        

        [self.delegate nbScrollViewAction:self.tableView];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(checkNBOdataCount) withObject:nil afterDelay:3];
    [self.tableView reloadData];

 

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView scrollRectToVisible:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) animated:YES];

    
}

@end
