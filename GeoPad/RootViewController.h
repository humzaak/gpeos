// Copyright 2012 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "ActivityAlertView.h"


@interface RootViewController : UIViewController <UISearchBarDelegate, AGSLocatorDelegate, AGSMapViewCalloutDelegate,CLLocationManagerDelegate,AGSInfoTemplateDelegate,AGSCalloutDelegate> {
    
    
    UISearchBar *_searchBar;
    AGSSketchGraphicsLayer *_graphicsLayer;
	AGSLocator *_locator;
	AGSCalloutTemplate *_calloutTemplate;
    AGSCalloutTemplate *_calloutTemplate1;
}


-(IBAction)eosWebsite:(id)sender;
-(IBAction)aboutGeoPad:(UIButton*)sender;
- (void)startGeocoding;

@property (nonatomic, strong) IBOutlet AGSMapView *mapView;
@property (nonatomic, strong) AGSSketchGraphicsLayer *gpsSketchLayer;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) AGSSketchGraphicsLayer *graphicsLayer;
@property (nonatomic,strong) AGSSketchGraphicsLayer *graphicsLayerdraw;
@property (nonatomic,strong) AGSSketchGraphicsLayer *graphicsLayerviewshed;
@property (nonatomic,strong) AGSSketchGraphicsLayer *graphicsLayergeotag;
@property (nonatomic, strong) AGSGeoprocessor *gpTask;
@property (nonatomic, strong) NSOperation *gpOp;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *basemapsbutton;

@property (nonatomic, strong) AGSLocator *locator;
@property (nonatomic, strong) AGSCalloutTemplate *calloutTemplate;
@property (nonatomic,strong) AGSCalloutTemplate *calloutTemplate1;
@property (nonatomic, strong) ActivityAlertView *activityAlertView;
@property (nonatomic, strong) ActivityAlertView *internetAlertView;


@property (nonatomic, strong) AGSSketchGraphicsLayer *sketchLayer;

@property (nonatomic, strong) CLLocationManager *locationManager;




@end
