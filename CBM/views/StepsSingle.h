//
//  StepsSingle.h
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface StepsSingle : CBMViewController

@property (nonatomic) BOOL hasBackButton;
@property (nonatomic, strong) NSDictionary *stepDict;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) IBOutlet UIView *rootView;
@property (nonatomic, strong) IBOutlet UIButton *btProceed;
@property (nonatomic, strong) IBOutlet UIImageView *picture;
@property (nonatomic, strong) IBOutlet UIImageView *cover;
@property (nonatomic, strong) IBOutlet UILabel *numStep;
@property (nonatomic, strong) IBOutlet UILabel *cityName;
@property (nonatomic, strong) IBOutlet UILabel *labDate;
@property (nonatomic, strong) IBOutlet UILabel *labelWaitForResults;

/* labels */

@property (nonatomic, strong) IBOutlet UILabel *labProof1PilotDesc;
@property (nonatomic, strong) IBOutlet UILabel *labProof1BestLapDesc;
@property (nonatomic, strong) IBOutlet UILabel *labProof2PilotDesc;
@property (nonatomic, strong) IBOutlet UILabel *labProof2BestLapDesc;

@property (nonatomic, strong) IBOutlet UILabel *labProof1Pilot;
@property (nonatomic, strong) IBOutlet UILabel *labProof1BestLap;
@property (nonatomic, strong) IBOutlet UILabel *labProof2Pilot;
@property (nonatomic, strong) IBOutlet UILabel *labProof2BestLap;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtProceed:(id)sender;

@end