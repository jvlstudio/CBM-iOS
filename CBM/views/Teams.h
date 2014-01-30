//
//  Teams.h
//  CBM
//
//  Created by Felipe Ricieri on 29/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface Teams : CBMViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL hasBackButton;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSArray *plistPilots;
@property (nonatomic, strong) NSMutableArray *dataPilots;
@property (nonatomic, strong) NSArray *dataMeta;

/* table */

@property (nonatomic, strong) IBOutlet UITableView *table;

/* labels */

@property (nonatomic, strong) IBOutlet UIImageView *imgViewCover;
@property (nonatomic, strong) IBOutlet UILabel *labName;
@property (nonatomic, strong) IBOutlet UILabel *labRanking;
@property (nonatomic, strong) IBOutlet UILabel *labPoints;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict;
- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL)willHaveBackButton;

#pragma mark -
#pragma mark Merge Actions

- (NSString*) mergeBackgroundForIndex:(int)index;

@end
