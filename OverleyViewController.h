#import <UIKit/UIKit.h>

@protocol OverleyViewControllerDelegate;

@interface OverleyViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <OverleyViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <OverleyViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end

@protocol OverleyViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
@end
