
#import <UIKit/UIKit.h>
#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "ATMainViewController.h"

@interface ATAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ATMainViewController *tabBarController;

@end
