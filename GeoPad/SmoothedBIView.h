//
//  SmoothedBIView.h
//  FreehandDrawingTut
//
//  Created by A Khan on 12/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>




@interface SmoothedBIView : UIView{
    
    
    NSMutableArray *pathArray;
    NSMutableArray *bufferArray;

    AGSMapView *BImapview;

    
}



@property(nonatomic,assign) NSInteger undoSteps;
@property(nonatomic,readwrite) CGPoint location;
@property(nonatomic,readwrite)CGPoint newlocation;
@property(nonatomic,readwrite)AGSMutablePolyline *polylinedraw;
@property(nonatomic,readwrite)UIBezierPath *myPath;
@property(nonatomic,readwrite)NSMutableArray *tempArray;
@property (nonatomic,readwrite)int countArray;



-(void)undoButtonClicked;
-(void)backButtonClicked;




@end
