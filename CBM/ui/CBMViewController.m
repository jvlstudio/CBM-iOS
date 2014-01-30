//
//  CBMViewController.m
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMBarButton.h"

#import "Menu.h"

#define BG_NAV_00 @"bg_navigationbar_00.png"
#define BG_NAV_01 @"bg_navigationbar_01.png"
#define BG_NAV_02 @"bg_navigationbar_02.png"
#define BG_NAV_03 @"bg_navigationbar_03.png"

#define DELAY           0.3
#define BACKGROUND_SHOW 0.7
#define BACKGROUND_HIDE 0.0

@implementation CBMViewController
{
    FRTools *tools;
}

@synthesize backgroundTransparent;

#pragma mark -
#pragma mark Init Methods

- (id) initCBMViewController:(NSString *)name
{
    tools       = [[FRTools alloc] initWithTools];
    self        = [super initWithNibName:name bundle:nil];
    return self;
}

- (id) initCBMViewController:(NSString *)name
                  withTitle:(NSString *)title
{
    tools       = [[FRTools alloc] initWithTools];
    self        = [super initWithNibName:name bundle:nil];
    if(self)
    {
        CGRect frame = CGRectMake(ZERO, ZERO, WINDOW_WIDTH, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        
        [self defaultFontTo:label withSize:22.0 andColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        // shadow
        [label setShadowColor:[UIColor darkGrayColor]];
        [label setShadowOffset:CGSizeMake(0, -0.5)];
        // text
        [label setText:title];
        [self setTitle:title];
        
        [[self navigationItem] setTitleView:label];
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void) viewDidLoadWithMenuButton
{
    [super viewDidLoad];
    [self setMenuButton];
}

- (void) viewDidLoadWithMenuButtonButShowPilots
{
    [super viewDidLoad];
    [self setMenuButtonForPilots];
}

- (void) viewDidLoadWithMenuButtonButShowTeams
{
    [super viewDidLoad];
    [self setMenuButtonForTeams];
}

- (void)viewDidLoadWithBackButton
{
    [super viewDidLoad];
    [self setBackButton];
}

- (void)viewDidLoadWithCloseButton
{
    [super viewDidLoad];
    [self setCloseButton];
}

/* */

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // left (menu)
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:DELAY];
}

#pragma mark -
#pragma mark Other Methods

- (void) addHiddenView: (UIView*) v toTable: (UITableView*) t
{
    t.tableHeaderView = v;
    [t setContentInset:UIEdgeInsetsMake(-v.bounds.size.height, 0.0f, 0.0f, 0.0f)];
}

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

- (void) configureViewController:(UIViewController*) vc withTitle:(NSString*) titleToConfigure
{
    // title..
    CGRect frame;
    UILabel *label  = [[UILabel alloc] init];
    NSString *tit   = vc.title;
    [label setText:tit];
    [label alignBottom];
    
    CGSize fontSize = [tit sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:label.font.pointSize]}];
    frame = CGRectMake(ZERO, ZERO, fontSize.width, 44);
    [self defaultFontTo:label withSize:22.0 andColor:COLOR_WHITE];
    
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
}

- (NSString*) correctNumberFor:(NSString*) num
{
    int j           = [num intValue];
    NSString *nPos  = (j > 9
                       ? [NSString stringWithFormat:@"%i", j]
                       : [NSString stringWithFormat:@"0%i", j]);
    return nPos;
}

#pragma mark -
#pragma mark BarButton Methods

- (void) setBackButton
{
    UIBarButtonItem *bt = [[CBMBarButton alloc] initWithBack:@selector(pressBackButton:) toTarget:self];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = bt;
}

- (void) setMenuButton
{
    UIBarButtonItem *bt = [[CBMBarButton alloc] initWithMenu:@selector(pressMenuButton:) toTarget:self];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = PP_AUTORELEASE(bt);
    
    backgroundTransparent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_transparent.png"]];
    [backgroundTransparent setAlpha:BACKGROUND_HIDE];
    [backgroundTransparent setHidden:YES];
    [[self view] addSubview:backgroundTransparent];
    
    // reinit the bouncing directions (should not be done in your own implementation, this is just for the sample)
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
}

