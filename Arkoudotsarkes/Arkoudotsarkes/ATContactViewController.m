
#import "ATContactViewController.h"
#import "SWRevealViewController.h"

@interface ATContactViewController ()

@end

@implementation ATContactViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    self.navigationItem.title = @"Contact Form";
    
    
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callTelephone1:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"telprompt://+306947720650"]];
}

- (IBAction)callTelephone2:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"telprompt://+306977251549"]];
    
}

- (IBAction)facebookLogin:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/248584065270402/"]];
    
}


@end
