//
//  CBMBarButton.h
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMBarButton : UIBarButtonItem

- (id) initWithBack:(SEL)selector toTarget:(id)target;
- (id) initWithMenu:(SEL)selector toTarget:(id)target;
- (id) initWithClose:(SEL)selector toTarget:(id)target;
- (id) initWithTimer:(NSString*) timerText;

- (void) refreshTimerWithText:(NSString*) text;

#pragma mark -
#pragma mark Methods

- (UIButton*) newButton: (NSString*) image;

@end
