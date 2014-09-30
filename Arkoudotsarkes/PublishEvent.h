
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PublishEvent : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UINavigationControllerDelegate>
{
    CGFloat animatedDistance;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic , strong) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UITextView *messaeTxtField;

@property(nonatomic) NSInteger *myValue;
@property(nonatomic, strong) NSString *messageTemp;
@property(nonatomic, strong) UIImage *imageTemp;

@end
