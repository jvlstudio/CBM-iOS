//
//  Opening.h
//  CBM
//
//  Created by Felipe Ricieri on 07/08/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface Opening : CBMViewController
{
    UIImageView *imgViewPirelli;
    UIImageView *imgViewBrandcore;
}

#pragma mark -
#pragma mark Methods

- (void) animateStart;
- (void) animatePirelli;
- (void) animateBrandcore;
- (void) animateEnd;

@end
