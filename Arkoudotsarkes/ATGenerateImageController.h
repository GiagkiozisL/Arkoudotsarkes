
#import <UIKit/UIKit.h>

@interface ATGenerateImageController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) UIBarButtonItem *sideBarButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBarBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
