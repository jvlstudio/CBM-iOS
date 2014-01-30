//
//  CBMBarButton.m
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMBarButton.h"

#define BUTTON_MENU     @"bt_menu_menu.png"
#define BUTTON_BACK     @"bt_back_menu.png"
#define BUTTON_CLOSE    @"bt_close.png"

@implementation CBMBarButton

- (id) initWithBack:(SEL)selector toTarget:(id)target
{
    UIButton *button = [self newButton:BUTTON_BACK];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    return self;
}

- (id) initWithMenu:(SEL)selector toTarget:(id)target
{
    UIButton *button = [self newButton:BUTTON_MENU];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    return self;
}

- (id) initWithClose:(SEL)selector toTarget:(id)target
{
    UIButton *button = [self newButton:BUTTON_CLOSE];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self = [super initWithCustomView:button];
    return self;
}

- (id) initWithTimer:(NSString *)timerText
{
    CGRect rectLabel    = CGRectMake(0, 5, 40, 30);
    UILabel *labtimer   = [[UILabel alloc] initWithFrame:rectLabel];
    [labtimer setTextAlignment:NSTextAlignmentCenter];
    [labtimer setTextColor:COLOR_WHITE];
    [labtimer setBackgroundColor:COLOR_CLEAR];
    [labtimer setFont:[UIFont fontWithName:FONT_NEOTECH size:25.0]];
    [labtimer setText:[NSString stringWithFormat:@"%@", timerText]];
    [labtimer alignBottom];
    
    UIView *viewLabel   = [[UIView alloc] initWithFrame:rectLabel];
    CGRect rectView     = viewLabel.frame;
    rectView.origin.y   = 0;
    [viewLabel setFrame:rectView];
    [viewLabel addSubview:labtimer];
    
    self = [super initWithCustomView:viewLabel];
    return self;
}

- (void) refreshTimerWithText:(NSString*) text
{
    
}

#pragma mark -
#pragma mark Methods

- (UIButton *)newButton:(NSString *)image
{
    UIImage *img = [UIImage imageNamed:image];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:img forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    return button;
}

@end
