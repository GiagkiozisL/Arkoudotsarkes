
#import "PublishEvent.h"
#import "MBProgressHub.h"
#import "ATGenerateImageController.h"
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface PublishEvent ()

@end

@implementation PublishEvent
@synthesize imageView;
@synthesize scrollView;
@synthesize messaeTxtField;
@synthesize myValue;
@synthesize imageTemp;

ATGenerateImageController *viewA;
UIBarButtonItem *facebookBtn;
UIBarButtonItem *twitterBtn;
UIBarButtonItem *databaseBtn;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    facebookBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"facebook.png"] style:UIBarButtonItemStylePlain target:self action:@selector(facebookPost)];
    twitterBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"twitter.png"] style:UIBarButtonItemStylePlain target:self action:@selector(twitterPost)];
    databaseBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(databasePost)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:databaseBtn,twitterBtn,facebookBtn, nil];

    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageView.image = imageTemp;
    scrollView.delegate = self;
    
}

-(void)facebookPost {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@",messaeTxtField.text]];
        [controller addImage:imageTemp];
        facebookBtn.enabled = NO;
        [self presentViewController:controller animated:YES completion:Nil];
    } else {
        NSLog(@"unavailable!");
    }
}
-(void)twitterPost {

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@",messaeTxtField.text]];
        [tweetSheet addImage:imageTemp];
        NSLog(@"shared to twitter!!!");
        twitterBtn.enabled = NO;
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        NSLog(@"unavailable!");
    }
}

-(void)databasePost {

    PFObject *newObject = [PFObject objectWithClassName:@"Event"];
    newObject[@"Description"] = messaeTxtField.text;
    
    // event image
    NSData *imageData = UIImageJPEGRepresentation(self.imageTemp, 0.8);
    NSString *filename = [NSString stringWithFormat:@"image.png"];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [newObject setObject:imageFile forKey:@"image"];
    [newObject setObject:[PFUser currentUser] forKey:@"username"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    // Upload event to Parse
    [newObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
    }];
    databaseBtn.enabled = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}

#pragma mark - UITextFieldDelegate

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


//#pragma mark - Segue
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// 
//    if ([segue.identifier isEqualToString:@"backToNewsFeed"]) {
//        
//        ATGenerateImageController *generatedImage = (ATGenerateImageController *)segue.destinationViewController;
//        generatedImage.imageView = nil;
//    }
//    
//}

@end
