//
//  StepsCell.h
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *dateDay;
@property (nonatomic, strong) IBOutlet UILabel *dateMounth;
@property (nonatomic, strong) IBOutlet UILabel *numStep;
@property (nonatomic, strong) IBOutlet UILabel *cityName;

@end
