//
//  CBMRefreshView.h
//  CBM
//
//  Created by Felipe Ricieri on 19/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBMRefreshView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBackground;

#pragma mark -
#pragma mark Methods

- (void) initActivity;
- (void) endActivity;

@end
