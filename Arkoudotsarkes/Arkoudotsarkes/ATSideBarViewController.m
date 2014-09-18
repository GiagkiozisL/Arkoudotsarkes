
#import "ATSidebarViewController.h"
#import "SWRevealViewController.h"
#import "ATPhotoViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ATSettingsViewController.h"

@interface ATSideBarViewController ()

@end

@implementation ATSideBarViewController

NSArray *menuItems;
UILabel *lblTitle;
NSString *userLbl;
UIView *titleView;
UIView *titleRightView;
UILabel *titleLabel;
UIImage *image;
UIImageView *myImageView;
UIImageView *myRightImageView;
NSString *name;
UIButton *settingBtn;
NSData *imageData;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    titleView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 300, 30))];
    titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(50, 0, 300, 30))];
    settingBtn = [[UIButton alloc] initWithFrame:(CGRectMake(215, 7, 20, 20))];
    
    settingBtn.enabled = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"settings.png"];
    [settingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingsViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [titleLabel setTextColor:[UIColor grayColor]];
    titleLabel.font = [UIFont fontWithName:@"Telugu Sangam MN Bold" size:17.0];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    myImageView.frame = CGRectMake(0, 0, 32, 32);
    myImageView.layer.cornerRadius = 5.0;
    myImageView.layer.masksToBounds = YES;
    myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    myImageView.layer.borderWidth = 0.1;
    myImageView.layer.cornerRadius = 15.0;
    [titleView addSubview:titleLabel];
    [titleView setBackgroundColor:[UIColor  clearColor]];
    [titleView addSubview:myImageView];
    [titleView addSubview:settingBtn];
    self.navigationItem.titleView = titleView;
    
    
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        // Check if user is linked to Facebook
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                NSString *facebookID = userData[@"id"];
                NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", facebookID];
                imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                name = userData[@"name"];
                titleLabel.text = name;
                image = [UIImage imageWithData:imageData];
                myImageView = [[UIImageView alloc] initWithImage:image];
                
            } else {
                
            }
        }];
        
        NSLog(@"user logged in");
        titleLabel.text = name;
        image = [UIImage imageWithData:imageData];
        myImageView = [[UIImageView alloc] initWithImage:image];

    } else {
        
        NSLog(@"user hasnt logged in");
        titleLabel.text = @"user hasnt logged in";
        image = nil;
        myImageView = [[UIImageView alloc] init];
    }

    
}

- (void)viewDidLoad {
    [self viewWillAppear:YES];
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundDesert2.png"]];
    
    menuItems = @[@"title", @"news", @"comments", @"map", @"calendar", @"wishlist", @"bookmark", @"tag"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        ATPhotoViewController *photoController = (ATPhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

-(void)settingsViewController{
    
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 2) {
//        [self performSegueWithIdentifier:@"newsFeed" sender:self];
//    }
}

@end
