//
//  ATPhotoViewController.h
//  Arkoudotsarkes
//
//  Created by Giagkiozis Louloudis on 9/10/14.
//  Copyright (c) 2014 FlowerApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) NSString *photoFilename;

@end
