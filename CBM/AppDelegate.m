//
//  AppDelegate.m
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeSimple.h"
#import "Opening.h"

@implementation AppDelegate

@synthesize revealSideViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = PP_AUTORELEASE([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    // Let the device know we want to receive push notifications
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_APP_SECRET];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
	[application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	// local notifications..
    [application cancelAllLocalNotifications];
    
    // facebook
    [PFFacebookUtils initializeFacebook];
    
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
    self.window.rootViewController = [self openingWithAnimation];
    [self.window makeKeyAndVisible];
    
    // return..
    return YES;
}

#pragma mark -
#pragma mark Opening Methods

- (UIViewController*) openingWithAnimation
{
    Opening *opening = [[Opening alloc] initWithNibName:@"Opening" bundle:nil];
    return opening;
}
- (UIViewController*) openingWithoutAnimation
{
    // RevealSlideController..
    self.viewController         = [[HomeSimple alloc] initCBMViewController:@"HomeSimple"];
    [self.viewController setMenuButton];
    CBMNavigationController *nav = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:self.viewController title:TITLE_HOME];
    
    revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    revealSideViewController.delegate = self;
    
    PP_RELEASE(self.viewController);
    PP_RELEASE(nav);
    
    return revealSideViewController;
}

#pragma mark -
#pragma mark Facebook Methods

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

#pragma mark -
#pragma mark UIDevice Methods

- (BOOL)checkIsDeviceVersionHigherThanRequiredVersion:(NSString *)requiredVersion
{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer compare:requiredVersion options:NSNumericSearch] != NSOrderedAscending)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark APNS Configuration

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Local Notification: App está ativo.");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PFPush storeDeviceToken:devToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#if !TARGET_IPHONE_SIMULATOR
	NSLog(@"Error in registration. Error: %@", error);
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

@end
