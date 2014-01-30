//
//  News.h
//  CBM
//
//  Created by Felipe Ricieri on 28/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface News : CBMViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *dataReturn;
@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, strong) IBOutlet UITableView *table;

@end
