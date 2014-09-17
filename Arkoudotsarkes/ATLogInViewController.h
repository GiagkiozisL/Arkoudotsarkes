
#import <UIKit/UIKit.h>

@interface ATLogInViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UIButton *startEngineBtn;
@property (strong, nonatomic) IBOutlet UIButton *fbLoginBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *logInIndicator;

@end
