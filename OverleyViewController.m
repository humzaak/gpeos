

#import "OverleyViewController.h"


@interface OverleyViewController ( )


@property (nonatomic, retain) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;



// camera page (overlay view)
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;


@end

@implementation OverleyViewController

@synthesize delegate=_delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)viewDidUnload
{
    self.takePictureButton = nil;
    self.cancelButton = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
   
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = YES
        ;
        
        

//
//        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
//        {
//            // setup our custom overlay view for the camera
//            //
//            // ensure that our custom view's frame fits within the parent frame
//            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
//            CGRect newFrame = CGRectMake(0.0,
//                                         CGRectGetHeight(overlayViewFrame) -
//                                         self.view.frame.size.height,
//                                         CGRectGetWidth(overlayViewFrame),
//                                         self.view.frame.size.height);
//            self.view.frame = newFrame;
//            [self.imagePickerController.cameraOverlayView addSubview:self.view];
//        }
    }
}

// called when the parent application receives a memory warning
- (void)didReceiveMemoryWarning
{
    // we have been warned that memory is getting low, stop all timers
    //
    [super didReceiveMemoryWarning];
    
}

// update the UI after an image has been chosen or picture taken
//
- (void)finishAndUpdate
{
    [self.delegate didFinishWithCamera];  // tell our delegate we are done with the camera
    
    // restore the state of our overlay toolbar buttons
   // self.cancelButton.enabled = YES;
   // self.takePictureButton.enabled = YES;
    


}


#pragma mark -
#pragma mark Camera Actions

- (IBAction)done:(id)sender
{
        [self finishAndUpdate];
}



- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}






#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // give the taken picture to our delegate
    if (self.delegate)
        [self.delegate didTakePicture:image];
    
   
        [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
}

@end

