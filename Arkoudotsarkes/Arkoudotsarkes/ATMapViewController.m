
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "ATMapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"

@interface ATMapViewController () <MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation>

@property (nonatomic, strong) NSMutableArray *locations;
@property (readwrite,nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation ATMapViewController
@synthesize mapView;
@synthesize label;
@synthesize resetBtn;

CLLocationManager *locationManager;
NSTimeInterval elapseTime;
NSTimeInterval currentTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    label.text = @"00:00:0";
    running = false;
    resetBtn.enabled = YES;
    resetBtn.hidden = YES;
    resetBtn.layer.cornerRadius = 10.0;
    resetBtn.clipsToBounds = YES;
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    mapView.delegate = self;
    self.navigationItem.title = @"Map";
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeSatellite;
    self.locations = [[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    [self getLocation];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(void)getLocation {
   [self checkForWIFIConnection];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    Reachability* cellular = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    NetworkStatus netStatus1 = [cellular currentReachabilityStatus];
    if (netStatus!=ReachableViaWiFi && netStatus1!=ReachableViaWWAN)
    {
        
        NSString *cancelTitle = @"OK";
        UIAlertView *alertView1 = [[UIAlertView alloc]
                                   initWithTitle:@"Connection Failed"
                                   message:@"Please,check your internet connection(WiFi or Cellular)"
                                   delegate:self
                                   cancelButtonTitle:cancelTitle
                                   otherButtonTitles:  nil ];
        [alertView1 show];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTime {
    
    if (running == false)  return;
    
    currentTime =  [NSDate timeIntervalSinceReferenceDate];
    elapseTime = currentTime - startTime;
    
    int mins = (int) (elapseTime / 60.0);
    elapseTime -= mins * 60;
    int secs = (int) (elapseTime);
    elapseTime -= secs;
    int fraction = elapseTime * 10.0;
    
    label.text = [NSString stringWithFormat:@"%02u:%02u.%u",mins,secs,fraction];

    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations.lastObject;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = newLocation.coordinate;
    
    [self.mapView addAnnotation:annotation];
    [self.locations addObject:annotation];
    
    while (self.locations.count >1000) {
        annotation = [self.locations objectAtIndex:0];
        [self.locations removeObjectAtIndex:0];
        [mapView removeAnnotation:annotation];
    }
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
        // determine the region the points span so we can update our map's zoom.
        double maxLat = -91;
        double minLat =  91;
        double maxLon = -181;
        double minLon =  181;
        
        for (MKPointAnnotation *annotation in self.locations)
        {
            CLLocationCoordinate2D coordinate = annotation.coordinate;
            
            if (coordinate.latitude > maxLat)
                maxLat = coordinate.latitude;
            if (coordinate.latitude < minLat)
                minLat = coordinate.latitude;
            
            if (coordinate.longitude > maxLon)
                maxLon = coordinate.longitude;
            if (coordinate.longitude < minLon)
                minLon = coordinate.longitude;
        }
        
        MKCoordinateRegion region;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        
        // the center point is the average of the max and mins
        region.center.latitude  = newLocation.coordinate.latitude;
        region.center.longitude = newLocation.coordinate.longitude;
        
        // Set the region of the map.
        [mapView setRegion:region animated:YES];
    }
    else {
        NSLog(@"App is backgrounded. New location is %@", newLocation);
    }
    
}

#pragma mark -MKAnnotationView

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorPurple;
    
    return MyPin;
}

- (IBAction)accurancyChanged:(id)sender {
    
    const CLLocationAccuracy accurancyValues [] = {
        kCLLocationAccuracyBestForNavigation,
        kCLLocationAccuracyBest,
        kCLLocationAccuracyNearestTenMeters,
        kCLLocationAccuracyHundredMeters,
        kCLLocationAccuracyKilometer,
        kCLLocationAccuracyThreeKilometers
    };
    locationManager.desiredAccuracy = accurancyValues[self.segmentAccurancy.selectedSegmentIndex];
}

- (IBAction)enabledStateChanged:(id)sender {
    
    if (self.switchEnabled.on) {
        
        running = true;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        startTime = [NSDate timeIntervalSinceReferenceDate];
        resetBtn.enabled = NO;
        resetBtn.hidden = YES;
        [self updateTime];
        [locationManager startUpdatingLocation];
    } else  {
        
    running = false;
        resetBtn.hidden = NO;
        resetBtn.enabled = YES;
        
        [locationManager stopUpdatingLocation];
    }
}

- (IBAction)resetStopWatch:(id)sender {

    [mapView removeAnnotations:_locations];
    [self viewDidLoad];
    
}

@end
