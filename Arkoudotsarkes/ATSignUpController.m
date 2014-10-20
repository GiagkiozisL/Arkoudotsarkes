
#import "ATSignUpController.h"
#import <Parse/Parse.h>
#import "MBProgressHub.h"

@interface ATSignUpController ()

@end

@implementation ATSignUpController 
@synthesize usernameTxt;
@synthesize passwordTxt;
@synthesize repasswordTxt;
@synthesize emailTxt;

UIAlertController *alertController;
UIAlertController *mismathingPasswords;
UIAlertController *succeedSignUp;

- (void)viewDidLoad {
    [super viewDidLoad];
    usernameTxt.delegate = self;
    passwordTxt.delegate = self;
    repasswordTxt.delegate = self;
    emailTxt.delegate = self;
    
    self.navigationItem.title = @"Registration Form";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitSignUp:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backToMain {
    
    usernameTxt.text = nil;
    passwordTxt.text = nil;
    repasswordTxt.text = nil;
    emailTxt.text = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == usernameTxt) {
        [textField resignFirstResponder];
        [passwordTxt becomeFirstResponder];
    } else if (textField == passwordTxt) {
        [textField resignFirstResponder];
        [repasswordTxt becomeFirstResponder];
    } else if (textField == repasswordTxt) {
        [textField resignFirstResponder];
        [emailTxt becomeFirstResponder];
    } else if (textField == emailTxt){
        [self submitSignUp:self];
    }
    return YES;
}

-(IBAction)submitSignUp:(id)sender {
    
    if (usernameTxt.text.length !=0 &&
        passwordTxt.text.length !=0 &&
        repasswordTxt.text.length !=0) {
        
        NSString *password1 = passwordTxt.text;
        NSString *password2 = repasswordTxt.text;
        if ([password1 isEqualToString:password2] && usernameTxt.text.length !=0) {
            //send data to parse.com
            PFUser *newUser = [PFUser user];
            newUser.username = [NSString stringWithFormat:@"%@",usernameTxt.text];
            newUser.password = [NSString stringWithFormat:@"%@",passwordTxt.text];
            //  newUser.email = [NSString stringWithFormat:@"%@",emailTxt.text];
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // Hooray! Let them use the app now.
                    usernameTxt.text = nil;
                    passwordTxt.text = nil;
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Success!"
                                                  message:@"Welcome to Arkoudotsarkes"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    // Show progress
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = @"Uploading";
                    [hud show:YES];
                    
                    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [hud hide:YES];
                        
                    }];

                    [self presentViewController:alert animated:YES completion:nil];
                
                    [self performSelector:@selector(backToMain) withObject:self afterDelay:2.0];
                    
                } else {
                    UIAlertController *duplicateRecord = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"The username alreade exists.Try another one" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *duplicaeAction = [UIAlertAction actionWithTitle:@"Try again"
                                                        style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action)       {       }];
                                            [duplicateRecord addAction:duplicaeAction];
                                            [self presentViewController:duplicateRecord animated:YES completion:nil];
                    usernameTxt.text = nil;
                }
            }];
        }
    }
}
@end