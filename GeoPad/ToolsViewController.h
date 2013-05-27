//
//  ToolsViewController.h
//  
//
//  Created by GeoTouch on 6/2/13.
//
//

#import <UIKit/UIKit.h>

@protocol Drawtooldelegate <NSObject>

-(void) usertapondraw;
-(void) usertaponmeasure;
-(void) usertaponviewshed;
-(void) usertapongps;
-(void) usertapongeotag;
-(void) usertaponremlayer;
-(void) usertaponlegend;
-(void) usertaponmapdes;
-(void) usertaponoffline;

@end

@interface ToolsViewController : UIViewController
{
    UITableView *_tableView;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id <Drawtooldelegate> delegate;
//
//@property (nonatomic, strong) LegendDataSource *legendDataSource;
//@property (nonatomic, strong) LegendViewController *legendViewController;


@end
