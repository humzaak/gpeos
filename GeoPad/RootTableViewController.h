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
#include <ArcGIS/ArcGIS.h>

//    NSString *tilePackage;

@protocol Roottabledelegate <NSObject>

-(void) usertaponoffmap:(NSString *)tilePackage;


@end


@interface RootTableViewController : UITableViewController


@property (nonatomic, weak) id <Roottabledelegate> delegate;


@end
