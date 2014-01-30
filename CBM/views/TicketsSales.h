//
//  TicketsSales.h
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface TicketsSales : CBMViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *plist;
@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) IBOutlet UITableView *table;

#pragma mark -
#pragma mark Other Methods

- (BOOL) checkIfIsOpen: (NSIndexPath*) row;

@end
