//
//  MapViewController.m
//  VisitMi
//
//  Created by Samuel on 10/24/15.
//  Copyright © 2015 Mi S. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()



@end

@implementation MapViewController

GMSCameraPosition *camera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Controls whether the My Location dot and accuracy circle is enabled.
    
    //self.mapview.myLocationEnabled = YES;
    
    //Controls the type of map tiles that should be displayed.
    
    self.mapview.mapType = kGMSTypeNormal;
    
    //Shows the compass button on the map
    
    self.mapview.settings.compassButton = YES;
    self.mapview.settings.zoomGestures = YES;

    
    //Sets the view controller to be the GMSMapView delegate
    self.mapview.delegate = self;
    
    camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:15];
    
    self.mapview.camera = camera;
    
    //set up Location Map info view
    self.locationName.text = _name;
    self.phoneNumberTXT.text= self.number;
    self.addressTXT.text=self.address;
    
    [self.ho_Img.layer setCornerRadius:5.0f];
    [self.ho_Img.layer setMasksToBounds:YES];
    
    [self.locationTypeImg.layer setCornerRadius:5.0f];
    [self.locationTypeImg.layer setMasksToBounds:YES];
    self.locationTypeImg.image = [UIImage imageWithData:_imgData];

    
    
    [self.refreshBT.layer setCornerRadius:5.0f];
    [self.refreshBT.layer setMasksToBounds:YES];
    
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
    
    self.countChKDownTimes = 0;
    
    
    [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0];

}


- (IBAction)refresh:(id)sender {
    
    self.mapview.camera = camera;

    [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0];

}



//Create custom marker info window
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    
    
    UIView *markerView = [[UIView alloc]init];
    
    if ([marker.snippet isEqualToString:@"hotel"])
    {
       
        HotelObject *HO = (HotelObject *)[self.hotelItems objectAtIndex:[marker.userData integerValue]];
    
        marker.tracksInfoWindowChanges = YES;
        
        _ho_Img.image = [UIImage imageWithData:HO.thumbnailData];
        _ho_Name.text = HO.name;
        [_ho_Rating setHidden:false];
        
        double rating = [HO.starRating doubleValue];
        
        if (rating == 1) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"1star.png"]];
            
        }
        if (rating >= 1.5) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"1.5star.png"]];
            
        }
        if (rating >= 2) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"2star.png"]];
            
        }
        if (rating >= 2.5) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"2.5star.png"]];
            
        }
        if (rating >= 3) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"3star.png"]];
            
        }
        if (rating >= 3.5) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"3.5star.png"]];
            
        }
        if(rating >= 4) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"4star.png"]];
            
        }
        if(rating >= 4.5) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"4.5star.png"]];
            
        }
        if(rating >= 5) {
            
            [_ho_Rating setImage:[UIImage imageNamed:@"5star.png"]];
            
        }
        
        
        
        markerView = _detailsView;
        
        return markerView;

    }
    
    else if ([marker.snippet isEqualToString:@"nearby"])
    {

        NearByObject *NBO = (NearByObject *)[self.pointsItems objectAtIndex:[marker.userData integerValue]];
        
        marker.tracksInfoWindowChanges = YES;
        
        _poi_Img.image = [UIImage imageWithData:NBO.thumbnailData];
        _poi_Name.text = NBO.name;
        _poi_type.text = NBO.cat_name;
        markerView = _poiDetailView;
        
        
        return markerView;
        
    }
    
    
    
    else if ([marker.title isEqualToString:self.name])
    {
        
        markerView = _locDetailView;
        
        return markerView;
        
    }
        
    
    
    return markerView;
}



