//
//  Steps.h
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface Steps : CBMViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UIImageView *tableHeader;

@end
