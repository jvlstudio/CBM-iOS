//
//  StepsResultsCell.h
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsResultsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *numPosition;
@property (nonatomic, strong) IBOutlet UILabel *pilot;
@property (nonatomic, strong) IBOutlet UILabel *lapTime;
@property (nonatomic, strong) IBOutlet UILabel *gap;
@property (nonatomic, strong) IBOutlet UILabel *laps;

@end
