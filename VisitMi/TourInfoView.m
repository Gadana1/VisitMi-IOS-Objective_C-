//
//  TourOfferView.m
//  VisitMi
//
//  Created by Samuel Gabriel on 30/01/2017.
//  Copyright © 2017 Mi S. All rights reserved.
//

#import "TourInfoView.h"

@interface TourInfoView ()

@end

@implementation TourInfoView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TourInfoDetailsView *details = [self.storyboard instantiateViewControllerWithIdentifier:@"infoDetailsView"];
    details.transitioningDelegate = self;
    details.navTitle = self.itemTitle;
    
    if (indexPath.row == 1)
    {
        NSLog(@"selected %@ ", self.tourDesc);
        
        details.item1Lb = @"Description";
        if ([self.tourDesc isEqualToString:@""] || self.tourDesc == NULL) {
            
            details.item1Txt = @"None";
            
        }
        else details.item1Txt= self.tourDesc;;
        
        details.item2Lb= @"Highlights";
        if ([self.highlights isEqualToString:@""] || self.highlights == NULL) {
            
            details.item2Txt = @"None";
            
        }
        else details.item2Txt= self.highlights;
        
        [self.navigationController pushViewController:details animated:YES];

    }
    else if (indexPath.row == 2)
    {

        details.item1Lb = @"Terms And Conditions";
        if ([self.terms isEqualToString:@""] || self.terms == NULL) {
            
            details.item1Txt = @"None";
            
        }
        else details.item1Txt = self.terms;
        
        details.item2Lb  = @"Know Before Booking";
        if ([self.knowb4Book isEqualToString:@""] || self.knowb4Book == NULL) {
            
            details.item2Txt = @"None";
        }
        else details.item2Txt = self.knowb4Book;
        
        [self.navigationController pushViewController:details animated:YES];

    }
    

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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




@end
