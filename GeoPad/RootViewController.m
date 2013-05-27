

#import "RootViewController.h"
#import <ArcGIS/ArcGIS.h>
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PortalExplorer.h"
#import "LoginViewController.h"
#import "LoadingView.h"
#import "BasemapsViewController.h"
#import "ResultsViewController.h"
#import "WebMercatorUtil.h"
#import "ToolsViewController.h"
#import "SmoothedBIView.h"
#import "ViewController.h"
#import "AboutGeoPad.h"
#import "TOCViewController.h"
#import "RootTableViewController.h"
#import "DescriptionViewController.h"




//contants for layers

#define ItemId_DefaultMap @"c63e861ae3c945aa9752fcb8d9431e1e"
//#define  ItemId_DefaultMap @"b31153c71c6c429a8b24c1751a50d3ad"
#define kGPTask @"http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/GPServer/Viewshed"
#define bingkey @"Alq6VhyXZINLUpNUP6o94wKmVV93pPoLhQyaX_QOgxFg4f5M9YMa5z3Bs-QnM-e-"

@interface RootViewController()<AGSMapViewLayerDelegate, AGSWebMapDelegate, PortalExplorerDelegate, LoginViewControllerDelegate,Drawtooldelegate,Roottabledelegate,Basemapdelegate, UIAlertViewDelegate,PhotoViewControllerDelegate,AGSCalloutDelegate>


{
    //private variables for safe coding
    double _distance;
    
    AGSSketchGraphicsLayer *_sketchLayer;
    
    NSString *prebasemap;
    
    double _mapfail;
    
    NSMutableArray *collectionpopups;
    
    BOOL _alreadypresentpointtouched;
    BOOL _alreadypresentpointtouched1;
    
    NSMutableArray *collectiontagimages;
    AGSPoint *pointtagged;
    
    

    
}



//map view to open the webmap in
@property (strong, nonatomic) IBOutlet SmoothedBIView *drawcanvas;

@property (strong, nonatomic) IBOutlet UINavigationItem *navitemgp;

//webmap that needs to be opened. 
@property (nonatomic, strong) AGSWebMap *webMap;

/*Portal Explorer is the object that is used to connect to a portal or organization and access its contents. 
 It has various delegate methods that the root view controller must implement.  
  Make sure to open the PE in a nav controller
  */
@property (nonatomic, strong) PortalExplorer *portalExplorer;


@property (nonatomic,strong) BasemapsViewController *basemapsshow;
@property (nonatomic,strong) WebMercatorUtil *webmac;


//login view
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic,strong) ToolsViewController *toolsD;

//loading view
@property (nonatomic, strong) LoadingView *loadingView;

//popover for ipad
@property (nonatomic, strong) UIPopoverController* popOver;
@property (nonatomic,strong) UIPopoverController * popOverabout;
@property (nonatomic,strong) UIPopoverController * popOverwebsite;
@property  (nonatomic,strong) UIPopoverController *popOveremail;
@property (nonatomic,strong) UIPopoverController *popOverbasemap;
@property (nonatomic,strong) UIPopoverController * popOvertools;
@property (nonatomic, strong) UIPopoverController *popOverControllerl;
@property (nonatomic,strong)    UIPopoverController *popOvercontrollero;
@property (nonatomic,strong)    UIPopoverController *popOverdes;


//toolbar buttons for undo and back draw and measure layers
@property (strong, nonatomic) IBOutlet UIBarButtonItem *undobutton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backbutton;
@property (strong,nonatomic)  IBOutlet UIBarButtonItem * eraseallbutton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ToolsButton1;

@property (strong, nonatomic) IBOutlet UIButton *drawmeasurelabel;

@property (strong, nonatomic) IBOutlet UILabel *mapcoords;

//GeoTag

@property (nonatomic, strong) ViewController * viewcontroller;
@property (nonatomic, strong) TOCViewController *tocViewController;
@property (nonatomic, strong) DescriptionViewController *desViewController;
@property (nonatomic, strong) RootTableViewController *offlineViewController;
@property (nonatomic, strong) AGSLocalTiledLayer *localTiledLayer;



//
//@property (strong, nonatomic) IBOutlet UIImageView *image1;
//
//@property (strong, nonatomic) IBOutlet UIImageView *image2;

//opens the default webmap into the mapview
- (void)openDefaultWebMap;





@end

@implementation RootViewController

static NSString *kGeoLocatorURL = @"http://tasks.arcgisonline.com/ArcGIS/rest/services/Locators/ESRI_Places_World/GeocodeServer";






@synthesize mapView = _mapView;
@synthesize webMap = _webMap;
@synthesize portalExplorer = _portalExplorer;
@synthesize loginVC = _loginVC;
@synthesize loadingView = _loadingView;
@synthesize popOver = _popOver;
@synthesize popOverabout = _popOverabout;
@synthesize basemapsshow = _basemapsshow;
@synthesize searchBar = _searchBar;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize graphicsLayerdraw =_graphicsLayerdraw;
@synthesize locator = _locator;
@synthesize calloutTemplate = _calloutTemplate;
@synthesize calloutTemplate1 =_calloutTemplate1;
@synthesize webmac =_webmac;
@synthesize undobutton =_undobutton;
@synthesize backbutton =_backbutton;
@synthesize eraseallbutton =_eraseallbutton;
@synthesize popOvertools =_popOvertools;
@synthesize drawcanvas = _drawcanvas;
@synthesize toolsD =_toolsD;
@synthesize drawmeasurelabel =_drawmeasurelabel;
@synthesize sketchLayer = _sketchLayer;
@synthesize graphicsLayerviewshed=_graphicsLayerviewshed;
@synthesize graphicsLayergeotag =_graphicsLayergeotag;
@synthesize activityAlertView=_activityAlertView;
@synthesize internetAlertView=_internetAlertView;
@synthesize gpTask=_gpTask;
@synthesize gpOp=_gpOp;
@synthesize locationManager = _locationManager;
@synthesize gpsSketchLayer = _gpsSketchLayer;
@synthesize tocViewController = _tocViewController;
@synthesize desViewController =_desViewController;
@synthesize offlineViewController =_offlineViewController;
@synthesize popOverControllerl =_popOverControllerl;
@synthesize popOvercontrollero =_popOvercontrollero;
@synthesize localTiledLayer =_localTiledLayer;
@synthesize basemapsbutton = _basemapsbutton;
@synthesize popOverdes =_popOverdes;
@synthesize ToolsButton1=_ToolsButton1;

//@synthesize image1 = _image1;
//@synthesize image2 = _image2;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
        NSLog(@"Received memory warning root");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showMagnifierOnTapAndHold = YES;
    

	// set the delegate for the map view
	self.mapView.layerDelegate = self;
    self.mapView.callout.delegate = self;
    
    self.mapView.touchDelegate=(id)self;
    [self.mapView enableWrapAround];

    
    //set up the GP task

   // NSLog(@"Documents: %@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    self.internetAlertView = [[ActivityAlertView alloc]
                              initWithTitle:@"No Internet Connection"
                              message:@"\n\nConnect to internet and try again"
                              delegate:self cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];

//    
//   NSURL *serviceUrl = [NSURL URLWithString:defbasemap];
//    AGSTiledMapServiceLayer *tiledMapServiceLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:serviceUrl];
//    [self.mapView addMapLayer:tiledMapServiceLayer withName:@"World Street Map"];
////
    
      [self openDefaultWebMap];

    
    
    
    
    
    if(!self.portalExplorer){
        self.portalExplorer = [[PortalExplorer alloc] initWithURL:[NSURL URLWithString: @"http://www.arcgis.com"] credential:nil];
        self.portalExplorer.delegate = self;
        
        
    }
    

    
    self.backbutton.enabled = NO;
    self.undobutton.enabled= NO;
    self.eraseallbutton.enabled = NO;
    self.drawcanvas.hidden = YES;
    self.ToolsButton1.enabled=YES;
    
    
    self.toolsD = [[ToolsViewController alloc] initWithNibName:@"ToolsViewController" bundle:nil];
    

    


 //   [[NSNotificationCenter defaultCenter] addObserver:self.toolsD selector:@selector(respondToLayerLoaded:) name:AGSLayerDidLoadNotification object:nil];
    
    
  //self.toolsD.legendDataSource=[[LegendDataSource alloc]init];
    
   self.tocViewController = [[TOCViewController alloc] initWithMapView:self.mapView];
    self.offlineViewController =[[RootTableViewController alloc]initWithNibName:@"RootTableViewController" bundle:nil];
       self.desViewController = [[DescriptionViewController alloc] initWithMapView:self.mapView];

    collectionpopups = [[NSMutableArray alloc]init];
    collectiontagimages =[[NSMutableArray alloc]init];
    pointtagged = [[AGSPoint alloc]init];
    
    _alreadypresentpointtouched=NO;
    _alreadypresentpointtouched1=NO;
    
    
    
    
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    //we're not releasing the portal explorer because a user may have signed in and we don't want to lose that information
    NSLog(@"memory warning");
}



