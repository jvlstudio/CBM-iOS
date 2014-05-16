//
//  StepsSingle.m
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "StepsSingle.h"
#import "StepsResults.h"

#import "UpdateData.h"

#define CGRECT_SCROLL   CGRectMake(0,0,WINDOW_WIDTH,WINDOW_HEIGHT-STATUS_BAR_HEIGHT)
#define BT_RESULTS      @"bt_steps_results.png"
#define BT_GETPASS      @"bt_steps_getpass.png"

#define KEY_NULL        @"--"


@implementation StepsSingle
{
    FRTools *tools;
    UpdateData *update;
}

@synthesize hasBackButton;
@synthesize stepDict;
@synthesize scroll;
@synthesize rootView;
@synthesize btProceed;
@synthesize picture;
@synthesize cover;
@synthesize numStep;
@synthesize cityName;
@synthesize labDate;
@synthesize labelWaitForResults;
@synthesize labProof1Pilot, labProof1BestLap;
@synthesize labProof2Pilot, labProof2BestLap;
@synthesize labProof1PilotDesc, labProof1BestLapDesc;
@synthesize labProof2PilotDesc, labProof2BestLapDesc;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;
{
    stepDict = dDict;
    hasBackButton = willHaveBackButton;
    int numStepSelected = [[stepDict objectForKey:KEY_NUM_STEP] intValue];
    self = [super initCBMViewController:@"StepsSingle" withTitle:[NSString stringWithFormat:@"%iª ETAPA", numStepSelected]];
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    if (hasBackButton)
        [super viewDidLoadWithBackButton];
    else
        [super viewDidLoadWithMenuButton];
    
    // set..
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    // scroll
    scroll = [[UIScrollView alloc] initWithFrame:CGRECT_SCROLL];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setPagingEnabled:NO];
    [scroll setContentSize:CGSizeMake(WINDOW_WIDTH, rootView.frame.size.height+STATUS_BAR_HEIGHT)];
    
    // bt
    if([[stepDict objectForKey:KEY_IS_ENDED] isEqualToString:KEY_YES]) {
        [btProceed setImage:[UIImage imageNamed:BT_RESULTS] forState:UIControlStateNormal];
    } else {
        NSString *content = [NSString stringWithFormat:@"DISPONÍVEL EM: %@/%@", [stepDict objectForKey:KEY_DATE_DAY], [stepDict objectForKey:KEY_DATE_MONTH]];
        [btProceed setImage:[UIImage imageNamed:BT_GETPASS] forState:UIControlStateNormal];
        [self configureLabel:labelWaitForResults withText:content andSize:13.0 andColor:COLOR_WHITE];
    }
    
    // labels
    [self configureLabel:cityName withText:[[stepDict objectForKey:KEY_CITY_NAME] uppercaseString] andSize:25.0 andColor:COLOR_WHITE];
    [self configureLabel:numStep withText:[NSString stringWithFormat:@"%@ª ETAPA", [stepDict objectForKey:KEY_NUM_STEP]] andSize:13.0 andColor:COLOR_WHITE];
    
    
    NSString *labDateStr        = [NSString stringWithFormat:@"%@/%@",
                                   [stepDict objectForKey:KEY_DATE_DAY],
                                   [stepDict objectForKey:KEY_DATE_MONTH]];
    [self configureLabel:labDate withText:labDateStr andSize:15.0 andColor:COLOR_WHITE];
    
    if ([[stepDict objectForKey:KEY_IS_ENDED] isEqual:KEY_NO])
        [labDate setHidden:YES];
    
    // content..
    NSInteger numStepSelected = [[stepDict objectForKey:KEY_NUM_STEP] intValue];
    NSArray *plistTemp  = [webservice wtvisionRowsForStep:numStepSelected type:kClassProofs]; //[tools propertyListRead:PLIST_STEPS_ROWS];
    NSString *strProof1Pilot, *strProof1BestLap;
    NSString *strProof2Pilot, *strProof2BestLap;
    
    if ([[stepDict objectForKey:KEY_NUM_STEP] intValue] <= [plistTemp count])
    {
        NSArray* proof1     = [plistTemp objectAtIndex:2];
        NSArray* proof2     = [plistTemp objectAtIndex:3];
        NSDictionary *dict1 = [proof1 objectAtIndex:0];
        NSDictionary *dict2 = [proof2 objectAtIndex:0];
        
        strProof1Pilot      = [dict1 objectForKey:KEY_PILOT];
        strProof1BestLap    = [dict1 objectForKey:KEY_TIME_BEST_LAP];
        strProof2Pilot      = [dict2 objectForKey:KEY_PILOT];
        strProof2BestLap    = [dict2 objectForKey:KEY_TIME_BEST_LAP];
    }
    else {
        strProof1Pilot      = KEY_NULL;
        strProof1BestLap    = KEY_NULL;
        strProof2Pilot      = KEY_NULL;
        strProof2BestLap    = KEY_NULL;
    }
    
    [self configureLabel:labProof1Pilot withText:strProof1Pilot andSize:15.0 andColor:COLOR_YELLOW];
    [self configureLabel:labProof1BestLap withText:strProof1BestLap andSize:25.0 andColor:COLOR_YELLOW];
    [self configureLabel:labProof2Pilot withText:strProof2Pilot andSize:15.0 andColor:COLOR_YELLOW];
    [self configureLabel:labProof2BestLap withText:strProof2BestLap andSize:25.0 andColor:COLOR_YELLOW];
    
    [self configureLabel:labProof1PilotDesc withText:[[labProof1PilotDesc text] uppercaseString] andSize:11.0 andColor:COLOR_GREY_LIGHT];
    [self configureLabel:labProof1BestLapDesc withText:[[labProof1BestLapDesc text] uppercaseString] andSize:11.0 andColor:COLOR_GREY_LIGHT];
    [self configureLabel:labProof2PilotDesc withText:[[labProof2PilotDesc text] uppercaseString] andSize:11.0 andColor:COLOR_GREY_LIGHT];
    [self configureLabel:labProof2BestLapDesc withText:[[labProof2BestLapDesc text] uppercaseString] andSize:11.0 andColor:COLOR_GREY_LIGHT];
    
    NSString *coverImg  = [NSString stringWithFormat:@"steps_single_cover_%@.png", [stepDict objectForKey:KEY_SLUG]];
    [cover setImage:[UIImage imageNamed:coverImg]];
    
    NSString *pictureImg= [NSString stringWithFormat:@"steps_lap_%@.png", [stepDict objectForKey:KEY_SLUG]];
    [picture setImage:[UIImage imageNamed:pictureImg]];
    
    // add..
    [scroll addSubview:rootView];
    [[self view] addSubview:scroll];
}

- (void)viewWillAppear:(BOOL)animated
{
    // super..
    [super viewWillAppear:animated];
    [super configureViewController:self withTitle:[NSString stringWithFormat:@"%@ª ETAPA", [stepDict objectForKey:KEY_NUM_STEP]]];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtProceed:(id)sender
{
    if([[stepDict objectForKey:KEY_IS_ENDED] isEqualToString:KEY_YES])
    {
        StepsResults *vc = [[StepsResults alloc] initWithDictionary:stepDict];
        [[self navigationController] pushViewController:vc animated:YES];
    }
    else {
        // do not push
        // if the content is not there...
    }
}

@end