- (void) setMenuButtonForPilots
{
    UIBarButtonItem *bt = [[CBMBarButton alloc] initWithMenu:@selector(pressMenuButtonForPilots:) toTarget:self];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = PP_AUTORELEASE(bt);
    
    backgroundTransparent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_transparent.png"]];
    [backgroundTransparent setAlpha:BACKGROUND_HIDE];
    [backgroundTransparent setHidden:YES];
    [[self view] addSubview:backgroundTransparent];
    
    // reinit the bouncing directions (should not be done in your own implementation, this is just for the sample)
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
}

- (void) setMenuButtonForTeams
{
    UIBarButtonItem *bt = [[CBMBarButton alloc] initWithMenu:@selector(pressMenuButtonForTeams:) toTarget:self];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = PP_AUTORELEASE(bt);
    
    backgroundTransparent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_transparent.png"]];
    [backgroundTransparent setAlpha:BACKGROUND_HIDE];
    [backgroundTransparent setHidden:YES];
    [[self view] addSubview:backgroundTransparent];
    
    // reinit the bouncing directions (should not be done in your own implementation, this is just for the sample)
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
}

- (void) setCloseButton
{
    UIBarButtonItem *bt = [[CBMBarButton alloc] initWithClose:@selector(pressCloseButton:) toTarget:self];
    self.navigationItem.rightBarButtonItem = bt;
}

#pragma mark -
#pragma mark IBAction Methods

- (void) pressMenuButton:(id)sender
{
    [self showLeft];
}

- (void) pressMenuButtonForPilots:(id)sender
{
    [self showLeftWithPilots];
}

- (void) pressMenuButtonForTeams:(id)sender
{
    [self showLeftWithTeams];
}

- (void) pressBackButton:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) pressCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Side Menu Methods

- (void) preloadLeft
{
    Menu *c = [[Menu alloc] initCBMViewController:@"Menu"];
    [self.revealSideViewController preloadViewController:c
                                                 forSide:PPRevealSideDirectionLeft
                                              withOffset:SIDE_MENU_OFFSET];
    PP_RELEASE(c);
}

- (void) showLeft
{
    Menu *c = [[Menu alloc] initWithMenuType:kTypeMenuData];
    
    [self.revealSideViewController pushViewController:c
                                          onDirection:PPRevealSideDirectionLeft
                                           withOffset:SIDE_MENU_OFFSET
                                             animated:YES];
    
    PP_RELEASE(c);
    
    // animate..
    if(backgroundTransparent.alpha == BACKGROUND_HIDE)
        [self animateShowBackground];
    else
        [self animateHideBackground];
}

- (void) showLeftWithPilots
{
    Menu *c = [[Menu alloc] initWithMenuType:kTypeMenuPilots];
    
    [self.revealSideViewController pushViewController:c
                                          onDirection:PPRevealSideDirectionLeft
                                           withOffset:SIDE_MENU_OFFSET
                                             animated:YES];
    
    PP_RELEASE(c);
    
    // animate..
    if(backgroundTransparent.alpha == BACKGROUND_HIDE)
        [self animateShowBackground];
    else
        [self animateHideBackground];
}

- (void) showLeftWithTeams
{
    Menu *c = [[Menu alloc] initWithMenuType:kTypeMenuTeams];
    
    [self.revealSideViewController pushViewController:c
                                          onDirection:PPRevealSideDirectionLeft
                                           withOffset:SIDE_MENU_OFFSET
                                             animated:YES];
    
    PP_RELEASE(c);
    
    // animate..
    if(backgroundTransparent.alpha == BACKGROUND_HIDE)
        [self animateShowBackground];
    else
        [self animateHideBackground];
}

#pragma mark -
#pragma mark Animate Methods

- (void) animateShowBackground
{
    [[self view] setUserInteractionEnabled:NO];
    [[self view] bringSubviewToFront:backgroundTransparent];
    [backgroundTransparent setHidden:NO];
    [UIView animateWithDuration:DELAY
                     animations:^(void){
                         [backgroundTransparent setAlpha:BACKGROUND_SHOW];
                     }];
}

- (void) animateHideBackground
{
    [[self view] setUserInteractionEnabled:YES];
    [[self view] bringSubviewToFront:backgroundTransparent];
    [UIView animateWithDuration:DELAY
                     animations:^(void){
                         [backgroundTransparent setAlpha:BACKGROUND_HIDE];
                     } completion:^(BOOL finished){
                         [backgroundTransparent setHidden:YES];
                     }];
}

@end
