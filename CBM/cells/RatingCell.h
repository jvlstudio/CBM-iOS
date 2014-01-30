//
//  RatingCell.h
//  CBM
//
//  Created by Felipe Ricieri on 22/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *numberRanking;
@property (nonatomic, strong) IBOutlet UILabel *numberCar;
@property (nonatomic, strong) IBOutlet UILabel *pilotName;
@property (nonatomic, strong) IBOutlet UILabel *teamName;
@property (nonatomic, strong) IBOutlet UILabel *carName;
@property (nonatomic, strong) IBOutlet UILabel *points;

@end
