
#import "ATLogInViewController.h"
#import "SWRevealViewController.h"
#import "Comms.h"

@interface ATLogInViewController () <CommsDelegate,UITextFieldDelegate>

@end

@implementation ATLogInViewController
@synthesize usernameTxt;
@synthesize passwordTxt;
@synthesize startEngineBtn;
@synthesize fbLoginBtn;
@synthesize logInIndicator;

UILabel *usernameLabel;
UIAlertView *alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) commsDidLogin:(BOOL)loggedIn {
	
	[fbLoginBtn setEnabled:YES];
	[logInIndicator stopAnimating];
	if (loggedIn) {
	
		[self dismissViewControllerAnimated:YES completion:nil];
            alert =[[UIAlertView alloc] initWithTitle:@"Message"
                                                       message:@"Success!!"
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                            otherButtonTitles:nil];
        alert.backgroundColor = [UIColor greenColor];
        UIImageView *alertImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"]];
        
        [alert addSubview:alertImgView];
        [alert show];
        [self performSelector:@selector(dismissAlertView) withObject:alert afterDelay:2.0];
        
	} else {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    usernameTxt.delegate = self;
    passwordTxt.delegate = self;
    usernameLabel.text = @"Guest";
    [usernameLabel setTextAlignment:(NSTextAlignmentLeft)];
    usernameLabel.font = [UIFont fontWithName:@"Telugu Sangam MN Bold" size:21];
    
    self.navigationItem.title = usernameLabel.text;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField == usernameTxt) {
        [textField resignFirstResponder];
        [passwordTxt becomeFirstResponder];
    } else if (textField == passwordTxt)
    {  [self submitLogIn:self];
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)dismissAlertView{
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self.revealViewController revealToggle:self];
}

- (IBAction)facebookLogIn:(id)sender {
    
    [fbLoginBtn setEnabled:NO];
    [logInIndicator startAnimating];
    [Comms login:self];
    
}
- (IBAction)submitLogIn:(id)sender {
    
    [logInIndicator startAnimating];
    [PFUser logInWithUsernameInBackground:usernameTxt.text password:passwordTxt.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login user!");
            [self.revealViewController revealToggle:self];
            passwordTxt.text = nil;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            usernameTxt.text = nil;
            passwordTxt.text = nil;
            [usernameTxt becomeFirstResponder];
        }
    }];
    [logInIndicator stopAnimating];
}

@end
