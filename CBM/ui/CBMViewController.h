//
//  CBMViewController.h
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Webservice.h"

@interface CBMViewController : UIViewController
{
    NSUserDefaults *defaults;
    Webservice *webservice;
}

@property (nonatomic, strong) Webservice *webservice;
@property (nonatomic, strong) UIImageView *backgroundTransparent;

#pragma mark -
#pragma mark Init Methods

- (id) initCBMViewController:(NSString *)name;
- (id) initCBMViewController:(NSString *)name withTitle:(NSString*) title;

#pragma mark -
#pragma mark ViewController Methods

- (void) viewDidLoadWithMenuButton;
- (void) viewDidLoadWithMenuButtonButShowPilots;
- (void) viewDidLoadWithMenuButtonButShowTeams;
- (void) viewDidLoadWithBackButton;
- (void) viewDidLoadWithCloseButton;

#pragma mark -
#pragma mark Other Methods

- (void) addHiddenView: (UIView*) v
               toTable: (UITableView*) t;

- (void) defaultFontTo: (UILabel*) label
              withSize:(float) size
              andColor:(UIColor*) color;

- (void) configureLabel:(UILabel*) label
               withText:(NSString*) text
                andSize:(float) size
               andColor:(UIColor*) color;

- (void) configureViewController:(UIViewController*) vc
                       withTitle:(NSString*) titleToConfigure;

- (NSString*) correctNumberFor:(NSString*) num;

#pragma mark -
#pragma mark BarButton Methods

- (void) setMenuButton;
- (void) setMenuButtonForPilots;
- (void) setMenuButtonForTeams;
- (void) setBackButton;
- (void) setCloseButton;

#pragma mark -
#pragma mark IBAction Methods

- (void) pressMenuButton:(id)sender;
- (void) pressMenuButtonForPilots:(id)sender;
- (void) pressMenuButtonForTeams:(id)sender;
- (void) pressBackButton:(id)sender;
- (void) pressCloseButton:(id)sender;

#pragma mark -
#pragma mark Side Menu Methods

- (void) preloadLeft;
- (void) showLeft;
- (void) showLeftWithPilots;
- (void) showLeftWithTeams;

#pragma mark -
#pragma mark Animate Methods

- (void) animateShowBackground;
- (void) animateHideBackground;

@end
