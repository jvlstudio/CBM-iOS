//
//  Settings.m
//  CBM
//
//  Created by Felipe Ricieri on 29/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Settings.h"
#import "SettingsProfile.h"
#import "SettingsLegalPrivacy.h"
#import "SettingsLegalTerms.h"

#define SWITCH_WIDTH        69
#define SWITCH_HEIGHT       30
#define SWITCH_SLIDER_ON    @"switch_fill_settings_01.png"
#define SWITCH_SLIDER_OFF   @"switch_fill_settings_02.png"
#define SWITCH_BALL         @"switch_ball_settings.png"


@implementation Settings

@synthesize scroll;
@synthesize viewContent;
@synthesize labelUserName;
@synthesize labelTitleProfile;
@synthesize labelTitleShare;
@synthesize labelTitleLegal;
@synthesize buttonProfile;
@synthesize buttonLegalTerms;
@synthesize buttonLegalPrivacy;
@synthesize switchNotifications;
@synthesize switchShareFacebook;
@synthesize switchShareTwitter;

#pragma mark -
#pragma mark ViewController Methods

- (void) viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    if(!IS_IPHONE5)
    {
        CGRect rect = CGRectMake(0, 0, WINDOW_WIDTH, scroll.frame.size.height-88);
        [scroll setFrame:rect];
    }
    
    // labels..
    [self configureLabel:labelTitleProfile withText:labelTitleProfile.text andSize:17.0 andColor:COLOR_WHITE];
    [self configureLabel:labelTitleShare withText:labelTitleShare.text andSize:17.0 andColor:COLOR_WHITE];
    [self configureLabel:labelTitleLegal withText:labelTitleLegal.text andSize:17.0 andColor:COLOR_WHITE];
    
    // view content
    [scroll setContentSize:CGSizeMake(WINDOW_WIDTH, viewContent.frame.size.height)];
    [scroll addSubview:viewContent];
    
    // switches
    CGRect rectNot      = CGRectMake(223, 25/*119*/, SWITCH_WIDTH, SWITCH_HEIGHT);
    switchNotifications = [self setSwitchWithRect:rectNot andIsOn:YES andSelector:@selector(changeSwitchNotifications:)];
    /*
    CGRect rectFb       = CGRectMake(223, 227, SWITCH_WIDTH, SWITCH_HEIGHT);
    switchNotifications = [self setSwitchWithRect:rectFb andIsOn:YES andSelector:@selector(changeSwitchShareFacebook:)];
     
    CGRect rectTw       = CGRectMake(223, 269, SWITCH_WIDTH, SWITCH_HEIGHT);
    switchNotifications = [self setSwitchWithRect:rectTw andIsOn:YES andSelector:@selector(changeSwitchShareTwitter:)];*/
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressProfile:(id)sender
{
    SettingsProfile *vc = [[SettingsProfile alloc] initCBMViewController:@"SettingsProfile" withTitle:@"Meu Perfil"];
    [[self navigationController] pushViewController:vc animated:YES];
}
- (IBAction) pressPrivacy:(id)sender
{
    SettingsLegalPrivacy *vc = [[SettingsLegalPrivacy alloc] initCBMViewController:@"SettingsLegalPrivacy" withTitle:@"Privacidade"];
    [[self navigationController] pushViewController:vc animated:YES];
}
- (IBAction) pressTerms:(id)sender
{
    SettingsLegalTerms *vc = [[SettingsLegalTerms alloc] initCBMViewController:@"SettingsLegalTerms" withTitle:@"Termos e Condições"];
    [[self navigationController] pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Switch Actions

- (CBMRatingSwitchOnOff*)setSwitchWithRect:(CGRect)rect andIsOn:(BOOL)aIsOn andSelector:(SEL)aSel
{
    CBMRatingSwitchOnOff *c = [[CBMRatingSwitchOnOff alloc] initWithFrame:rect
                                                            sliderOnImage:SWITCH_SLIDER_ON
                                                           sliderOffImage:SWITCH_SLIDER_OFF
                                                               sliderBall:SWITCH_BALL];
    [c setOn:aIsOn];
    [c addTarget:self action:aSel forControlEvents:UIControlEventValueChanged];
    [scroll addSubview:c];
    
    return c;
}

- (void) changeSwitchNotifications:(id) sender
{
    
}
- (void) changeSwitchShareFacebook:(id) sender
{
    
}
- (void) changeSwitchShareTwitter:(id) sender
{
    
}

@end
