//
//  StepsEndCell.m
//  CBM
//
//  Created by Felipe Ricieri on 26/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "StepsEndCell.h"

/* interface */

@interface StepsEndCell ()
- (void) animateIn;
- (void) animateOut;
@end

/* implementation */

@implementation StepsEndCell

@synthesize labDateDay;
@synthesize labDateMounth;
@synthesize imgViewFinished;
@synthesize numStep;
@synthesize cityName;

#pragma mark -
#pragma mark Animate Methods

- (void) startAnimation
{
    [labDateDay setAlpha:ZERO];
    [labDateMounth setAlpha:ZERO];
    [self animateIn];
}

- (void) animateIn
{
    [UIView animateWithDuration:0.8f animations:^{
        [[self imgViewFinished] setAlpha:ZERO];
        [[self labDateDay] setAlpha:1];
        [[self labDateMounth] setAlpha:1];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(animateOut) withObject:nil afterDelay:0.7];
    }];
}

- (void) animateOut
{
    [UIView animateWithDuration:0.8f animations:^{
        [[self imgViewFinished] setAlpha:1];
        [[self labDateDay] setAlpha:ZERO];
        [[self labDateMounth] setAlpha:ZERO];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(animateIn) withObject:nil afterDelay:0.7];
    }];
}

@end
