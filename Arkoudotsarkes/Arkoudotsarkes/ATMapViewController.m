
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "ATMapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"

@interface ATMapViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *locations;

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
    label.text = @"0:00:0";
    running = false;
    resetBtn.enabled = NO;
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    mapView.delegate = self;
    self.navigationItem.title = @"Map";
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeSatellite;
    self.locations = [[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    
    [self getLocation];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

-(void)getLocation {
  //  [self checkForWIFIConnection];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
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
    
    label.text = [NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];

    [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
}

#pragma mark - MKMapViewDelegate

//- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.025;
//    span.longitudeDelta = 0.025;
//    CLLocationCoordinate2D location;
//    location.latitude = aUserLocation.coordinate.latitude;
//    location.longitude = aUserLocation.coordinate.longitude;
//    region.span = span;
//    region.center = location;
//    [aMapView setRegion:region animated:YES];
//}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = newLocation.coordinate;
    [self.mapView addAnnotation:annotation];
    [self.locations addObject:annotation];
    
    while (self.locations.count >100) {
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
        region.span.latitudeDelta  = (maxLat +  90) - (minLat +  90);
        region.span.longitudeDelta = (maxLon + 180) - (minLon + 180);
        
        // the center point is the average of the max and mins
        region.center.latitude  = minLat + region.span.latitudeDelta / 2;
        region.center.longitude = minLon + region.span.longitudeDelta / 2;
        
        // Set the region of the map.
        [mapView setRegion:region animated:YES];
    }
    else
    {
        NSLog(@"App is backgrounded. New location is %@", newLocation);
    }
    
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
        startTime = [NSDate timeIntervalSinceReferenceDate];
        resetBtn.enabled = YES;
        [self updateTime];
        [locationManager startUpdatingLocation];
    } else  {
        
    running = false;
        [locationManager stopUpdatingLocation];
    }
}

@end
