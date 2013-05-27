//
//  ToolsViewController.m
//  
//
//  Created by GeoTouch on 6/2/13.
//
//

#import "ToolsViewController.h"
#import "RootViewController.h"
#import "SmoothedBIView.h"
//#import "LegendDataSource.h"
//#import "TOCViewController.h"



@interface ToolsViewController ()
{
    
    NSMutableArray *number;

    
}


@end

@implementation ToolsViewController

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
//@synthesize legendDataSource=_legendDataSource;
//@synthesize legendViewController=_legendViewController;
//@synthesize popOverController=_popOverController;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Received memory warning tools");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 9;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.tag = indexPath.row; // Important for identifying the cell easily later
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    
    //fontWithName:@"Arial-BoldMT" size:16
    //[cell setBackgroundColor:[UIColor blueColor]];
    
    
    
    
    if(cell.tag == 0)
    {
            cell.textLabel.text = @"Draw";
         
    
    }
    else if (cell.tag==1){
        cell.textLabel.text = @"Measure";
    }
    
    else if(cell.tag == 2){
        
          cell.textLabel.text = @"ViewShed";        
    }

    else if(cell.tag ==3){
        
          cell.textLabel.text = @"GPS";             
    }
    else if (cell.tag == 4){
        
        cell.textLabel.text =@"Legend";
    }
    
    else if (cell.tag == 5){
        
        cell.textLabel.text = @"Map Description";

        
    }
    else if (cell.tag == 6){
        
        cell.textLabel.text = @"GeoTag Photos";
        
    }
    
    else if(cell.tag == 7){
        
        cell.textLabel.text = @"Saved Maps";
        
    }
    else if (cell.tag == 8){
        
        cell.textLabel.text = @"Reset";
        
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;


    
    return cell;
}

    



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return 35;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
 Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rownum = indexPath.row;
    
    if (rownum == 0)
    {
        [self.delegate usertapondraw];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    
    else if (rownum == 1)
    {
        [self.delegate usertaponmeasure];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    else if (rownum==2){
        
        [self.delegate usertaponviewshed];
    	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
    else if (rownum==3){
        
        [self.delegate usertapongps];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
    else if (rownum==4){

        [self.delegate usertaponlegend];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        self.legendViewController = [[LegendViewController alloc] initWithNibName:@"LegendViewController" bundle:nil];
//        self.legendViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        self.legendViewController.legendDataSource1 = self.legendDataSource;
//        
//  
//            self.popOverController = [[UIPopoverController alloc]
//                                      initWithContentViewController:self.legendViewController];
//            [self.popOverController setPopoverContentSize:CGSizeMake(250, 500)];
//            self.popOverController.passthroughViews = [NSArray arrayWithObject:self.view];
//            self.legendViewController.popOverController = self.popOverController;
//        
//        CGRect aFrame = [tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:rownum inSection:0]];
//        [_popOverController presentPopoverFromRect:[tableView convertRect:aFrame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
       

        
        
        

    }
    
    
    else if(rownum == 5)
    {
        [self.delegate usertaponmapdes];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else if(rownum == 6)
    {
        [self.delegate usertapongeotag];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    
    else if(rownum == 7)
    {
        
        [self.delegate usertaponoffline];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    else if (rownum == 8)
    {
        [self.delegate usertaponremlayer];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */


}




//- (void)respondToLayerLoaded:(NSNotification*)notification {
//	//Add legend for each layer added to the map
//    
//    
//	[self.legendDataSource addLegendForLayer:(AGSLayer *)notification.object];
//    
//    
//}



@end
