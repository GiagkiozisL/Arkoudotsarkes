
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ATMapViewController : UIViewController

@property(weak,nonatomic)IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
