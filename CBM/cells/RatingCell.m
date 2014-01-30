//
//  RatingCell.m
//  CBM
//
//  Created by Felipe Ricieri on 22/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "RatingCell.h"

@implementation RatingCell

@synthesize numberRanking;
@synthesize numberCar;
@synthesize pilotName;
@synthesize teamName;
@synthesize carName;
@synthesize points;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
