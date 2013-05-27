//
//  DescriptionViewController.m
//  GeoPad
//
//  Created by GeoTouch on 13/5/13.
//
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

@synthesize mapviewurl = _mapviewurl;
@synthesize currentJsonOp = _currentJsonOp;
@synthesize queue =_queue;
@synthesize mapdescriptionview =_mapdescriptionview;
@synthesize mapdeslabel = _mapdeslabel;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//    }
//    return self;
//}


- (id) initWithMapView:(AGSMapView *)mapView{
    self = [super initWithNibName:@"DescriptionViewController" bundle:nil];
    if (self) {
        self.mapviewurl = mapView;
    }
    return self;
}

-(void) processurl{
    
    self.queue = [[NSOperationQueue alloc] init];
    [self geturl:self.mapviewurl];

}


-(void) geturl:(AGSMapView *)mapView{
    
  
        
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSURL* url = NULL;
    NSURL * newurl = NULL;
    NSString * JSON = @"?f=pjson";

if(mapView != NULL)
{
    
    
    for( AGSLayer *layer1 in mapView.mapLayers)
    {
        
        if([layer1 isKindOfClass:[AGSFeatureLayer class]])
        {
            AGSFeatureLayer* layer = (AGSFeatureLayer*)layer1;
            url = layer.URL;
            url = [url URLByDeletingLastPathComponent];
            NSString *myString = [url absoluteString];
            newurl = [NSURL URLWithString:[myString stringByAppendingString:JSON]];
            
            
           // NSLog(@"%@",newurl);
            
            
            self.currentJsonOp = [[AGSJSONRequestOperation alloc]initWithURL:newurl queryParameters:params];
            self.currentJsonOp.target = self;
            self.currentJsonOp.action = @selector(operation:didSucceedWithResponse:);
            self.currentJsonOp.errorAction = @selector(operation:didFailWithError:);
            [self.queue addOperation:self.currentJsonOp];
            
            
        
            
            
            
        }
        
        
        else if ([layer1 isKindOfClass:[AGSTiledMapServiceLayer class]]){
            
            AGSTiledMapServiceLayer* layer = (AGSTiledMapServiceLayer*)layer1;
            url = layer.URL;
            url = [url URLByDeletingLastPathComponent];

            NSString *myString = [url absoluteString];
            newurl = [NSURL URLWithString:[myString stringByAppendingString:JSON]];
            
            
            self.currentJsonOp = [[AGSJSONRequestOperation alloc]initWithURL:newurl queryParameters:params];
            self.currentJsonOp.target = self;
            self.currentJsonOp.action = @selector(operation:didSucceedWithResponse:);
            self.currentJsonOp.errorAction = @selector(operation:didFailWithError:);
            [self.queue addOperation:self.currentJsonOp];
            
            
            
            
        }
        
      
    }
}
    
    
}

- (void)operation:(NSOperation*)op didSucceedWithResponse:(NSDictionary *)mapdes {

    

	if([mapdes objectForKey:@"serviceDescription"]!=nil){
		NSString* mapd = [mapdes objectForKey:@"serviceDescription"];
    
        self.mapdeslabel.text = mapd;
        
	}
    if([mapdes objectForKey:@"description"]!=nil){
		NSString* mapd = [mapdes objectForKey:@"description"];
        
    [self.mapdescriptionview setText:mapd];
    }
    

}


- (void)operation:(NSOperation*)op didFailWithError:(NSError *)error {
	//Error encountered while invoking webservice. Alert user
	
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
