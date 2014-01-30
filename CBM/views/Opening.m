//
//  Opening.m
//  CBM
//
//  Created by Felipe Ricieri on 07/08/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "Opening.h"

#define IMAGE_PIRELLI       @"start_pirelli.png"
#define IMAGE_BRANDCORE     @"start_brandcore.png"

#define DELAY               0.5f


@implementation Opening
{
    AppDelegate *delegate;
}

#pragma mark -
#pragma mark ViewControllers Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate            = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //imgViewPirelli      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_PIRELLI]];
    imgViewBrandcore    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_BRANDCORE]];
    
    CGRect rectImg      = CGRectMake(ZERO, ZERO, WINDOW_WIDTH, WINDOW_HEIGHT);
    //[imgViewPirelli setFrame:rectImg];
    [imgViewBrandcore setFrame:rectImg];
    
    [[self view] setBackgroundColor:COLOR_BLACK];
    //[imgViewPirelli setContentMode:UIViewContentModeCenter];
    [imgViewBrandcore setContentMode:UIViewContentModeCenter];
    
    //[imgViewPirelli setAlpha:ZERO];
    //[imgViewBrandcore setAlpha:ZERO];
    
    [[self view] addSubview:imgViewBrandcore];
    //[[self view] addSubview:imgViewPirelli];
    
    [self animateStart];
}

#pragma mark -
#pragma mark Methods

- (void)animateStart
{
    sleep(1);
    [UIView animateWithDuration:DELAY animations:^{
        [imgViewPirelli setAlpha:1];
    } completion:^(BOOL finished) {
        [imgViewBrandcore setAlpha:1];
        [self animateBrandcore];
    }];
}
- (void)animatePirelli
{
    sleep(2);
    [UIView transitionFromView:imgViewPirelli
                        toView:imgViewBrandcore
                      duration:(DELAY*2)
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished) {
                        [imgViewPirelli removeFromSuperview];
                        [self animateBrandcore];
    }];
}
- (void)animateBrandcore
{
    sleep(3);
    [UIView animateWithDuration:DELAY animations:^{
        [imgViewBrandcore setAlpha:0];
    } completion:^(BOOL finished) {
        [imgViewBrandcore removeFromSuperview];
        [self animateEnd];
    }];
}
- (void) animateEnd
{
    [[delegate window] setRootViewController:[delegate openingWithoutAnimation]];
}

#pragma mark -
#pragma mark Rotate Methods

// Older versions of iOS (deprecated) if supporting iOS < 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

// iOS6
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
