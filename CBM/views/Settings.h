//
//  Settings.h
//  CBM
//
//  Created by Felipe Ricieri on 29/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMRatingSwitchOnOff.h"

@interface Settings : CBMViewController

/* scroll view */

@property (nonatomic, strong) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) IBOutlet UIView *viewContent;

/* labels */

@property (nonatomic, strong) IBOutlet UILabel *labelUserName;
@property (nonatomic, strong) IBOutlet UILabel *labelTitleProfile;
@property (nonatomic, strong) IBOutlet UILabel *labelTitleShare;
@property (nonatomic, strong) IBOutlet UILabel *labelTitleLegal;

/* buttons */

@property (nonatomic, strong) IBOutlet UIButton *buttonProfile;
@property (nonatomic, strong) IBOutlet UIButton *buttonLegalPrivacy;
@property (nonatomic, strong) IBOutlet UIButton *buttonLegalTerms;

/* switches */

@property (nonatomic, strong) CBMRatingSwitchOnOff *switchNotifications;
@property (nonatomic, strong) CBMRatingSwitchOnOff *switchShareFacebook;
@property (nonatomic, strong) CBMRatingSwitchOnOff *switchShareTwitter;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressProfile:(id)sender;
- (IBAction) pressPrivacy:(id)sender;
- (IBAction) pressTerms:(id)sender;

#pragma mark -
#pragma mark Switch Actions

- (CBMRatingSwitchOnOff*) setSwitchWithRect:(CGRect)rect
                                    andIsOn:(BOOL) aIsOn
                                andSelector:(SEL) aSel;

- (void) changeSwitchNotifications:(id) sender;
- (void) changeSwitchShareFacebook:(id) sender;
- (void) changeSwitchShareTwitter:(id) sender;

@end
