
#import <UIKit/UIKit.h>

@interface ATSignUpController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UITextField *repasswordTxt;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;

@end
