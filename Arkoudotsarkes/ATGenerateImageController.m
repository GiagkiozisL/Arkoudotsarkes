
#import "ATGenerateImageController.h"
#import "SWRevealViewController.h"
#import "PublishEvent.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ATGenerateImageController ()

@end

@implementation ATGenerateImageController
@synthesize sideBarButton;
@synthesize segmentControl;
@synthesize imageView;
@synthesize nextBarBtn;
@synthesize cancelBarBtn;
@synthesize toolBar;
@synthesize mainView;

NSString *temp;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"Camera";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera2" image:[UIImage imageNamed:@"UIBarButtonCamera.png"] tag:2];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [nextBarBtn setAction:@selector(proceedImage)];
    [nextBarBtn setTarget:self];
    [cancelBarBtn setAction:@selector(cancelImage)];
    [cancelBarBtn setTarget:self];
    [toolBar setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Change button color
    sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)proceedImage {
    [self performSegueWithIdentifier:@"proceedImage" sender:self];
}

-(void)cancelImage {
    imageView.image = nil;
    segmentControl.hidden = NO;
    toolBar.hidden = YES;
}

- (IBAction)segmentChangedValue:(id)sender {
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.delegate = self;
    
    if (segmentControl.selectedSegmentIndex == 0) {
        
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (segmentControl.selectedSegmentIndex == 1){
        mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

#pragma mark - UIImagePickerController

-(void) imagePickerController:(UIImagePickerController *)picker
            didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.image = originalImage;
    segmentControl.hidden = YES;
    toolBar.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"proceedImage"]) {
        
        PublishEvent *publishEventView = (PublishEvent *)segue.destinationViewController;
        publishEventView.imageTemp = imageView.image;
        publishEventView.messaeTxtField.text = temp;
    }
}

@end
