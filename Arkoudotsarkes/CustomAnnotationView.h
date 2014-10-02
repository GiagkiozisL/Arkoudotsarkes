

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotationView : NSObject <MKAnnotation>

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (copy,nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
-(MKAnnotationView*)annotationView;

@end
