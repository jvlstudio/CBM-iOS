//
//  CBMRefreshView.m
//  CBM
//
//  Created by Felipe Ricieri on 19/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMRefreshView.h"

@implementation CBMRefreshView

@synthesize imgViewBackground;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

#pragma mark -
#pragma mark Methods

- (void) initActivity
{
    [imgViewBackground setAlpha:0];
    [UIView animateWithDuration:0.5f animations:^(void){
        [imgViewBackground setAlpha:0.8];
    }];
}

- (void) endActivity
{
    [UIView animateWithDuration:0.5f animations:^(void){
        [imgViewBackground setAlpha:0];
    }];
}

@end
