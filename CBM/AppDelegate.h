//
//  AppDelegate.h
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@class HomeSimple;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeSimple *viewController;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;

#pragma mark -
#pragma mark Opening Methods

- (UIViewController*) openingWithAnimation;
- (UIViewController*) openingWithoutAnimation;

@end
