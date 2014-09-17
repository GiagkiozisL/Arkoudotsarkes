
#import "ATAppDelegate.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>

@implementation ATAppDelegate
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"saX5aAVwfdw4FqKOA3gnEhpxiHTNnG9yLRMsIDkS"
                  clientKey:@"WNY0sK9Zq6LqnPPNVJ7qYG6bjNiWD1S0CCP6lmT7"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    [PFFacebookUtils initializeFacebook];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]
//                                                   bounds]];
//    // Override point for customization after application launch.
//    UIViewController *viewController1 = [[ViewControllerA alloc]
//                                         initWithNibName:@"ViewControllerA" bundle:nil];
//    UIViewController *viewController2 = [[ViewControllerB alloc]
//                                         initWithNibName:@"ViewControllerB" bundle:nil];
//    self.tabBarController = [[ATMainViewController alloc] init];
//    self.tabBarController.viewControllers = @[viewController1,
//                                              viewController2];
//    self.window.rootViewController = self.tabBarController;
//    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
