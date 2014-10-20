
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface ATNewsFeedController : PFQueryTableViewController <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) UIBarButtonItem *sideBarButton;

@end
