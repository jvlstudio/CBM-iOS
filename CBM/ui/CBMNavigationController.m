//
//  CBMNavigationController.m
//  CBM
//
//  Created by Felipe Ricieri on 31/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMNavigationController.h"

#define BG_NAV_00   @"bg_navigationbar_00.png"
#define BG_NAV_01   @"bg_navigationbar_01.png"
#define BG_NAV_02   @"bg_navigationbar_02.png"
#define BG_NAV_03   @"bg_navigationbar_03.png"
#define BG_NAV_LAND @"bg_navigationbar_landscape.png"

@implementation CBMNavigationController

@synthesize letRotateToLandscape;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Init Methods

- (id) initWithCBMController:(UIViewController*) vc title:(NSString*) tit
{
    self = [self initNavigation:vc title:tit leftButton:NO rightButton:NO];
    letRotateToLandscape = NO;
    return self;
}
- (id) initWithCBMControllerAndLeftButton:(UIViewController*) vc title:(NSString*) tit
{
    self = [self initNavigation:vc title:tit leftButton:YES rightButton:NO];
    letRotateToLandscape = NO;
    return self;
}
- (id) initWithCBMControllerAndRightButton:(UIViewController*) vc title:(NSString*) tit
{
    self = [self initNavigation:vc title:tit leftButton:NO rightButton:YES];
    letRotateToLandscape = NO;
    return self;
}
- (id) initWithCBMControllerAndLeftAndRightButton:(UIViewController*) vc title:(NSString*) tit
{
    self = [self initNavigation:vc title:tit leftButton:YES rightButton:YES];
    letRotateToLandscape = NO;
    return self;
}

- (id) initNavigation:(UIViewController*) vc title:(NSString*) tit leftButton:(BOOL) lbt rightButton:(BOOL) rbt
{
    self = [super initWithRootViewController:vc];
    
    tit = [tit uppercaseString];
    [vc setTitle:tit];
    
    CGRect frame;
    UILabel *label = [[UILabel alloc] init];
    CGSize fontSize = [tit sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:label.font.pointSize]}];
    [label setText:tit];
    [label alignBottom];
    
    if([tit isEqualToString: [TITLE_HOME uppercaseString]]){
        frame = CGRectMake(ZERO, ZERO, fontSize.width, 44);
        [self defaultFontTo:label withSize:16.0 andColor:COLOR_YELLOW];
    }else{
        frame = CGRectMake(ZERO, ZERO, fontSize.width, 44);
        [self defaultFontTo:label withSize:22.0 andColor:COLOR_WHITE];
    }
    [label setFrame:frame];
    
    [label setBackgroundColor:COLOR_CLEAR];
    [label setTextAlignment:NSTextAlignmentCenter];
    // shadow
    [label setShadowColor:COLOR_BLACK];
    [label setShadowOffset:CGSizeMake(0, -1.5)];
    // text
    [vc setTitle:tit];
    
    // view for title...
    UIView *vv = [[UIView alloc] initWithFrame:[label frame]];
    CGRect frameLabel   = [label frame];
    frameLabel.origin.y = 5;
    frameLabel.size.width += 13;
    [label setFrame:frameLabel];
    
    // set title view..
    [vv addSubview:label];
    [[vc navigationItem] setTitleView:vv];
    
    /*
    // left & right button
    if( !lbt && !rbt )
        [[self navigationBar] setBackgroundImage:[UIImage imageNamed:BG_NAV_00] forBarMetrics:UIBarMetricsDefault];
    
    // left & right button
    if( lbt && rbt )
        [[self navigationBar] setBackgroundImage:[UIImage imageNamed:BG_NAV_03] forBarMetrics:UIBarMetricsDefault];
    else
    {
        // left button
        if( lbt )
            [[self navigationBar] setBackgroundImage:[UIImage imageNamed:BG_NAV_01] forBarMetrics:UIBarMetricsDefault];
        // right button
        if ( rbt )
            [[self navigationBar] setBackgroundImage:[UIImage imageNamed:BG_NAV_02] forBarMetrics:UIBarMetricsDefault];
    }
    [[self navigationBar] setBackgroundImage:[UIImage imageNamed:BG_NAV_LAND] forBarMetrics:UIBarMetricsLandscapePhone];
    */
    
    [[self navigationBar] setTranslucent:NO];
    [[self navigationBar] setBarTintColor:[UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1]];
    
    return self;
}

#pragma mark -
#pragma mark Other Methods

- (void) defaultFontTo: (UILabel*) label
              withSize:(float) size
              andColor:(UIColor*) color
{
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setTextColor:color];
    [label setFont:[UIFont fontWithName:FONT_NAME size:size]];
}

- (void) configureLabel:(UILabel*) label
               withText:(NSString*) text
                andSize:(float) size
               andColor:(UIColor*) color
{
    [self defaultFontTo:label withSize:size andColor:color];
    [label setText:text];
}

#pragma mark -
#pragma mark Rotate Methods

// Older versions of iOS (deprecated) if supporting iOS < 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(letRotateToLandscape)
        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    else
        return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

// iOS6
- (BOOL)shouldAutorotate
{
    return letRotateToLandscape;
}
- (NSUInteger)supportedInterfaceOrientations
{
    if (letRotateToLandscape)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

@end
