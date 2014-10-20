
#import "ATEventsViewController.h"
#import "SWRevealViewController.h"

@interface ATEventsViewController ()

@end

@implementation ATEventsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    menuItem.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    self.navigationItem.leftBarButtonItem = menuItem;
    
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
