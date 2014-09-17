
#import "ViewControllerA.h"
#import "SWRevealViewController.h"

@interface ViewControllerA ()

@end

@implementation ViewControllerA
@synthesize sideBarButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News";
    // Change button color
    sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    //    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
