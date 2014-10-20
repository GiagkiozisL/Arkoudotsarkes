
#import "ATTabBarViewController.h"
#import "SWRevealViewController.h"
#import "ATNewsFeedController.h"

@interface ATTabBarViewController ()

@end

@implementation ATTabBarViewController

@synthesize tabBarItem;
ATNewsFeedController *newscontrol;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"News Feed";
    self.delegate = self;
    newscontrol = [[ATNewsFeedController alloc]init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];

     [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 
    if (tabBarController.selectedIndex ==0) {
        self.navigationItem.title = @"News Feed";
    } else if (tabBarController.selectedIndex == 1) {
        self.navigationItem.title = @"Camera";
    }
}

@end
