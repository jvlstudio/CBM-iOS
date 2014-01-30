//
//  SettingsProfile.m
//  CBM
//
//  Created by Felipe Ricieri on 29/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "SettingsProfile.h"


@implementation SettingsProfile

@synthesize labelEmail;
@synthesize labelName;
@synthesize labelPassword;
@synthesize labelPhone;
@synthesize labelTitle;

#pragma mark -
#pragma mark ViewController Methods

- (void) viewDidLoad
{
    [super viewDidLoadWithBackButton];
    
    // labels..
    [self configureLabel:labelTitle withText:labelTitle.text andSize:17.0 andColor:COLOR_WHITE];
}

@end
