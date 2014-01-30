//
//  HomeSimple.h
//  CBM
//
//  Created by Felipe Ricieri on 26/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface HomeSimple : CBMViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) IBOutlet UIView *viewContent;
@property (nonatomic, strong) IBOutlet UIImageView *imgSquare;
@property (nonatomic, strong) IBOutlet UIButton *butPilots;
@property (nonatomic, strong) IBOutlet UIButton *butSteps;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilot:(id)sender;
- (IBAction) pressSteps:(id)sender;

@end
