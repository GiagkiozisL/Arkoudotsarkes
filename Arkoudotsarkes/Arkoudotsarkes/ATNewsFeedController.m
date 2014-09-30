
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
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Camera2" image:[UIImage imageNamed:@"UIBarButtonCamera.png"] tag:1];
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
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