-(BOOL)ctoi {
    NSError *error;
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com.sg"] encoding:NSASCIIStringEncoding error:&error];
  
    return ( URLString != NULL ) ? YES : NO;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
//    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
//    {
//        self.image2.hidden = YES;
//        self.image1.hidden = NO;
//        
//        
//    }
//    else{
//        
//        
//        self.image1.hidden = YES;
//        self.image2.hidden = NO;
//    }

   
        return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    if([self.popOverabout isPopoverVisible]){
        [self.popOverabout dismissPopoverAnimated:YES];
    }
    
//    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//    {
//        self.image2.hidden = YES;
//        self.image1.hidden = NO;
//        
//        
//    }
//    else{
//        
//        
//        self.image1.hidden = YES;
//        self.image2.hidden = NO;
//    }
    
}

#pragma mark AGSWebMapDelegate

- (void)webMapDidLoad:(AGSWebMap *)webMap {
	
	//open webmap in mapview
	[self.webMap openIntoMapView:self.mapView];
 //   [self.webMap openIntoMapView:self.graphicsLayer];

    

    
    
}

- (void)webMap:(AGSWebMap *)webMap didFailToLoadWithError:(NSError *)error {
	
    //show the error message in an alert. 
	//NSString *err = [NSString stringWithFormat:@"%@",error];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load webmap"
													message:@"No Internet connection, Only saved maps are available"
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
    
    [alert show];
    
    _mapfail = 1;
    
    
    
//    if(self.internetAlertView.visible==NO){
//        
//        [self.internetAlertView show];
//        
//    }
//    
//    
//    
//    [self openDefaultWebMap];

}


//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == [alertView cancelButtonIndex]) {
//        if([self ctoi]==NO){
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load webmap"
//                                                            message:@"Check your internet connection and tap Ok"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//            
//            
//            [alert show];
//            
//        }
//        else{
//            
//            [self openDefaultWebMap];
//        }
//        
//     }
//}


-(void)didFailToLoadLayer:(NSString *)layerTitle url:(NSURL *)url baseLayer:(BOOL)baseLayer withError:(NSError *)error {
    
	//show the error message in an alert. 
	NSString *err = [NSString stringWithFormat:@"%@",error];	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load layer"
													message:err
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];

    
    [alert show];

    
}




- (void)didOpenWebMap: (AGSWebMap*)webMap intoMapView: (AGSMapView *)mapView
{
    if(self.sketchLayer ==nil)
    {
    
    self.sketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
    self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
    [self.mapView addMapLayer:self.sketchLayer withName:@"Sketch layer"];
    self.sketchLayer.visible=NO;
    }
    
    if(self.graphicsLayer ==nil)
    {
    self.graphicsLayer = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
    [self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    }
    
    if(self.graphicsLayerviewshed == nil)
    
    {
    
    //add  graphics layer for showing results of the viewshed calculation
    self.graphicsLayerviewshed = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
    [self.mapView addMapLayer:self.graphicsLayerviewshed withName:@"Viewshed"];
    self.graphicsLayerviewshed.visible=NO;
    
    }
    
    
    //setting up the alert view to show th ebusy indicator.
    self.activityAlertView = [[ActivityAlertView alloc]
                              initWithTitle:@"Calculating Viewshed..."
                              message:@"\n\n"
                              delegate:self cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
    

    
    if(self.graphicsLayerdraw == nil)
    {
    self.graphicsLayerdraw = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
    [self.mapView addMapLayer:self.graphicsLayerdraw withName:@"Graphics Layer Draw"];
    }
    // Once all the layers in web map are loaded
    // Add AGSGraphicslayer on top
//    NSLog(@"%@",self.mapView);
    
    if(self.gpsSketchLayer==nil)
    {
    self.gpsSketchLayer = [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil];
	[self.mapView addMapLayer:self.gpsSketchLayer withName:@"GPS Sketch layer"];
    self.gpsSketchLayer.visible=NO;
    }
    
    if(self.graphicsLayergeotag == nil)
        
    {
        
        //add  graphics layer for showing results of the viewshed calculation
        self.graphicsLayergeotag = [AGSSketchGraphicsLayer graphicsLayer];  //humza changed
        [self.mapView addMapLayer:self.graphicsLayergeotag withName:@"geotag"];
        self.graphicsLayergeotag.visible=NO;
        
    }
    
    
   // self.desViewController= nil;
    
    [self.internetAlertView close];

    
  //  self.ToolsButton.enabled=YES;
    
    

    
//
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.mapView.layer;
    
    eaglLayer.drawableProperties = @{
                                     kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:YES],
                                     kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
                                     };
    
    
    if(self.basemapsbutton.enabled == NO)
    {
        self.basemapsbutton.enabled = YES;
        self.searchBar.placeholder =@"Search the world using GeoPad";
    }

//

}


#pragma mark PortalExplorerDelegate

- (void)portalExplorer:(PortalExplorer *)portalExplorer didLoadPortal:(AGSPortal *)portal
{
    //if the login view is currently shown, it means that the user is logging in and
    // the portal explorer was updated with the user's credential. 
    //We have to remove the  login view. 
    if(self.loginVC)
    {
        [self.loadingView removeView];
        [self.loginVC dismissViewControllerAnimated:YES completion:nil];
        self.loginVC = nil;
    }
    
    //remove the loading view. 
    if(self.loadingView)
        [self.loadingView removeView];
    
}

- (void)portalExplorer:(PortalExplorer *)portalExplorer didFailToLoadPortalWithError:(NSError *)error
{
    
    //remove the loading view. 
    if(self.loadingView)
        [self.loadingView removeView];
    
    //show the error message if the portal fails to load.
    NSString *err = [NSString stringWithFormat:@"%@",error.localizedDescription];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect to portal"
													message:err
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
    
    
}

- (void)portalExplorer:(PortalExplorer *)portalExplorer didRequestSignInForPortal:(AGSPortal *)portal
{
    //This means a user is trying to log in 
    //show the login view  
    
    if(!self.loginVC){
        self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.loginVC.delegate = self;
    }
    
 //   if([[AGSDevice currentDevice] isIPad]){
        
        self.loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.loginVC.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.popOver.contentViewController presentViewController:self.loginVC animated:YES completion:nil];
           
   // }else{
     //   [self.portalExplorer presentViewController:self.loginVC animated:YES completion:nil];
    //}
    
}

- (void)portalExplorer:(PortalExplorer *)portalExplorer didRequestSignOutFromPortal:(AGSPortal *)portal
{
    //This means a user signed out 
    
    //show the loading view while signing out. 
    self.loadingView = [LoadingView loadingViewInView:self.portalExplorer.view withText:@"Logging Out..."]; 
    
    //update the portal explorer with the nil credential as the user is signing out. 
    [self.portalExplorer updatePortalWithCredential:nil];
}

