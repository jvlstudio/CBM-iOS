//
//  TicketSalesCell.h
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketSalesCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgBg;
@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelAddress;
@property (nonatomic, strong) IBOutlet UILabel *labelCity;

@end
