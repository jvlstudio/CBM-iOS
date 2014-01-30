//
//  TicketsRules.m
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "TicketsRules.h"

#define CONTENT_FRAME   CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT - NAVIGATIONBAR_HEIGHT)


@implementation TicketsRules

@synthesize content;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithCloseButton];
    
    // set current height
    if(!IS_IPHONE5)
    {
        [content setFrame:CONTENT_FRAME];
    }
}

@end
