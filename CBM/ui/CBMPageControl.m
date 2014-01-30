//
//  CBMPageControl.m
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMPageControl.h"

#define ICON_FULL @"paged_ball_on.png"
#define ICON_EMPTY @"paged_ball_off.png"

@implementation CBMPageControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        activeImage = [UIImage imageNamed:ICON_FULL];
        inactiveImage = [UIImage imageNamed:ICON_EMPTY];
        [self updateDots];
    }
    return self;
}

-(void) updateDots
{
    /*
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }*/
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    [self updateDots];
}

@end
