//
//  StepsEndCell.h
//  CBM
//
//  Created by Felipe Ricieri on 26/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsEndCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labDateDay;
@property (nonatomic, strong) IBOutlet UILabel *labDateMounth;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewFinished;
@property (nonatomic, strong) IBOutlet UILabel *numStep;
@property (nonatomic, strong) IBOutlet UILabel *cityName;

#pragma mark -
#pragma mark Animate Methods

- (void) startAnimation;

@end
