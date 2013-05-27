//
//  BasemapsViewController.h
//  
//
//  Created by GeoTouch on 1/2/13.
//
//

#import <UIKit/UIKit.h>


@protocol Basemapdelegate <NSObject>

-(void) zeromap:(NSString *)basemapstring;

@end

@interface BasemapsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *basemaplayout;

@property (nonatomic, weak) id <Basemapdelegate> delegate1;


    @end
