
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ATMapViewController : UIViewController
{
    CLLocationManager *locationManager;
    bool running;
    NSTimeInterval startTime;
}

@property(weak,nonatomic)IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccurancy;
@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;
@property (weak,nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;

- (IBAction)accurancyChanged:(id)sender;
- (IBAction)enabledStateChanged:(id)sender;
- (IBAction)resetStopWatch:(id)sender;

@end
