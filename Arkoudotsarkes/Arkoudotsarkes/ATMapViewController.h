
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ATMapViewController : UIViewController
{
    CLLocationManager *locationManager;
}

@property(weak,nonatomic)IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccurancy;
@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;

- (IBAction)accurancyChanged:(id)sender;
- (IBAction)enabledStateChanged:(id)sender;

@end
