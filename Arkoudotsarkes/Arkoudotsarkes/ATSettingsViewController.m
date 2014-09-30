
#import "ATSettingsViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ATSettingsViewController ()

@end

@implementation ATSettingsViewController
@synthesize stopEngineBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
         [stopEngineBtn setImage:[UIImage imageNamed:@"engineStarted.png"] forState:UIControlStateNormal];
    } else
         [stopEngineBtn setImage:[UIImage imageNamed:@"engineStopped.png"] forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"Settings";
    titleLabel.font = [UIFont fontWithName:@"Telugu Sangam MN Bold" size:30.0];
    self.navigationItem.title = titleLabel.text;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    UIView *naviView = [[UIView alloc]initWithFrame:(CGRectMake(290,0,70,30))];
    
    UIButton *logOutBtn = [[UIButton alloc]initWithFrame:(CGRectMake(0, 7, 70, 20))];
    
    [logOutBtn setTitle:@"Log Out" forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logOutAndDismiss) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:logOutBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:naviView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToMain {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logOutAndDismiss {
    
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)stopEngine:(id)sender {
    [PFUser logOut];
    [stopEngineBtn setImage:[UIImage imageNamed:@"engineStopped.png"] forState:UIControlStateNormal];
}

@end