//Set Action to marker info window
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    
    if ([marker.snippet isEqualToString:@"hotel"])
    {
        HotelObject *HO = (HotelObject *)[self.hotelItems objectAtIndex:[marker.userData integerValue]];

        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = HO.name;
        self.svwWebView.favoriteType = @"Lodging";
        self.svwWebView.favoriteImgURL = HO.thumbnailURL;
        self.svwWebView.favoriteImgNO = @"0";
        self.svwWebView.title = HO.name;
        
        [self.svwWebView loadWebPage:HO.detailURL];
        
        self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];
        

    }
    else if ([marker.snippet isEqualToString:@"nearby"])
    {
        NearByObject *NBO = (NearByObject *)[self.pointsItems objectAtIndex:[marker.userData integerValue]];
        
        self.svwWebView = [[SVWebViewController alloc]init];
        
        self.svwWebView.favoriteFilter = NBO.name;
        self.svwWebView.favoriteType = NBO.cat_name;
        self.svwWebView.favoriteImgURL = NBO.icon_url;
        self.svwWebView.favoriteImgNO = @"0";
        self.svwWebView.title = NBO.name;
        
        [NBO downloadItemsWithId:NBO.place_id];
        NBO.delegate = self;
        
        self.svwWebView.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self.navigationController pushViewController:self.svwWebView animated:YES];
        
        
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


//Hotel select map marker delegate
-(void)selectHotelMarker:(NSString *)name
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    for (GMSMarker *marker  in self.addedMarkers ) {
                        
                        if ([marker.title isEqualToString:name])
                        {
                            NSLog(@" markers name = %@ ", name );

                            [_mapview setSelectedMarker:marker];
                            _mapview.camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                                          longitude:marker.position.longitude
                                                                               zoom:15];
                            

                        }
                    }
                    
                });
    
    

}

//Nearby select map marker delegate
-(void)selectNearbyMarker:(NSString *)name
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       for (GMSMarker *marker  in self.addedMarkers ) {
                          

                           if ([marker.title isEqualToString:name])
                           {
                               NSLog(@" markers name = %@ ", name );
                               
                               [_mapview setSelectedMarker:marker];
                               _mapview.camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                                             longitude:marker.position.longitude
                                                                                  zoom:15];
                               
                               
                           }
                           
                       }
                       
                   });
    

    
}


- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker
{
    
    marker.tracksViewChanges = NO;

}

- (void)mapView:(GMSMapView *)mapView
idleAtCameraPosition:(GMSCameraPosition *)position {
   
    
    for (GMSMarker *marker in _addedMarkers)
    {
        
        marker.tracksViewChanges = NO;

    }
   
}


//Add Annotations to map
-(void)addAnnotations
{
    
    NSDictionary * markers;
    NSString *name;
    double latitude;
    double longitude;
    NSUInteger count;
    NSString *index;

    GMSMarker *marker;

    [self.mapview clear];
    

   
    if ([self checkKDwnloadCompleted])
    {
        [self.markersLoading setHidden:NO];
        [self.markersLoading startAnimating];
        
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        
        self.mapPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _mapPin.contentMode = UIViewContentModeScaleAspectFit;
        _mapPin.image = [UIImage imageNamed:@"marker_big.png"];
        marker.iconView = _mapPin;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = self.name;
        marker.snippet = @"attraction";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            marker.map = _mapview;
            [_mapview setSelectedMarker:marker];
            [_addedMarkers addObject:marker];
            
        });
        
        for (count = 0; count<self.markers.count; count++) {
            
            NSString *countMarkers =[[NSString alloc]initWithFormat:@"%lu",count ];
            
            markers= [self.markers valueForKey:countMarkers];
            
           
            if ([markers[@"Type"] isEqualToString:@"hotels"]) {
                
                name = markers[@"Name"];
                latitude = [markers[@"Latitude"] doubleValue];
                longitude = [markers[@"Longitude"] doubleValue];
                index = markers[@"Index"];

                //Creates a marker at location.
                marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(latitude,longitude);
                self.mapPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                _mapPin.image = [UIImage imageNamed:@"hotel-64.png"];
                _mapPin.contentMode = UIViewContentModeScaleAspectFit;
                marker.iconView = _mapPin;
                marker.flat = true;
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.title = name;
                marker.snippet = @"hotel";
                marker.userData = index;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    marker.map = _mapview;
                    [_addedMarkers addObject:marker];
                    
                });
            }
            
            
            else if ([markers[@"Type"] isEqualToString:@"points"]) {
                
                name = markers[@"Name"];
                latitude = [markers[@"Latitude"] doubleValue];
                longitude = [markers[@"Longitude"] doubleValue];
                index = markers[@"Index"];

                marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(latitude,longitude);
                self.mapPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                _mapPin.image = [UIImage imageNamed:@"point_of_interest.png"];
                _mapPin.contentMode = UIViewContentModeScaleAspectFit;
                marker.iconView = _mapPin;
                marker.flat = true;
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.title = name;
                marker.snippet = @"nearby";
                marker.userData = index;

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    marker.map = _mapview;
                    [_addedMarkers addObject:marker];
                    
                });
            }
            
            
            
        }
        
        
        [self.markersLoading stopAnimating];
        [self.markersLoading setHidden:YES];
        
        
    }
    
    else
    {
        [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:1];

    }
    
}


