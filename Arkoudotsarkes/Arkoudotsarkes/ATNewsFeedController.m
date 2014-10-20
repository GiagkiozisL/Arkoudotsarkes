
#import "ATNewsFeedController.h"
#import "ATViewEventCell.h"
#import "SWRevealViewController.h"

@interface ATNewsFeedController ()

@end

@implementation ATNewsFeedController
ATViewEventCell *tableViewCell;
UIButton *moreBtn;
NSString *tempObjectId;
UIAlertView *alert;
UIAlertView *alertFail;

@synthesize sideBarButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
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

-(void)morePressed:(id)sender forEvent:(UIEvent*)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    PFObject *objectInRow = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"objectid selected :%@",objectInRow.objectId);
    
    UIActionSheet *reportSheet = [[UIActionSheet alloc]initWithTitle:@"More"
                                                        delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:@"Report"
                                otherButtonTitles: nil];
    [reportSheet showInView:self.view];
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

-(void)dismissAlertView {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alertFail dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)sendReportToParse {
    
    //Create object
    PFObject *newReportedObject = [PFObject objectWithClassName:@"Reports"];
    [newReportedObject setObject:tempObjectId forKey:@"objectIdentifier"];
    [newReportedObject setObject:[PFUser currentUser] forKey:@"username"];
    
    // Upload event to Parse
    [newReportedObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Report post in Arkoudotsarkes!// EMERGENCY //"];
    NSArray *toRecipients = [NSArray arrayWithObject:@"giagkiozis.l@hotmail.com"];
    [picker setToRecipients:toRecipients];
    NSString *message = @"Check in parse.com for reports!";
    [picker setMessageBody:message isHTML:NO];
  //  [self presentViewController:picker animated:YES completion:NULL];

}

#pragma mark - MFMailComposer

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        if ([PFUser currentUser] != nil) {
            
            alert =[[UIAlertView alloc] initWithTitle:@"Message"
                                              message:@"Thank you for reporting, we will get in touch with you soon"
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
            alert.backgroundColor = [UIColor greenColor];
            [alert show];
            [self sendReportToParse];
            [self performSelector:@selector(dismissAlertView) withObject:alert afterDelay:3.5];
            
        }
        else
        {
            alertFail =[[UIAlertView alloc] initWithTitle:@"Message"
                                              message:@"You have to Log in first!"
                                             delegate:nil
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil];
            alertFail.backgroundColor = [UIColor greenColor];
            [alertFail show];
            
            [self performSelector:@selector(dismissAlertView) withObject:alertFail afterDelay:3.5];
       
        }
    }
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
    
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(10, 297, 84, 23);
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [moreBtn setTag:indexPath.row];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(morePressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewCell addSubview:moreBtn];
    
    tableViewCell.textEvent.text = object[@"Description"];
    PFImageView *parseImage = [[PFImageView alloc]init];
    parseImage.file = (PFFile *)object[@"image"];
    [parseImage loadInBackground];
    tableViewCell.imageEvent.image = parseImage.image;
    tempObjectId = [object objectId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return tableViewCell;
}

@end
