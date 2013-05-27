//
//  ViewController.h
//  CustomCalloutSample
//
//  Created by GeoTouch on 11/3/13.
//
//

#import <UIKit/UIKit.h>
#import "OverleyViewController.h"


@protocol PhotoViewControllerDelegate;



@interface ViewController : UIViewController <UIImagePickerControllerDelegate,OverleyViewControllerDelegate>
@property (nonatomic, assign) id <PhotoViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *Photooalbum;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *Cameraa;
@property (nonatomic, retain) NSMutableArray *capturedImages;
@property (nonatomic, retain) NSMutableArray *collectionImages;

@end


@protocol PhotoViewControllerDelegate
- (void)photosaved:(UIImage *)picture;
- (void)cancelingeotagpressed;
@end
