
#import "ViewController.h"

@interface ViewController ()



@property (nonatomic, retain) IBOutlet UIToolbar *myToolbar;

@property (nonatomic, retain) OverleyViewController* overleyViewController;


@property (nonatomic,strong) UIPopoverController *popovercontroller;

// toolbar buttons
- (IBAction)photoLibraryAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

- (IBAction)cancelbutton:(id)sender;

@end

@implementation ViewController

@synthesize popovercontroller = _popovercontroller;
@synthesize delegate=_delegate;



#pragma mark -
#pragma mark View Controller

- (void)viewDidLoad
{
    self.overleyViewController =
    [[OverleyViewController alloc] initWithNibName:@"OverleyViewController" bundle:nil];
    
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overleyViewController.delegate = self;
    
    self.capturedImages = [NSMutableArray array];
    self.collectionImages = [NSMutableArray array];
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // camera is not on this device, don't show the camera button
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
        [toolbarItems addObjectsFromArray:self.myToolbar.items];
        [toolbarItems removeObjectAtIndex:2];
        [self.myToolbar setItems:toolbarItems animated:NO];
    }
    
    
    
}

- (void)viewDidUnload
{
    [self setCameraa:nil];
    [self setPhotooalbum:nil];
    self.imageView = nil;
    self.myToolbar = nil;
    
    self.overleyViewController = nil;
    self.capturedImages = nil;
}



#pragma mark -
#pragma mark Toolbar Actions

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
        [self.imageView stopAnimating];
	
    if (self.capturedImages.count > 0)
        [self.capturedImages removeAllObjects];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overleyViewController setupImagePicker:sourceType];
       // [self presentModalViewController:self.overleyViewController.imagePickerController animated:YES];
        
        if(sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            
//            
//              [self presentModalViewController:self.overleyViewController.imagePickerController animated:YES];
            self.popovercontroller=[[UIPopoverController alloc] initWithContentViewController:self.overleyViewController.imagePickerController];
            
            [self.popovercontroller presentPopoverFromBarButtonItem:self.Cameraa permittedArrowDirections:UIPopoverArrowDirectionDown animated:NO];
        }
        
        else{
        
       self.popovercontroller=[[UIPopoverController alloc] initWithContentViewController:self.overleyViewController.imagePickerController];

        [self.popovercontroller presentPopoverFromBarButtonItem:self.Photooalbum permittedArrowDirections:UIPopoverArrowDirectionDown animated:NO];
        }
        
        
    }
}

- (IBAction)photoLibraryAction:(id)sender
{
    
    if([self.popovercontroller isPopoverVisible])
    {
        
        [self.popovercontroller dismissPopoverAnimated:NO];
        

    }
    else{
        
        
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];

    }
    
}

- (IBAction)cameraAction:(id)sender
{
    if([self.popovercontroller isPopoverVisible])
    {
        
        [self.popovercontroller dismissPopoverAnimated:NO];
        
        
    }
    else{
    
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
    
    
    }


#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    [self.capturedImages addObject:picture];
    [self.collectionImages addObject:picture];
    [self.delegate photosaved:picture];
    
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // we took a single shot
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
            
            [self.popovercontroller dismissPopoverAnimated:NO];
        }
        else
        {
      
            
                  }
        
    }
    
    
    if(self.imageView.image !=nil)
    {
        
        self.Cameraa.enabled = NO;
        self.Photooalbum.enabled = NO;
        
    }
    
    
    
}

- (IBAction)cancelbutton:(id)sender {
    
    [self.delegate cancelingeotagpressed];
}
@end