//Load Annotations
-(void)loadAnnotations:(int)count :(NSString *)annotationType
{
    
    NSNumber *latitudeNum;
    NSNumber *longitudeNum;
    NSString *countMarkers =[[NSString alloc]initWithFormat:@"%lu",self.markers.count];

    _details = [[NSMutableDictionary alloc]init];
    
    if ([annotationType isEqualToString:@"hotels"]) {
        
        self.HO = (HotelObject *)[self.hotelItems lastObject];
        
        latitudeNum = [NSNumber numberWithFloat:self.HO.latitude];
        longitudeNum = [NSNumber numberWithFloat:self.HO.longitude];
        self.hotelsCount = count;
        
        _details = [NSMutableDictionary
                    dictionaryWithDictionary:@{@"Name":self.HO.name,
                                               @"Type":annotationType,
                                               @"Latitude":latitudeNum,
                                               @"Longitude":longitudeNum,
                                               @"Index":[NSString stringWithFormat:@"%lu",[_hotelItems indexOfObject:_hotelItems.lastObject]],

                                                                   }];
        
        
        
        if (_details != nil) {
            
            [self.markers setValue:_details forKey:countMarkers];
            

        }
        
    }
    
    if ([annotationType isEqualToString:@"points"]) {
        
        self.NBO = (NearByObject *)[self.pointsItems lastObject];
        
        latitudeNum = [NSNumber numberWithFloat:self.NBO.place_latitude];
        longitudeNum = [NSNumber numberWithFloat:self.NBO.place_longitude];
        
        self.pointsCount = count;
        
        _details = [NSMutableDictionary
                    dictionaryWithDictionary:@{@"Name":self.NBO.name,
                                               @"Type":annotationType,
                                               @"Latitude":latitudeNum,
                                               @"Longitude":longitudeNum,
                                               @"Index":[NSString stringWithFormat:@"%lu",[_pointsItems indexOfObject:_pointsItems.lastObject]],

                                               }];
        

        
        
            if (_details != nil) {
                
                [self.markers setValue:_details forKey:countMarkers];
                
                
            }

    }

    
}

-(BOOL)checkKDwnloadCompleted
{
    
    //check if markkers are done loading
    
    self.countChKDownTimes++;
    
    if (self.hotelsCount !=0 && self.pointsCount !=0 && self.markers.count == (self.hotelsCount + self.pointsCount)) {
       
        return true;
        
    }
    if (self.countChKDownTimes > 4) {
        
        if (self.hotelsCount ==0 && self.pointsCount ==0) {
       
            
            [self.markersLoading stopAnimating];
            [self.markersLoading setHidden:YES];
            
            return true;
            
        }
     
        
    }
    else
    {
        return false;

    }
    
    
    return true;

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
