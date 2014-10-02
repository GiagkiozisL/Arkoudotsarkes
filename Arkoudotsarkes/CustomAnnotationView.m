
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

-(id)initWithTitle:(NSString *)newTitle
          Location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView*)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"menu.png"];
    return annotationView;
}

@end
