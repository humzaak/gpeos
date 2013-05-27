//
//  DescriptionViewController.h
//  GeoPad
//
//  Created by GeoTouch on 13/5/13.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>


@interface DescriptionViewController : UIViewController

- (id)initWithMapView:(AGSMapView *)url;
- (void) processurl;

@property (nonatomic,strong) AGSMapView * mapviewurl;
@property (nonatomic, strong) AGSJSONRequestOperation* currentJsonOp;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (strong, nonatomic) IBOutlet UILabel *mapdeslabel;



@property (strong, nonatomic) IBOutlet UITextView *mapdescriptionview;


@end
