//
//  TeamPilotCell.h
//  CBM
//
//  Created by Felipe Ricieri on 29/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamPilotCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labPilotNumber;
@property (nonatomic, strong) IBOutlet UILabel *labPilotName;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewPilot;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@end
