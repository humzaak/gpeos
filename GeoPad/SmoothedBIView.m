#import "SmoothedBIView.h"
#include <ArcGIS/ArcGIS.h>
#include "RootViewController.h"


@implementation SmoothedBIView
{
    UIBezierPath *path; // (3)
    NSMutableArray *countpaths;
    int temp1;
    
}

@synthesize undoSteps;
@synthesize location=_location;
@synthesize newlocation=_newlocation;
@synthesize polylinedraw=_polylinedraw;
@synthesize myPath = _myPath;
@synthesize tempArray=_tempArray;
@synthesize countArray=_countArray;





- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        
        pathArray=[[NSMutableArray alloc]init];
        bufferArray=[[NSMutableArray alloc]init];
        self.tempArray =[[NSMutableArray alloc]init];
        countpaths = [[NSMutableArray alloc]init];
        self.countArray=0;
        temp1 = 0;
        
        
       
  //      CGRect mapdraw = CGRectMake(0.0f, 88.0f, 768.0f, 872.0f);
        
        
   //    BImapview = [[AGSMapView alloc]initWithFrame:mapdraw];
    //    self.polylinedraw =[[AGSMutablePolyline alloc]init];

      //  NSLog(@"%@",BImapview);
        
        
        
       // NSLog(@"%@ rooti",rooti.mapView);
        
//     self.polylinedraw = [[AGSMutablePolyline alloc]initWithSpatialReference:rooti.mapView.spatialReference];
        
    //    [self.polylinedraw addPathToPolyline];
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect // (4)
{
    [[UIColor redColor] setStroke];
    for (UIBezierPath *_path in pathArray)
        [_path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];


}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.myPath=[[UIBezierPath alloc]init];
    self.myPath.lineWidth=2.0;
    

    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];

    self.location = [mytouch locationInView:self];
    [self.tempArray addObject:[NSValue valueWithCGPoint:self.location]];
    
    self.countArray=self.countArray+1;
    temp1 = temp1+1;
    
    
    //NSLog(@"%@",[self.tempArray objectAtIndex:0]);
    
 // AGSPoint *mappoint = [BImapview toMapPoint:self.location];
    
  // [self.polylinedraw addPointToPath:mappoint];
        
    [self.myPath moveToPoint:self.location];
    [pathArray addObject:self.myPath];

    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    self.newlocation = [mytouch locationInView:self];
    
 //      AGSPoint *mappoint = [BImapview toMapPoint:self.newlocation];
    
   // [self.polylinedraw addPointToPath:mappoint];

    [self.myPath addLineToPoint:self.newlocation];
    
    [self.tempArray addObject:[NSValue valueWithCGPoint:self.newlocation]];

    
    [self setNeedsDisplay];

    
    self.countArray=self.countArray+1;
    temp1 = temp1+1;
    



}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    NSNumber *foo = [NSNumber numberWithInteger:temp1];

    [countpaths addObject:foo];
    temp1 =0;

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];

}


-(void)undoButtonClicked
{
    
    
    
    if([pathArray count]>0){
        UIBezierPath *_path=[pathArray lastObject];
        [bufferArray addObject:_path];
        [pathArray removeLastObject];
       
        [self setNeedsDisplay];
    }
    
    
    NSNumber *num1 = [countpaths lastObject];

    
    for (int i = 0;i<[num1 intValue];i++){
        
        if([self.tempArray count]>0)
            [self.tempArray removeLastObject];
    }
  
    
    
}

-(void)backButtonClicked
{
    

    
    if([pathArray count]>0){

        [pathArray removeAllObjects];
        [self setNeedsDisplay];
    }
    
    for (int i = 0;i<self.countArray;i++){
        
        if([self.tempArray count]>0)
            [self.tempArray removeLastObject];
    }
    self.countArray = 0;
}



@end


