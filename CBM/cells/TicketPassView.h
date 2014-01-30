//
//  TicketPassView.h
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketPassView : UIView

@property (nonatomic, strong) IBOutlet UILabel *numStep;
@property (nonatomic, strong) IBOutlet UILabel *cityName;
@property (nonatomic, strong) IBOutlet UILabel *dateDayMounth;
@property (nonatomic, strong) IBOutlet UILabel *dateWeek;
@property (nonatomic, strong) IBOutlet UILabel *circuit;

@property (nonatomic, strong) IBOutlet UIButton *but;

@end
