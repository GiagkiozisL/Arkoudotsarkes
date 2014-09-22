
#import "ATViewEventCell.h"

@implementation ATViewEventCell
@synthesize imageEvent;
@synthesize textEvent;

- (void)awakeFromNib {
   
    imageEvent.layer.cornerRadius = 10;
    imageEvent.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
