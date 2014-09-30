
#import "ATNewsFeedController.h"
#import "ATViewEventCell.h"
#import "SWRevealViewController.h"

@interface ATNewsFeedController ()

@end

@implementation ATNewsFeedController
ATViewEventCell *tableViewCell;
@synthesize sideBarButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News Feed" image:[UIImage imageNamed:@"UIBarButtonCamera.png"] tag:1];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.refreshControl.backgroundColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshView:(UIRefreshControl*)refresh {
             refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];

}
#pragma mark - PFQueryTableViewController

-(PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query orderByDescending:@"createdAt"];
    return query;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 320;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    static NSString *identifier = @"TableCell";
    tableViewCell = (ATViewEventCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableViewCell ==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ATViewEventCell" owner:self options:nil];
        tableViewCell = [nib objectAtIndex:0];
    }
    
    tableViewCell.textEvent.text = object[@"Description"];
    PFImageView *parseImage = [[PFImageView alloc]init];
    parseImage.file = (PFFile *)object[@"image"];
    [parseImage loadInBackground];
    tableViewCell.imageEvent.image = parseImage.image;
    
    return tableViewCell;
}

@end
