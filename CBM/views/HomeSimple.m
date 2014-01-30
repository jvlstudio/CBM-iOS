//
//  HomeSimple.m
//  CBM
//
//  Created by Felipe Ricieri on 26/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "HomeSimple.h"
#import "Steps.h"

#define IMAGE_PIRELLI       @"start_pirelli.png"
#define IMAGE_BRANDCORE     @"start_brandcore.png"

#define DELAY               0.5f

/* interface */

@interface HomeSimple ()
/* update */
- (void) updatePilots;
- (void) updateSteps;
/* push */
- (void) pushPilots;
- (void) pushSteps;
@end

/* implementation */

@implementation HomeSimple
{
    FRTools *tools;
    UpdateData *update;
    
    UIAlertView *alertUpdatePilot;
    UIAlertView *alertUpdateSteps;
}

@synthesize scroll;
@synthesize viewContent;
@synthesize imgSquare;
@synthesize butPilots, butSteps;

#pragma mark -
#pragma mark ViewController Methods

- (void) viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // data..
    tools           = [[FRTools alloc] initWithTools];
    update          = [[UpdateData alloc] initWithRootViewController:self];
    
    // alerts..
    alertUpdatePilot    = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_PILOT
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    alertUpdateSteps    = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_STEPS
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    float height = (IS_IPHONE5 ? 520 : 600);
    [scroll setContentSize:CGSizeMake(viewContent.frame.size.width, height)];
    [scroll addSubview:viewContent];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilot:(id)sender
{
    if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_PILOTS])
    {
        [update sync:SYNC_START_MESSAGE];
        [self performSelector:@selector(updatePilots) withObject:nil afterDelay:0.3];
    }
    else {
        [self pushPilots];
    }
}
- (IBAction) pressSteps:(id)sender
{
    if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_STEPS])
    {
        [update sync:SYNC_START_MESSAGE];
        [self performSelector:@selector(updateSteps) withObject:nil afterDelay:0.3];
    }
    else {
        [self pushSteps];
    }
}

#pragma mark -
#pragma mark Actions

/* update */

- (void) updatePilots
{
    [update downlaodDataFrom:URL_PILOTS success:^{
        [update updatesDidLoad];
        [update syncEnd:SYNC_END_MESSAGE];
        NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
        [tools propertyListWrite:arr forFileName:PLIST_PILOTS];
        [self pushPilots];
    } fail:^{
        [update syncError:SYNC_ERROR_MESSAGE];
        [alertUpdatePilot show];
    }];
}

- (void) updateSteps
{
    [update downlaodDataFrom:URL_STEPS success:^{
        [update updatesDidLoad];
        [update syncEnd:SYNC_END_MESSAGE];
        NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
        //if ([arr count] == 8) {
        [tools propertyListWrite:arr forFileName:PLIST_STEPS];
        //}
        [self pushSteps];
    } fail:^{
        [update syncError:SYNC_ERROR_MESSAGE];
        [alertUpdateSteps show];
    }];
}

/* push */

- (void) pushPilots
{
    [super showLeftWithPilots];
}

- (void) pushSteps
{
    Steps *c = [[Steps alloc] initCBMViewController:VC_STEPS];
    CBMNavigationController *n;
    n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_STEPS];
    [self.revealSideViewController replaceCentralViewControllerWithNewController:n animated:YES animationDirection:PPRevealSideDirectionLeft completion:nil];
    PP_RELEASE(c);
    PP_RELEASE(n);
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        // do not try to update
        // once more...
        case 0:
        {
            [self showLeftWithPilots];
        }
            break;
    }
}

@end
