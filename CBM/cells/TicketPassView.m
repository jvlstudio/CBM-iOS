//
//  TicketPassView.m
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "TicketPassView.h"

@implementation TicketPassView

@synthesize numStep;
@synthesize cityName;
@synthesize dateDayMounth;
@synthesize dateWeek;
@synthesize circuit;
@synthesize but;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
