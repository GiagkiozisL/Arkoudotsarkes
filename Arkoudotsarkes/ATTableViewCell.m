
#import "ATTableViewCell.h"

@implementation ATTableViewCell
@synthesize username;
@synthesize motorbike;
@synthesize status;
@synthesize imageOne;
@synthesize imageTwo;
@synthesize imageThree;


- (void)awakeFromNib {
    
    imageOne.layer.cornerRadius = 30;
    imageOne.clipsToBounds = YES;
    imageTwo.layer.cornerRadius = 30;
    imageTwo.clipsToBounds = YES;
    imageThree.layer.cornerRadius = 30;
    imageThree.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