- (void)portalExplorer:(PortalExplorer *)portalExplorer didSelectPortalItem:(AGSPortalItem *)portalItem
{
    //open the webmap with the portal item as specified
	self.webMap = [AGSWebMap webMapWithPortalItem:portalItem];
	self.webMap.delegate = self;
	self.webMap.zoomToDefaultExtentOnOpen = YES;
    
    //dismiss the PE
    if([[AGSDevice currentDevice]isIPad]){
        [self.popOver dismissPopoverAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)portalExplorerWantsToHide:(PortalExplorer *)portalExplorer{
    //dismiss the PE
    if([[AGSDevice currentDevice]isIPad]){
        [self.popOver dismissPopoverAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark LoginViewControllerDelegate

- (void)userDidProvideCredential:(AGSCredential *)credential
{
    //show the loading view 
    self.loadingView = [LoadingView loadingViewInView:self.loginVC.view withText:@"Logging In..."]; 
    
    //update the portal explorer with the credential provided by the user. 
    [self.portalExplorer updatePortalWithCredential:credential];
    
}

- (void)userDidCancelLogin
{
    //remove the loading view
    [self.loadingView removeView];
    
    //dismiss the login view. 
    [self.portalExplorer dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark DrawTooldelegate

-(void) usertapondraw{
    
    
    
    if(self.sketchLayer.visible==YES){

        [self.sketchLayer clear];

        self.sketchLayer.visible=NO;

        self.sketchLayer.geometry=nil;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"Viewshed Calculator (radius 5km)"]){
        
        [self.gpOp cancel];
        self.gpOp = nil;
        
        //clear the graphics layer.
        [self.graphicsLayerviewshed removeAllGraphics];
        self.graphicsLayerviewshed.visible=NO;
        
        
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GPS"]){
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
        self.undobutton.title = @"Undo";
    }
    
    else if([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    {
        
        self.graphicsLayergeotag.visible=NO;
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.undobutton.enabled=NO;
        self.undobutton.title = @"Undo";
        
    }
    
    
    
    [self.drawmeasurelabel setTitle:@"Draw Freehand" forState:UIControlStateNormal];
    
    self.drawcanvas.hidden = NO;
    
    [self.drawcanvas setOpaque:NO];
    self.drawcanvas.backgroundColor = [UIColor clearColor];
    [self.drawcanvas.layer setBackgroundColor:(__bridge CGColorRef)([UIColor clearColor])];
   
    
    if(self.undobutton.isEnabled == NO)
    {
        self.undobutton.enabled = YES;
        self.backbutton.enabled = YES;
        
    }

    
    [self.popOvertools dismissPopoverAnimated:YES];
    
    
    
    
}



- (IBAction)backbutton:(UIBarButtonItem *)sender {
    
    
    if(self.drawcanvas.hidden==NO)
    {
    
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
    
        
        AGSMutablePolyline *mappoly=[[AGSMutablePolyline alloc]initWithSpatialReference:self.mapView.spatialReference];
        
        [mappoly addPathToPolyline];
        
        
        
        for(int i = 0;i<self.drawcanvas.tempArray.count;i=i+1){
            
            
            
            
            //  CGPoint *object = (__bridge CGPoint *)([self.drawcanvas.tempArray objectAtIndex:i]);
            
            CGPoint objectpoint = [[self.drawcanvas.tempArray objectAtIndex:i]CGPointValue];
            
            
            
            
            AGSPoint *mappoint =[self.mapView toMapPoint:objectpoint];
            
            [mappoly addPointToPath:mappoint];
            
            
        }
        
        
        
        //  AGSPictureMarkerSymbol *marker = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"BluePushpin.png"];
        // marker.offset = CGPointMake(9,16);
        // marker.leaderPoint = CGPointMake(-9, 11);
        
        //  AGSSimpleFillSymbol *marker = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor redColor] outlineColor:[UIColor redColor]];
        
     //   AGSSimpleLineSymbol *marker1 =[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor]];
    
        CGSize markersize = CGSizeMake(8.0, 2.0);
    
        AGSSimpleMarkerSymbol *marker2 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
        marker2.style= AGSSimpleMarkerSymbolStyleSquare;
    
        marker2.size = markersize;
    
        
        
        AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry: mappoly
                                                            symbol:marker2
                               
                                                        attributes:nil
                                              infoTemplateDelegate:nil];
        
        
        
        
        [self.graphicsLayerdraw removeAllGraphics];
        //add the graphic to the graphics layer
     
        

      if(self.graphicsLayerdraw !=nil)
        {
        
        [self.mapView addMapLayer:self.graphicsLayerdraw];
            [self.graphicsLayerdraw addGraphic:graphic];

        }
      else{
          
          self.graphicsLayerdraw = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
          [self.mapView addMapLayer:self.graphicsLayerdraw withName:@"Graphics Layer Draw"];
          [self.graphicsLayerdraw addGraphic:graphic];

      }
        
        
    
        [self.graphicsLayerdraw setVisible:YES];
    
    
    
        [self.drawcanvas backButtonClicked];
  //  self.drawcanvas.userInteractionEnabled=NO;
        self.drawcanvas.hidden = YES;
    
    
         self.backbutton.enabled = NO;
         self.undobutton.enabled = NO;
         self.eraseallbutton.enabled = YES;
    
    }
    
    else if(self.sketchLayer.visible==YES){
        
    [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
    
    [self.sketchLayer clear];
    
    self.sketchLayer.geometry=nil;
    self.sketchLayer.visible=NO;
    

    [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
    
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
        self.mapView.touchDelegate = nil;
        


    }
    
    
    else if (self.graphicsLayerviewshed.visible==YES){
        
        
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        [self.gpOp cancel];
        self.gpOp = nil;
        
        //clear the graphics layer.
        [self.graphicsLayerviewshed removeAllGraphics];
        self.graphicsLayerviewshed.visible=NO;
        
        self.backbutton.enabled = NO;
        self.graphicsLayerviewshed=nil;
        
        self.mapView.touchDelegate = nil;


    }
    
    
    else if (self.gpsSketchLayer.visible==YES){
        
        [self.locationManager stopUpdatingLocation];
        [self.mapView.locationDisplay setAlpha:0.0];
        
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
        self.backbutton.enabled = NO;
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        self.undobutton.enabled = NO;
        self.undobutton.title=@"Undo";
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    {
        self.graphicsLayergeotag.visible=NO;
        
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.mapView.callout.customView = nil;
        
        self.drawmeasurelabel.titleLabel.text =@"";
        self.undobutton.enabled=NO;
        self.undobutton.title = @"Undo";
        
    }
    

self.mapView.touchDelegate = (id)self;


}

- (IBAction)undobutton:(UIBarButtonItem *)sender {
    
  
    if(self.drawcanvas.hidden==NO){
        [self.drawcanvas undoButtonClicked];
    }
    else if (self.sketchLayer.visible==YES)
    {
    
  	if([self.sketchLayer.undoManager canUndo]) //extra check, just to be sure
		[self.sketchLayer.undoManager undo];
    }
    
    
    
    else if ([self.undobutton.title isEqualToString:@"Start"]){
    //we remove the previos part from the sketch layer as we are going to start a new GPS path.
    [self.gpsSketchLayer removePartAtIndex:0];
    
    //add a new path to the geometry in preparation of adding vertices to the path
    [self.gpsSketchLayer addPart];
    
    //create the location manager.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //set the preferences that was configured using the settings view.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1.0;
    
    //start the location maneger.
    [self.locationManager startUpdatingLocation];
    
    //set the title of the button to Stop and change the selector on it.
    self.undobutton.title = @"Stop";
    [self.undobutton setAction:@selector(stopGPSSketching)];


}
    else if([self.undobutton.title isEqualToString:@"Remove Log"]){
        
        if([collectiontagimages count]>0)
        {
            [collectiontagimages removeAllObjects];
            
        }
        
        if([self.viewcontroller.collectionImages count]>0)
        {
            [self.viewcontroller.collectionImages removeAllObjects];
    
        }

        
        if([self.viewcontroller.capturedImages count]>0)
        {
            [self.viewcontroller.capturedImages removeAllObjects];
            
        }
        
        self.undobutton.title = @"Undo";
        self.undobutton.enabled =NO;
        self.mapView.touchDelegate = nil;
        [self.graphicsLayergeotag removeAllGraphics];
        self.graphicsLayergeotag = nil;
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.drawmeasurelabel.titleLabel.text =@"";
        self.viewcontroller = nil;
        
        
    }
    
}

- (IBAction)eraseall:(UIBarButtonItem *)sender {
    
    [self.graphicsLayerdraw removeAllGraphics];
       self.drawcanvas.hidden = YES;
    self.eraseallbutton.enabled = NO;
    
}



#pragma mark Helper

//open default webmap
- (void)openDefaultWebMap {
    
    
    //open the webmap
	self.webMap = [AGSWebMap webMapWithItemId:ItemId_DefaultMap credential:nil];
    //set the webmap delegate to self
	self.webMap.delegate = self;
    
    //zoom to default extent
	self.webMap.zoomToDefaultExtentOnOpen = YES;
    
    

}

- (IBAction)showPortalExplorer:(id)sender
{
    
    if([self ctoi] == YES)
    {
    
    if([[AGSDevice currentDevice] isIPad]){ //ipad
        
        if(!self.popOver){ //we dont' have a popover view controller, so let's create one
            
            //We must use a nav controller for the portal explorer so that we have ability to navigate back/forth
            UINavigationController *portalExplorerNavController = 
            [[UINavigationController alloc] initWithRootViewController:self.portalExplorer];    
            portalExplorerNavController.navigationBar.barStyle = UIBarStyleDefault;
            
            
            self.popOver= [[UIPopoverController alloc]
                                    initWithContentViewController:portalExplorerNavController] ;
            [self.popOver setPopoverContentSize:CGSizeMake(320, 480)];
        }
        
        if([self.popOver isPopoverVisible]){
            //let's hide the popover because it is already visible
            [self.popOver dismissPopoverAnimated:YES];
        }else{
            //let's show the popover
        	[self.popOver presentPopoverFromBarButtonItem:sender 
                                 permittedArrowDirections:UIPopoverArrowDirectionUp
                                                 animated:YES ];
            
        }
    }else{ //iphone
        
        //We must use a nav controller for the portal explorer so that we have ability to navigate back/forth
        UINavigationController *portalExplorerNavController = 
        [[UINavigationController alloc] initWithRootViewController:self.portalExplorer];    
        portalExplorerNavController.navigationBar.barStyle = UIBarStyleDefault;
        
        //Present modally for iphone
        [self presentViewController:portalExplorerNavController
                                animated:YES completion:nil];
    }
    }
    
    
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect to portal"
                                                        message:@"The internet connection appears to be offline"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

-(IBAction)aboutGeoPad:(UIButton*)sender{
    
    
    if(!self.popOverabout){ //we dont' have a popover view controller, so let's create one
        
        //We must use a nav controller for the portal explorer so that we have ability to navigate back/forth
        UIViewController *aboutcon = [[UIViewController alloc] initWithNibName:@"AboutGeoPad" bundle:nil];   //:self.portalExplorer];
//        UIImage *myImage = [UIImage imageNamed:@"AboutText.jpg"];
//        UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
        
            
    //    [aboutcon.view addSubview:myImageView];

        
        self.popOverabout= [[UIPopoverController alloc]
                       initWithContentViewController:aboutcon] ;
        [self.popOverabout setPopoverContentSize:CGSizeMake(300, 380)];
    }
    
    if([self.popOverabout isPopoverVisible]){
        //let's hide the popover because it is already visible
        [self.popOverabout dismissPopoverAnimated:NO];
    }else{
        //let's show the popover
        CGRect aboutRectangle = CGRectMake(self.mapView.frame.size.width/2, self.mapView.frame.size.height/2, 1, 1);
        [self.popOverabout presentPopoverFromRect: aboutRectangle inView:self.mapView permittedArrowDirections:0 animated:YES];//:sender
                             //permittedArrowDirections:UIPopoverArrowDirectionUp
                                             //animated:YES ];
        //[popover presentPopoverFromRect:[theButton bounds] inView:theButton permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
    }
    
}


-(IBAction)eosWebsite:(id)sender
{
    if([self ctoi]==YES)
    {
    
    if(!self.popOverwebsite){ //we dont' have a popover view controller, so let's create one
        
        
    
        
        
        //We must use a nav controller for the portal explorer so that we have ability to navigate back/forth
        UIViewController *webcon = [[UIViewController alloc] init];//:self.portalExplorer];
        UIWebView *myWebView = [[UIWebView alloc]init];
        myWebView.scalesPageToFit = YES;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.earthobservatory.sg"]]];
        
        

        
             
        webcon.view = myWebView;
                
        self.popOverwebsite= [[UIPopoverController alloc]
                            initWithContentViewController:webcon] ;
        [self.popOverwebsite setPopoverContentSize:CGSizeMake(320, 480)];
        
        
   
        
    }
    
    if([self.popOverwebsite isPopoverVisible]){
        //let's hide the popover because it is already visible
        [self.popOverwebsite dismissPopoverAnimated:YES];
    }else{
        //let's show the popover
        [self.popOverwebsite presentPopoverFromBarButtonItem:sender
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES ];
        
    }
    
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load website"
                                                        message:@"No Internet connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }

}



- (NSData *)getImage{
    
    //the rest
    GLint width;
    
    GLint height;
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    NSInteger myDataLength = width * height * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < height; y++)
    {
        for(int x = 0; x < width * 4; x++)
        {
            buffer2[((height - 1) - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    //CGImageRef imageRefCopy = CGImageCreateCopy(imageRef);
    
    // then make the uiimage from that
    UIImage *myImage = [[UIImage alloc] initWithCGImage:imageRef];
   NSData *iDat = UIImageJPEGRepresentation(myImage, .5);
    //NSData *iDat = UIImagePNGRepresentation(myImage);
   CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
   free(buffer);
   free(buffer2);
 return iDat;
  //return myImage;
}




- (IBAction)emailscreenshot:(UIBarButtonItem *)sender {
    
   //UIGraphicsBeginImageContextWithOptions(self.mapView.frame.size,NO, 0.0);
   // [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    


    NSData *snapshotimage =[self getImage];
    
   //UIImage *screenshot = [UIImage imageWithData:snapshotimage];

	
//    
//   eaglLayer.drawableProperties = @{
//                                     kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:NO]
//                                    };
  // UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    

//	UIImageWriteToSavedPhotosAlbum(screenshot,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
    
//   __block NSData *iDat = nil;
//    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    
//    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
//    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        
//        // Within the group enumeration block, filter to enumerate just photos.
//        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//        
//        // Chooses the photo at the last index
//        
//        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
//            
//            // The end of the enumeration is signaled by asset == nil.
//            if (alAsset) {
//                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
//                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
//                 iDat = UIImagePNGRepresentation(latestPhoto);
//                
//                // Do something interesting with the AV asset.
//            }
//        }];
//    } failureBlock: ^(NSError *error) {
//        // Typically you should handle an error more gracefully than this.
//        NSLog(@"No groups");
//    }];
//    
    
   if ( [MFMailComposeViewController canSendMail] ) {
        MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = (id)self;
        [mailComposer setSubject:@"GeoPad Screenshot"];
        [mailComposer addAttachmentData:snapshotimage mimeType:@"image/png" fileName:@"attachment.png"];
       
        [mailComposer setMessageBody:@"Thanks for using GeoPad by EOS." isHTML:NO];
       
               /* Configure other settings */
   [self presentViewController:mailComposer animated:YES completion:nil];
       
    }
    
    
    
   //UIGraphicsEndImageContext();

 
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
		// Show error message...
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	
    }
    else  // No errors
    {
		// Show message image successfully saved
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Saved"
														message:@"Image saved to photo album successfully!"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	
    }
    
    
}

- (IBAction)basemaps:(UIBarButtonItem *)sender {
    
if(self.basemapsshow == nil)
{
    self.basemapsshow = [[BasemapsViewController alloc]initWithNibName:@"Basemaps" bundle:nil];
    self.basemapsshow.delegate1=self;
    
}
    
    
    //
//    
//   self.basemapsshow.basemaplayout= [[UICollectionViewFlowLayout alloc] init];
////    [self.basemapsshow.basemaplayout setItemSize:CGSizeMake(200, 140)];
////    [self.basemapsshow.basemaplayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
////    
//    
//    self.basemapsshow = [[BasemapsViewController alloc]initWithCollectionViewLayout:self.basemapsshow.basemaplayout];
//    
   if(!self.popOverbasemap){
//        
//        
//        
//        //We must use a nav controller for the portal explorer so that we have ability to navigate back/forth
//          
//        
        self.popOverbasemap= [[UIPopoverController alloc]
                       initWithContentViewController:self.basemapsshow] ;
        [self.popOverbasemap setPopoverContentSize:CGSizeMake(320, 320)];
    }
//    
    if([self.popOverbasemap isPopoverVisible]){
//        //let's hide the popover because it is already visible
        [self.popOverbasemap dismissPopoverAnimated:YES];
    }else{
        //let's show the popover
        [self.popOverbasemap presentPopoverFromBarButtonItem:sender                             permittedArrowDirections:UIPopoverArrowDirectionUp
                                            animated:YES ];
        
    }
//    
    
}


- (IBAction)tools:(UIBarButtonItem *)sender {
    
  
    
  

    self.toolsD.delegate=self;
    
    
    
    if(!self.popOvertools){
        

        
         self.popOvertools= [[UIPopoverController alloc]
                              initWithContentViewController:self.toolsD] ;
        [self.popOvertools setPopoverContentSize:CGSizeMake(200, 315)];
        
    }
    
    if([self.popOvertools isPopoverVisible]){
        //let's hide the popover because it is already visible
        [self.popOvertools dismissPopoverAnimated:YES];
    }else{
        //let's show the popover
        [self.popOvertools presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES ];
        
        
        
    }
    
    
    
}



- (void)startGeocoding
{
    
    //clear out previous results
    [self.graphicsLayer removeAllGraphics];
    
    //create the AGSLocator with the geo locator URL
    //and set the delegate to self, so we get AGSLocatorDelegate notifications
    self.locator = [AGSLocator locatorWithURL:[NSURL URLWithString:kGeoLocatorURL]];
    self.locator.delegate = self;
    self.mapView.callout.delegate = self;
    //we want all out fields
    //Note that the "*" for out fields is supported for geocode services of
    //ArcGIS Server 10 and above
    //NSArray *outFields = [NSArray arrayWithObject:@"*"];
    
    //for pre-10 ArcGIS Servers, you need to specify all the out fields:
    NSArray *outFields = [NSArray arrayWithObjects:@"Loc_name",
                          @"Shape",
                          @"Name",
                          @"Descr",
                          @"Latitude",
                          @"Longitude",
                          @"City",
                          @"State",
                          @"State_Abbr",
                          @"Country",
                          @"Cntry_Abbr",
                          @"Type",
                          nil];
    
    //Create the address dictionary with the contents of the search bar
    NSDictionary *addresses = [NSDictionary dictionaryWithObjectsAndKeys:self.searchBar.text, @"PlaceName", nil];
    
    //now request the location from the locator for our address
    [self.locator locationsForAddress:addresses returnFields:outFields];
}

#pragma mark -
#pragma mark AGSCalloutDelegate

- (void) didClickAccessoryButtonForCallout:(AGSCallout *) 	callout
{
    
    AGSGraphic* graphic = (AGSGraphic*) callout.representedObject;
    //The user clicked the callout button, so display the complete set of results
    ResultsViewController *resultsVC = [[ResultsViewController alloc] initWithNibName:@"ResultsViewController" bundle:nil];
    
    //set our attributes/results into the results VC
    resultsVC.results = [graphic allAttributes];
    
    //display the results vc modally
  //  [self presentModalViewController:resultsVC animated:YES];
    [self presentViewController:resultsVC animated:YES completion:nil];
    
	
}

#pragma mark -
#pragma mark AGSLocatorDelegate

- (void)locator:(AGSLocator *)locator operation:(NSOperation *)op didFindLocationsForAddress:(NSArray *)candidates
{
    //check and see if we didn't get any results
	if (candidates == nil || [candidates count] == 0)
	{
        //show alert if we didn't get results
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results"
                                                        message:@"No Results Found By Locator"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
	}
	else
	{
        //use these to calculate extent of results
        double xmin = DBL_MAX;
        double ymin = DBL_MAX;
        double xmax = -DBL_MAX;
        double ymax = -DBL_MAX;
        double xnew = DBL_MAX;
        double ynew = DBL_MAX;
		
		//create the callout template, used when the user displays the callout
		self.calloutTemplate = [[AGSCalloutTemplate alloc]init];
        
        
     
        
        
        
        //loop through all candidates/results and add to graphics layer
		for (int i=0; i<[candidates count]; i++)
		{
			AGSAddressCandidate *addressCandidate = (AGSAddressCandidate *)[candidates objectAtIndex:i];
            
            //get the location from the candidate
            AGSPoint *pt = addressCandidate.location;
           
         
            
            xnew = [WebMercatorUtil toWebMercatorX:pt.x];
            ynew = [WebMercatorUtil toWebMercatorY:pt.y];
            
            
            //accumulate the min/max
            if (xnew < xmin)
                xmin = xnew;
            
            if (xnew > xmax)
                xmax = xnew;
            
            if (ynew < ymin)
                ymin = ynew;
            
            if (ynew > ymax)
                ymax = ynew;
            
            
            AGSPoint *ptnew = [[AGSPoint alloc]initWithX:xnew y:ynew spatialReference:self.mapView.spatialReference];
            
        
            //pictureMarkerSymbolWithImageNamed:@"BluePushpin.png"
            
            
			//create a marker symbol to use in our graphic
            AGSPictureMarkerSymbol *marker = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"BluePushpin.png"];
            marker.offset = CGPointMake(9,16);
            marker.leaderPoint = CGPointMake(-9, 11);
            
            //set the text and detail text based on 'Name' and 'Descr' fields in the attributes
            self.calloutTemplate.titleTemplate = @"${Name}";
            self.calloutTemplate.detailTemplate = @"${Descr}";
			
            //create the graphic
			AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry: ptnew
																symbol:marker
															attributes:[addressCandidate.attributes mutableCopy]
                                                  infoTemplateDelegate:self.calloutTemplate];
            
            
            //add the graphic to the graphics layer
			[self.graphicsLayer addGraphic:graphic];
            
            if(self.graphicsLayer !=nil)
            {
          //  [self.mapView insertMapLayer:self.graphicsLayer atIndex:2];
                [self.mapView addMapLayer:self.graphicsLayer];
                
            }
            else{
                self.graphicsLayer = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
                [self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
                [self.graphicsLayer addGraphic:graphic];

            }
            
            
            
            [self.graphicsLayer setVisible:YES];
            
            if ([candidates count] == 1)
            {
                //we have one result, center at that point
                [self.mapView centerAtPoint:ptnew animated:NO];
                
				// set the width of the callout
				self.mapView.callout.width = 250;
                
                //show the callout
                [self.mapView.callout showCalloutAtPoint:(AGSPoint*)graphic.geometry forGraphic:graphic animated:YES];
            }
			
			//release the graphic bb
		}
        
        //if we have more than one result, zoom to the extent of all results
        int nCount = [candidates count];
        if (nCount > 1)
        {
            AGSMutableEnvelope *extent = [AGSMutableEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:self.mapView.spatialReference];
            [extent expandByFactor:1.5];
			[self.mapView zoomToEnvelope:extent animated:YES];
            
        }
	}
    
}

- (void)locator:(AGSLocator *)locator operation:(NSOperation *)op didFailLocationsForAddress:(NSError *)error
{
    //The location operation failed, display the error
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Locator Failed"
                                                    message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}



#pragma mark _
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	//hide the callout
	self.mapView.callout.hidden = YES;
	
    //First, hide the keyboard, then starGeocoding
    [searchBar resignFirstResponder];
    [self startGeocoding];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //hide the keyboard
    [self.searchBar resignFirstResponder];
}




- (IBAction)clearsearch {

if(self.graphicsLayer.visible == YES)
{
    self.graphicsLayer.visible=NO;
    
}
}


-(void) usertaponmeasure{
    




    [self.popOvertools dismissPopoverAnimated:YES];
    self.mapView.touchDelegate = self.sketchLayer;
    
    if(self.drawcanvas.hidden==NO){
        
        self.drawcanvas.hidden = YES;
        [self.graphicsLayerdraw removeAllGraphics];
        [self.drawcanvas backButtonClicked];

    }
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"Viewshed Calculator (radius 5km)"]){
        
        [self.gpOp cancel];
        self.gpOp = nil;
        
        //clear the graphics layer.
        [self.graphicsLayerviewshed removeAllGraphics];
        self.graphicsLayerviewshed.visible=NO;
        
     
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GPS"]){
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
              self.undobutton.title = @"Undo";
    }
    
    else if([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    {
        
        self.graphicsLayergeotag.visible=NO;
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.undobutton.enabled=NO;
        self.undobutton.title = @"Undo";
        
    }

    
    self.undobutton.enabled = NO;
    self.backbutton.enabled = NO;
    //self.eraseallbutton.enabled = NO;

  //  [self.mapView removeMapLayer:self.sketchLayer];
    if(self.sketchLayer !=nil)
    {
    
       // [self.mapView insertMapLayer:self.sketchLayer atIndex:1];
        [self.mapView addMapLayer:self.sketchLayer];
    }
    
    else{
        
        self.sketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
        [self.mapView addMapLayer:self.sketchLayer withName:@"Sketch layer"];
        self.mapView.touchDelegate = self.sketchLayer;


    }
    
    
        self.sketchLayer.visible=YES;
    
    
    self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToGeomChanged:) name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
    

}




- (void)respondToGeomChanged:(NSNotification*)notification {
    
    // Enable/Disable redo, undo, and add buttons
    self.undobutton.enabled = [self.sketchLayer.undoManager  canUndo];

    self.backbutton.enabled = ![self.sketchLayer.geometry isEmpty] && self.sketchLayer.geometry !=nil;
    
    
    // Update the distance and area whenever the geometry changes
   
        [self updateDistance];
  
}



- (void)updateDistance{
    
    
    
    // Get the sketch layer's geometry
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    // Get the geodesic distance of the current line
    _distance = [geometryEngine geodesicLengthOfGeometry:sketchGeometry inUnit:AGSSRUnitKilometer];

    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    
    if(_distance != 0){
           [self.drawmeasurelabel setTitle:[NSString stringWithFormat:@"%@  km", [formatter stringFromNumber:[NSNumber numberWithDouble:_distance]]] forState:UIControlStateNormal]; 
        
    }
    
    else{
        
        [self.drawmeasurelabel setTitle:@"Measure point to point" forState:UIControlStateNormal];

    }
    
    
}


-(void)usertaponviewshed{
    
    
    if(self.sketchLayer.visible==YES){
        
        [self.sketchLayer clear];
        
        self.sketchLayer.visible=NO;
        
        self.sketchLayer.geometry=nil;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
    }
    
    else if(self.drawcanvas.hidden==NO){
        
        self.drawcanvas.hidden = YES;
        [self.graphicsLayerdraw removeAllGraphics];
        [self.drawcanvas backButtonClicked];
        
    }
    
    
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GPS"]){
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
        self.undobutton.title = @"Undo";
        self.undobutton.enabled=NO;
    }
    
    
    else if([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    {
        
        self.graphicsLayergeotag.visible=NO;
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.undobutton.enabled=NO;
        self.undobutton.title = @"Undo";
        
    }
    
    
    if(self.graphicsLayerviewshed== nil)
    {
        self.graphicsLayerviewshed = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
    [self.mapView addMapLayer:self.graphicsLayerviewshed withName:@"Viewshed"];
    }
    else{
    
        self.graphicsLayerviewshed = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
        [self.mapView addMapLayer:self.graphicsLayerviewshed withName:@"Viewshed"];
        
    }
    
    

    self.graphicsLayerviewshed.visible=YES;
    
    [self.popOvertools dismissPopoverAnimated:YES];
    self.mapView.touchDelegate = (id)self;

    [self.drawmeasurelabel setTitle:@"Viewshed Calculator (radius 5km)" forState:UIControlStateNormal];
    self.backbutton.enabled = YES;
    
    self.gpTask = [AGSGeoprocessor geoprocessorWithURL:[NSURL URLWithString:kGPTask]];
	self.gpTask.delegate = (id)self; //required to respond to the gp response.
	self.gpTask.processSpatialReference = self.mapView.spatialReference;
	self.gpTask.outputSpatialReference = self.mapView.spatialReference;
    
    
}
-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    
    
    AGSGeometryEngine *ge = [AGSGeometryEngine defaultGeometryEngine];
    AGSGeometry *mapcoordinates = [ge projectGeometry:mappoint toSpatialReference: [AGSSpatialReference wgs84SpatialReference]];

    AGSPoint *newmap = (AGSPoint *)mapcoordinates;

    
    NSString *string1= [NSString stringWithFormat:@"%.3f",newmap.x];
    NSString *string2 = [NSString stringWithFormat:@"  %.3f",newmap.y];
    self.mapcoords.text = [string1 stringByAppendingString:string2];
    
    

    
    if([self.drawmeasurelabel.titleLabel.text isEqualToString:@"Viewshed Calculator (radius 5km)"] && self.graphicsLayerviewshed!=nil){
        
    
    
    //clearing the graphic layer before any update.
	[self.graphicsLayerviewshed removeAllGraphics];
    
    //adding a simple marker to the view point on the map.
	AGSSimpleMarkerSymbol *myMarkerSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.25]];
    [myMarkerSymbol setSize:CGSizeMake(10,10)];
    [myMarkerSymbol setOutline:[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:1]];
    
    //create a graphic
	AGSGraphic *agsGraphic = [AGSGraphic graphicWithGeometry:mappoint symbol:myMarkerSymbol attributes:nil infoTemplateDelegate:nil];
    
    //add graphic to graphics layer
	[self.graphicsLayerviewshed addGraphic:agsGraphic];
    
	//creating a feature set for the input pareameter for the GP.
	AGSFeatureSet *featureSet = [[AGSFeatureSet alloc] init];
	featureSet.features = [NSArray arrayWithObjects:agsGraphic, nil];
	
    //create input parameter
	AGSGPParameterValue *paramloc = [AGSGPParameterValue parameterWithName:@"Input_Observation_Point" type:AGSGPParameterTypeFeatureRecordSetLayer value:featureSet];
    
    //creating the linear unit distance parameter for the GP.
    AGSGPLinearUnit *vsDistance = [[AGSGPLinearUnit alloc] init];
    vsDistance.distance = 5;
    vsDistance.units = AGSUnitsKilometers;
    
    //create input parameter
	AGSGPParameterValue *paramdt = [AGSGPParameterValue parameterWithName:@"Viewshed_Distance" type:AGSGPParameterTypeLinearUnit value:vsDistance];
    
    //add parameters to param array
	NSArray *params = [NSArray arrayWithObjects:paramloc, paramdt, nil];
    
	//execute the GP task with parameters - synchrounously.
	self.gpOp = [self.gpTask executeWithParameters:params]; // keep track of the gp operation so that we can cancel it if user wants.
    
    //showing activity indicator
    [self.activityAlertView show];
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    
    
    
{
        
        if(self.calloutTemplate1 ==nil)
        self.calloutTemplate1 = [[AGSCalloutTemplate alloc]init];

        AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];

    
        
        AGSSimpleMarkerSymbol *myMarkerSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.25]];
        [myMarkerSymbol setSize:CGSizeMake(10,10)];
        [myMarkerSymbol setOutline:[AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor redColor] width:1]];
       
        
            
            
            
        //create a graphic
        AGSGraphic *agsGraphic1 = [AGSGraphic graphicWithGeometry:mappoint symbol:myMarkerSymbol attributes:nil infoTemplateDelegate:self.calloutTemplate1];
        
        
        //add graphic to graphics layer
        
        if([collectionpopups count] != 0)
    {
           // NSMutableArray *tempcountpopups = [[NSMutableArray alloc]init];
            
            for ( int  i = 0; i<[collectionpopups count];i++)
            
            
    {
        AGSGraphic* agsgraph =    [collectionpopups objectAtIndex:i];

        //            if([agsgraph.geometry.envelope containsPoint:(AGSPoint *)agsGraphic1.geometry])

    if([geometryEngine distanceFromGeometry:agsGraphic1.geometry toGeometry:agsgraph.geometry]<200)
        {
            if([collectiontagimages count]>0)
            {
                for(int k = 0; k <[collectiontagimages count]; k++)
                {
                    
                    if([[collectiontagimages objectAtIndex:k] isKindOfClass:[AGSPoint class]])
                    {
                        
                        AGSPoint *temppoint = [collectiontagimages objectAtIndex:k];
                    
                    if([geometryEngine distanceFromGeometry:temppoint toGeometry:agsGraphic1.geometry]<200)
                        {
                            [self.viewcontroller.imageView setImage:[collectiontagimages objectAtIndex:(k-1)]];
                            self.mapView.callout.customView =self.viewcontroller.view;
                        
                            [self.mapView.callout showCalloutAt:(AGSPoint *)agsgraph.geometry pixelOffset:CGPointZero animated:YES];
                            _alreadypresentpointtouched = YES;
                            _alreadypresentpointtouched1 = YES;

                        }
                    
                    }
                
                }

            }
                
            if(_alreadypresentpointtouched1 == NO){
                
                self.mapView.callout.customView =self.viewcontroller.view;
                
                [self.mapView.callout showCalloutAt:(AGSPoint *)agsgraph.geometry pixelOffset:CGPointZero animated:YES];
                
         //       self.viewcontroller.Photooalbum.enabled = YES;
           //     self.viewcontroller.Cameraa.enabled = YES;
                
                
                 _alreadypresentpointtouched = YES;
                
                
                }
            
            else if (_alreadypresentpointtouched1 == YES)
            {
                _alreadypresentpointtouched1 = NO;
            }
                

                
//        self.mapView.touchDelegate = nil;

            }
   
    }
        
        
        if(_alreadypresentpointtouched == NO)
        {
            
            [self.graphicsLayergeotag addGraphic:agsGraphic1];
            
            
            self.mapView.callout.customView =self.viewcontroller.view;
            
            [self.mapView.callout showCalloutAt:mappoint pixelOffset:CGPointZero animated:YES];
            
            
            
            [collectionpopups addObject:agsGraphic1];
            
            pointtagged = mappoint;
            
            self.viewcontroller.Photooalbum.enabled = YES;
            self.viewcontroller.Cameraa.enabled = YES;
        }
        
        else{
            
            
            _alreadypresentpointtouched = NO;
        }
            
            
       
    
    
//            if([tempcountpopups count] !=0)
//            {
//                [collectionpopups addObjectsFromArray:tempcountpopups];
//                [tempcountpopups removeAllObjects];
//            }


    }


     else{
            
            
            
            [self.graphicsLayergeotag addGraphic:agsGraphic1];
            
            
            self.mapView.callout.customView =self.viewcontroller.view;
            
            [self.mapView.callout showCalloutAt:mappoint pixelOffset:CGPointZero animated:YES];
            
            
            [collectionpopups addObject:agsGraphic1];
            
         pointtagged = mappoint;
         
        }
        
        //[self.mapView.callout showCalloutAtPoint:mappoint forGraphic:agsGraphic1 animated:YES];

        

        
      //  [self.mapView.callout showCalloutAt:mappoint pixelOffset:CGPointZero animated:YES];

      //  [self.mapView.callout showCalloutAtPoint:mappoint forGraphic:agsGraphic1 animated:YES];
        
    }
    
    
    
}



#pragma mark GeoprocessorDelegate

//this is the delegate method that getscalled when gp task completes successfully.
-(void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op didExecuteWithResults:(NSArray *)results messages:(NSArray *)messages{
    
	if (results != nil && [results count] > 0) {
		
		//get the first result
		AGSGPParameterValue *result = [results objectAtIndex:0];
		AGSFeatureSet *fs = result.value;
		
		//loop through all graphics in feature set and add them to map
		for(AGSGraphic *graphic in fs.features){
			
			//create and set a symbol to graphic
			AGSSimpleFillSymbol *fillSymbol = [AGSSimpleFillSymbol simpleFillSymbol];
			fillSymbol.color = [[UIColor purpleColor] colorWithAlphaComponent:0.25];
			graphic.symbol = fillSymbol;
			
			//add graphic to graphics layer
			[self.graphicsLayerviewshed addGraphic:graphic];
            [self.graphicsLayerviewshed setInitialEnvelope:graphic.geometry.envelope];
		}
        
		//stop activity indicator
		[self.activityAlertView close];
		
		//zoom to graphics layer extent
        
		AGSMutableEnvelope *env = [self.graphicsLayerviewshed.initialEnvelope mutableCopy];

		[env expandByFactor:8];
		[self.mapView zoomToEnvelope:env animated:YES];
	}
    
}

//if there's an error with the gp task give info to user
-(void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op didFailExecuteWithError:(NSError *)error{
    
    //stop activity indicator
    [self.activityAlertView close];
    
    //show error message
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //cancel the operation
    [self.gpOp cancel];
    self.gpOp = nil;
    
    //clear the graphics layer.
    [self.graphicsLayerviewshed removeAllGraphics];
}



-(void)usertapongps{
    
    
    
    
    if(self.sketchLayer.visible==YES){
        
        [self.sketchLayer clear];
        
        self.sketchLayer.visible=NO;
        
        self.sketchLayer.geometry=nil;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
    }
    
   else if(self.drawcanvas.hidden==NO){
        
        self.drawcanvas.hidden = YES;
        [self.graphicsLayerdraw removeAllGraphics];
        [self.drawcanvas backButtonClicked];
        
    }
   else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"Viewshed Calculator (radius 5km)"]){
       
       [self.gpOp cancel];
       self.gpOp = nil;
       
       //clear the graphics layer.
       [self.graphicsLayerviewshed removeAllGraphics];
       self.graphicsLayerviewshed.visible=NO;
       
       
   }
    
   else if([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
   {
       
       self.graphicsLayergeotag.visible=NO;
       self.backbutton.enabled = NO;
       [self.mapView.callout dismiss];
       self.undobutton.enabled=NO;
       self.undobutton.title = @"Undo";
       
   }
    

    [self.popOvertools dismissPopoverAnimated:YES];

    
    [self.drawmeasurelabel setTitle:@"GPS" forState:UIControlStateNormal];
    
    [self.mapView.locationDisplay setAlpha:1.0];
    [self.mapView centerAtPoint:[self.mapView.locationDisplay mapLocation] animated:YES];

    [self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    self.undobutton.enabled=YES;
    self.backbutton.enabled=YES;
    self.undobutton.title=@"Start";

    //setting the geometry of the gps sketch layer to polyline.

    

    if(self.gpsSketchLayer != nil)
    {
    //[self.mapView insertMapLayer:self.gpsSketchLayer atIndex:2];
        
        [self.mapView addMapLayer:self.gpsSketchLayer];
        
   
        
    }
    else{
        
        self.gpsSketchLayer = [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil];
        [self.mapView addMapLayer:self.gpsSketchLayer withName:@"GPS Sketch layer"];
    }
    self.gpsSketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
    
    
   // [self.mapView addMapLayer:self.gpsSketchLayer];
    
    self.gpsSketchLayer.visible=YES;
    //set the midvertex symbol to nil to avoid the default circle symbol appearing in between vertices
    self.gpsSketchLayer.midVertexSymbol = nil;
}


- (IBAction)stopGPSSketching
{
    
    //stop the CLLocation manager from sending updates.
    [self.locationManager stopUpdatingLocation];
    
    //change the button title back to Start
    self.undobutton.title = @"Start";
    
    [self.undobutton setAction:@selector(undobutton:)];
    
}

//helper methods for location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    //add the present gps point to the sketch layer. Notice that we do not have to reproject this point as the mapview's gps object is returing the point in the same spatial reference.
    //index -1 forces the vertex to be added at the end
    [self.gpsSketchLayer insertVertex:[self.mapView.locationDisplay mapLocation] inPart:0 atIndex:-1];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    //stop the location manager and set the delegate to nil;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}
#pragma mark BasemapDelegate
-(void)zeromap:(NSString *)basemapstring{
    
    
   [self.popOverbasemap dismissPopoverAnimated:YES];
    
    if(![prebasemap isEqualToString:basemapstring])
    {
        prebasemap = basemapstring;
    
        [self.mapView removeMapLayerWithName:@"Basemap"];

        
        
        
        //open the webmap
    
        if([basemapstring isEqualToString:@"hybrid bing"]){
               AGSBingMapLayer *bingbasemap =[[AGSBingMapLayer alloc]initWithAppID:bingkey style:AGSBingMapLayerStyleAerialWithLabels];
            
            
            
            if([self ctoi]==YES)
            {
                
                
                [self.mapView insertMapLayer:bingbasemap withName:@"Basemap" atIndex:([self.webMap isLoaded]?1:0)];
            }
            else{
                
                [self.internetAlertView show];

                
            }
            
            
        }
        else if([basemapstring isEqualToString:@"street bing"]){
            AGSBingMapLayer *bingbasemap =[[AGSBingMapLayer alloc]initWithAppID:bingkey style:AGSBingMapLayerStyleRoad];
            
            
            
            if([self ctoi]==YES)
            {
                [self.mapView insertMapLayer:bingbasemap withName:@"Basemap" atIndex:([self.webMap isLoaded]?1:0)];
            }
            else{
                
                [self.internetAlertView show];

            }
            
            
            
        }
        else if([basemapstring isEqualToString:@"aerial bing"]){
            
              AGSBingMapLayer *bingbasemap =[[AGSBingMapLayer alloc]initWithAppID:bingkey style:AGSBingMapLayerStyleAerial];
            
            
            
            if([self ctoi]==YES)
            {
                [self.mapView insertMapLayer:bingbasemap withName:@"Basemap" atIndex:([self.webMap isLoaded]?1:0)];
            }
            else{
                
                [self.internetAlertView show];

                
            }
            
            
        }
        else if([basemapstring isEqualToString:@"OSM mapnik"]){
            
            
            AGSOpenStreetMapLayer *osmbasemap=[[AGSOpenStreetMapLayer alloc]init];
            
            
            
            if([self ctoi]==YES)
            {
                [self.mapView insertMapLayer:osmbasemap withName:@"Basemap" atIndex:([self.webMap isLoaded]?1:0)];
            }
            else{
                
                [self.internetAlertView show];

                
            }
        
        }
        else if([basemapstring isEqualToString:@"default map"]){
            
            if([self.mapView mapLayerForName:@"Basemap"] != Nil){
            
            [self.mapView removeMapLayerWithName:@"Basemap"];
                

            }
            
            if(_mapfail == 1)
            {
                
                [self openDefaultWebMap];
                _mapfail = 0;
                
            }
            
            
            
            
        }
        
        
        
        else{
            
        
    NSURL *serviceUrl = [NSURL URLWithString:basemapstring];
      AGSTiledMapServiceLayer *tiledMapServiceLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:serviceUrl];

            
      
            
            if([self ctoi]==YES)
            {
            [self.mapView insertMapLayer:tiledMapServiceLayer withName:@"Basemap" atIndex:([self.webMap isLoaded]?1:0)];
                
                

            }
            else{
              
                        
                        [self.internetAlertView show];
                 
                
            
            }
            
        }
      
        
    }
    
    else{
        
        //do nothing
        
    }
    
}

-(void)usertapongeotag{
    
    
    
    
    if(self.sketchLayer.visible==YES){
        
        [self.sketchLayer clear];
        
        self.sketchLayer.visible=NO;
        
        self.sketchLayer.geometry=nil;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
    }
    
    else if(self.drawcanvas.hidden==NO){
        
        self.drawcanvas.hidden = YES;
        [self.graphicsLayerdraw removeAllGraphics];
        [self.drawcanvas backButtonClicked];
        
    }
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"Viewshed Calculator (radius 5km)"]){
        
        [self.gpOp cancel];
        self.gpOp = nil;
        
        //clear the graphics layer.
        [self.graphicsLayerviewshed removeAllGraphics];
        self.graphicsLayerviewshed.visible=NO;
        
        
    }
    
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GPS"]){
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
        self.undobutton.title = @"Undo";
        self.undobutton.enabled=NO;
    }
    
    
    
    
    
    
    if(self.graphicsLayergeotag == nil)
        
    {
        
        //add  graphics layer for showing results of the viewshed calculation
        self.graphicsLayergeotag = [AGSGraphicsLayer graphicsLayer];
        [self.mapView addMapLayer:self.graphicsLayergeotag withName:@"geotag"];
        
    }
    
    
    
    if(self.viewcontroller == nil)
    self.viewcontroller = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    self.viewcontroller.delegate=self;


    self.undobutton.title =@"Remove Log";
    
    self.undobutton.enabled = YES;
    
    
    [self.drawmeasurelabel setTitle:@"GeoTag Photos" forState:UIControlStateNormal];


  //  [self.mapView insertMapLayer:self.graphicsLayergeotag atIndex:(self.mapView.mapLayers.count+1)];
    if(self.graphicsLayergeotag != nil){
    [self.mapView addMapLayer:self.graphicsLayergeotag];
    }
    else{
        self.graphicsLayergeotag = [AGSSketchGraphicsLayer graphicsLayer];  //humza changed
        [self.mapView addMapLayer:self.graphicsLayergeotag withName:@"geotag"];
    }
    
    
    
    
    
    self.graphicsLayergeotag.visible=YES;
    
    
    [self.popOvertools dismissPopoverAnimated:YES];
    
   self.mapView.touchDelegate = (id)self;

    
    
    self.backbutton.enabled = YES;
    
    
}

-(void) photosaved:(UIImage *)picture{
    
    [collectiontagimages addObject:picture];
    [collectiontagimages addObject:pointtagged];
    

}


-(void) cancelingeotagpressed{
    
    [self.mapView.callout dismiss];
    self.viewcontroller.Cameraa.enabled = NO;
    self.viewcontroller.Photooalbum.enabled=NO;
    
}



-(void) usertaponremlayer{
    
    self.desViewController = nil;
    self.basemapsshow = nil;
    [self.popOvertools dismissPopoverAnimated:YES];
  
    if([self ctoi] == YES)
    {
        if(self.basemapsbutton.enabled == NO)
        {
            self.basemapsbutton.enabled = YES;
            self.searchBar.placeholder =@"Search the world using GeoPad";
        }
        
    }
  

    
    if(self.drawcanvas.hidden==NO){
        
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        
        
        self.eraseallbutton.enabled = NO;
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;

        
        self.drawcanvas.hidden = YES;
        [self.graphicsLayerdraw removeAllGraphics];
        [self.drawcanvas backButtonClicked];
        
    }
    else if(self.sketchLayer.visible==YES){
        
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        
        [self.sketchLayer clear];
        
        self.sketchLayer.geometry=nil;
        self.sketchLayer.visible=NO;
        
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        
        self.backbutton.enabled = NO;
        self.undobutton.enabled = NO;
        
        self.mapView.touchDelegate = nil;
        
        
        
    }
    
    
    else if (self.graphicsLayerviewshed.visible==YES){
        
        
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        [self.gpOp cancel];
        self.gpOp = nil;
        
        //clear the graphics layer.
        [self.graphicsLayerviewshed removeAllGraphics];
        self.graphicsLayerviewshed.visible=NO;
        
        self.backbutton.enabled = NO;
        self.graphicsLayerviewshed=nil;
        
        self.mapView.touchDelegate = nil;
        
        
    }
    
    
    else if (self.gpsSketchLayer.visible==YES){
        
        [self.locationManager stopUpdatingLocation];
        [self.mapView.locationDisplay setAlpha:0.0];
        
        self.locationManager.delegate = nil;
        self.gpsSketchLayer.visible=NO;
        self.gpsSketchLayer.geometry =nil;
        self.backbutton.enabled = NO;
        [self.drawmeasurelabel setTitle:@"" forState:UIControlStateNormal];
        self.undobutton.enabled = NO;
        self.undobutton.title=@"Undo";
    }
    
    
    else if ([self.drawmeasurelabel.titleLabel.text isEqualToString:@"GeoTag Photos"])
    {
        self.graphicsLayergeotag.visible=NO;
        
        self.backbutton.enabled = NO;
        [self.mapView.callout dismiss];
        self.mapView.callout.customView = nil;
        
        self.drawmeasurelabel.titleLabel.text =@"";
        self.undobutton.enabled=NO;
        self.undobutton.title = @"Undo";
    }

    self.mapView.touchDelegate = (id)self;
    [self openDefaultWebMap];
   // [self.mapView addMapLayer:self.sketchLayer];//:self.sketchLayer atIndex:1];
}



-(void) usertaponlegend{
    
    
    if(!self.popOverControllerl) {
        self.popOverControllerl = [[UIPopoverController alloc] initWithContentViewController:self.tocViewController];
        self.tocViewController.popOverController = self.popOverControllerl;
        self.popOverControllerl.popoverContentSize = CGSizeMake(320, 500);
       // self.popOverControllerl.passthroughViews = [NSArray arrayWithObject:self.mapView];
    
    }
    CGRect aFrame = [self.toolsD.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [_popOverControllerl presentPopoverFromRect:[self.toolsD.tableView convertRect:aFrame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


-(void) usertaponoffline{

 //   [self.popOvertools dismissPopoverAnimated:YES];

    self.offlineViewController.delegate =self;
    
    if(!self.popOvercontrollero) {
        self.popOvercontrollero = [[UIPopoverController alloc] initWithContentViewController:self.offlineViewController];
        //self.tocViewController.popOverController = self.popOvercontrollero;
        self.popOvercontrollero.popoverContentSize = CGSizeMake(220, 300);
        // self.popOverControllerl.passthroughViews = [NSArray arrayWithObject:self.mapView];
        
    }
    CGRect aFrame = [self.toolsD.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    [_popOvercontrollero presentPopoverFromRect:[self.toolsD.tableView convertRect:aFrame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

-(void)usertaponoffmap:(NSString *)tilePackage{
    
    [self.popOvercontrollero dismissPopoverAnimated:YES];
    [self.popOvertools dismissPopoverAnimated:YES];
    
    self.localTiledLayer = [AGSLocalTiledLayer localTiledLayerWithName:tilePackage];
    
    
	//If layer was initialized properly, add to the map
	if(self.localTiledLayer != nil){
    
      if(self.mapView.spatialReference != self.localTiledLayer.spatialReference)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"The spatial reference of the selected map doesnot match the spatial reference of the basemap"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        
            
            
            
           
            self.basemapsbutton.enabled = NO;
            self.searchBar.placeholder =@"Will not show accurate results because selected map has a different spatial reference than the original basemap";
            
            [self.mapView reset];
            //_mapfail = 1;
            
            [self.mapView addMapLayer:self.localTiledLayer withName:@"Local Tiled Layer"];
            
            [self.localTiledLayer setVisible:YES];
            
            AGSEnvelope *env = [self.localTiledLayer fullEnvelope];
            [self.mapView zoomToEnvelope:env animated:YES];
            
            [self intoolswithoutinwebmap];

            
        }
        
        else{
            
        
        
        if([self ctoi] == YES)
        {
            //[self.mapView reset];
            //_mapfail = 1;
            
            [self.mapView addMapLayer:self.localTiledLayer withName:@"Local Tiled Layer"];

            [self.localTiledLayer setVisible:YES];
            
            AGSEnvelope *env = [self.localTiledLayer fullEnvelope];
            [self.mapView zoomToEnvelope:env animated:YES];
        
            
        }
        else{
            
        [self.mapView addMapLayer:self.localTiledLayer withName:@"Local Tiled Layer"];
        AGSEnvelope *env = [self.localTiledLayer fullEnvelope];
            [self.mapView zoomToEnvelope:env animated:YES];
        [self intoolswithoutinwebmap];
        }
        
    }
    
    }
    
}

-(void)intoolswithoutinwebmap{
    
    
    if(self.sketchLayer ==nil)
    {
        
        self.sketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
        self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
        [self.mapView addMapLayer:self.sketchLayer withName:@"Sketch layer"];
        self.sketchLayer.visible=NO;
    }
    
    if(self.graphicsLayer ==nil)
    {
        self.graphicsLayer = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
        [self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    }
    
    if(self.graphicsLayerviewshed == nil)
        
    {
        
        //add  graphics layer for showing results of the viewshed calculation
        self.graphicsLayerviewshed = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
        [self.mapView addMapLayer:self.graphicsLayerviewshed withName:@"Viewshed"];
        self.graphicsLayerviewshed.visible=NO;
        
    }
    
    
    //setting up the alert view to show th ebusy indicator.
    self.activityAlertView = [[ActivityAlertView alloc]
                              initWithTitle:@"Calculating Viewshed..."
                              message:@"\n\n"
                              delegate:self cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil];
    
    
    
    if(self.graphicsLayerdraw == nil)
    {
        self.graphicsLayerdraw = [AGSSketchGraphicsLayer graphicsLayer]; //humza changed
        [self.mapView addMapLayer:self.graphicsLayerdraw withName:@"Graphics Layer Draw"];
    }
    // Once all the layers in web map are loaded
    // Add AGSGraphicslayer on top
    //    NSLog(@"%@",self.mapView);
    
    if(self.gpsSketchLayer==nil)
    {
        self.gpsSketchLayer = [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil];
        [self.mapView addMapLayer:self.gpsSketchLayer withName:@"GPS Sketch layer"];
        self.gpsSketchLayer.visible=NO;
    }
    
    if(self.graphicsLayergeotag == nil)
        
    {
        
        //add  graphics layer for showing results of the viewshed calculation
        self.graphicsLayergeotag = [AGSSketchGraphicsLayer graphicsLayer];  //humza changed
        [self.mapView addMapLayer:self.graphicsLayergeotag withName:@"geotag"];
        self.graphicsLayergeotag.visible=NO;
        
    }
    
    
    
    
   // [self.internetAlertView close];
    
    
    //  self.ToolsButton.enabled=YES;
    
    
    
    
    //
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *) self.mapView.layer;
    
    eaglLayer.drawableProperties = @{
                                     kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:YES],
                                     kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
                                     };
    
    
    
    
    
    
}




-(void) usertaponmapdes{
    
 
    

    
  //  self.desViewController.mapdescriptionview.text = @"";
    if(self.desViewController != nil)
    {
    
 
    
    
    
    [self.desViewController processurl];
    
    if(!self.popOverdes) {
        self.popOverdes = [[UIPopoverController alloc] initWithContentViewController:self.desViewController];
        self.popOverdes.popoverContentSize = CGSizeMake(220, 400);
        
    }
    CGRect aFrame = [self.toolsD.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    [_popOverdes presentPopoverFromRect:[self.toolsD.tableView convertRect:aFrame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    
    else{
        
        self.desViewController = [[DescriptionViewController alloc] initWithMapView:self.mapView];

        
        [self.desViewController processurl];
        
        if(!self.popOverdes) {
            self.popOverdes = [[UIPopoverController alloc] initWithContentViewController:self.desViewController];
            self.popOverdes.popoverContentSize = CGSizeMake(220, 400);
            
        }
        CGRect aFrame = [self.toolsD.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        [_popOverdes presentPopoverFromRect:[self.toolsD.tableView convertRect:aFrame toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    
    
}



@end
