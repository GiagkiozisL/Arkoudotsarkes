
#import "ATTeamTableViewController.h"
#import "ATTableViewCell.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ATTeamTableViewController () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ATTeamTableViewController
ATTableViewCell *tableViewCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCowBoy)];
    self.navigationItem.title = [NSString stringWithFormat:@"Dream Team"];
}

-(void)addCowBoy {
    
    [self performSegueWithIdentifier:@"createNewUser" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 205.0;
}

#pragma mark - PFQueryTableViewController

-(PFQuery* )queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Team"];
    [query orderByDescending:@"CreatedAt"];
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
            object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"TableCell";
     tableViewCell = (ATTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (tableViewCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ATTableViewCell" owner:self options:nil];
        tableViewCell = [nib objectAtIndex:0];
    }
    
    tableViewCell.username.text = object[@"username"];
    tableViewCell.motorbike.text = object[@"motorbike"];
    tableViewCell.status.text = object[@"status"];
    
    PFImageView *parseImageOne = [[PFImageView alloc]init];
    parseImageOne.image = [UIImage imageNamed:@"addPic.png"];
    parseImageOne.file = (PFFile*)object[@"imageOne"];
    [parseImageOne loadInBackground];
    tableViewCell.imageOne.image = parseImageOne.image;
    
    PFImageView *parseImageTwo = [[PFImageView alloc]init];
    parseImageTwo.image = [UIImage imageNamed:@"addPic.png"];
    parseImageTwo.file = (PFFile*)object[@"imageTwo"];
    [parseImageTwo loadInBackground];
    tableViewCell.imageTwo.image = parseImageTwo.image;
    
    PFImageView *parseImageThree = [[PFImageView alloc]init];
    parseImageThree.image = [UIImage imageNamed:@"addPic.png"];
    parseImageThree.file = (PFFile*)object[@"imageThree"];
    [parseImageThree loadInBackground];
    tableViewCell.imageThree.image = parseImageThree.image;
    
    return tableViewCell;
}

@end
