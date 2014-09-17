
#import "ATNewUserTableViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHub.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ATNewUserTableViewController () 

@end

@implementation ATNewUserTableViewController
@synthesize usernameTxt;
@synthesize statusTxt;
@synthesize motorbikeTxt;
@synthesize imageOne;
@synthesize imageTwo;
@synthesize imageThree;
NSInteger cellPickerNumber;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    cellPickerNumber = 0;
    self.usernameTxt.delegate = self;
    self.statusTxt.delegate = self;
    self.motorbikeTxt.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(copyToParse)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
}

-(void)copyToParse {
    
    PFObject *newUser = [PFObject objectWithClassName:@"Team"];
    [newUser setObject:usernameTxt.text forKey:@"username"];
    [newUser setObject:statusTxt.text forKey:@"status"];
    [newUser setObject:motorbikeTxt.text forKey:@"motorbike"];
    
    NSData *imageData1 = UIImageJPEGRepresentation(imageOne.image, 0.8);
    NSString *filename1 = [NSString stringWithFormat:@"image1.png"];
    PFFile *imageFile1 = [PFFile fileWithName:filename1 data:imageData1];
    [newUser setObject:imageFile1 forKey:@"imageOne"];
    
    NSData *imageData2 = UIImageJPEGRepresentation(imageTwo.image, 0.8);
    NSString *filename2 = [NSString stringWithFormat:@"image2.png"];
    PFFile *imageFile2 = [PFFile fileWithName:filename2 data:imageData2];
    [newUser setObject:imageFile2 forKey:@"imageTwo"];
    
    NSData *imageData3 = UIImageJPEGRepresentation(imageThree.image, 0.8);
    NSString *filename3 = [NSString stringWithFormat:@"image3.png"];
    PFFile *imageFile3 = [PFFile fileWithName:filename3 data:imageData3];
    [newUser setObject:imageFile3 forKey:@"imageThree"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    // Upload event to Parse
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

-(void)backToMain {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"row number %ld returned!",(long)indexPath.row);
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5) {
        cellPickerNumber = indexPath.row;
        [self showPhotoLibrary];
   }
}

-(void)showPhotoLibrary {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.delegate = self;
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
                   {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    if (cellPickerNumber ==3) { imageOne.image = originalImage; }
    else if (cellPickerNumber ==4) { imageTwo.image = originalImage; }
    else if (cellPickerNumber ==5) { imageThree.image = originalImage; }
  
                       cellPickerNumber = 0;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



@end
