//
//  CBMNavigationController.h
//  CBM
//
//  Created by Felipe Ricieri on 31/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMNavigationController : UINavigationController

@property (nonatomic) BOOL letRotateToLandscape;

#pragma mark -
#pragma mark Init Methods

- (id) initWithCBMController:(UIViewController*) vc title:(NSString*) tit;
- (id) initWithCBMControllerAndLeftButton:(UIViewController*) vc title:(NSString*) tit;
- (id) initWithCBMControllerAndRightButton:(UIViewController*) vc title:(NSString*) tit;
- (id) initWithCBMControllerAndLeftAndRightButton:(UIViewController*) vc title:(NSString*) tit;

- (id) initNavigation:(UIViewController*) vc title:(NSString*) tit leftButton:(BOOL) lbt rightButton:(BOOL) rbt;

#pragma mark -
#pragma mark Other Methods

- (void) defaultFontTo: (UILabel*) label
              withSize:(float) size
              andColor:(UIColor*) color;

- (void) configureLabel:(UILabel*) label
               withText:(NSString*) text
                andSize:(float) size
               andColor:(UIColor*) color;

@end
