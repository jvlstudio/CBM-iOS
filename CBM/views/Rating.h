//
//  Rating.h
//  CBM
//
//  Created by Felipe Ricieri on 22/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMRatingSwitch.h"

@interface Rating : CBMViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *plist;
@property (nonatomic, strong) NSArray *pilotsData;
@property (nonatomic, strong) NSArray *shieldsData;
@property (nonatomic, strong) NSArray *teamsData;

/* top levels */

@property (nonatomic, strong) IBOutlet UIImageView *arrow;
@property (nonatomic, strong) IBOutlet UILabel *labSectionLabel1;
@property (nonatomic, strong) IBOutlet UILabel *labSectionLabel2;
@property (nonatomic, strong) IBOutlet UILabel *labSectionLabel3;

@property (nonatomic, strong) IBOutlet UILabel *labelPilots;
@property (nonatomic, strong) IBOutlet UILabel *labelShields;
@property (nonatomic, strong) IBOutlet UILabel *labelTeams;

@property (nonatomic, strong) IBOutlet UIButton *butPilots;
@property (nonatomic, strong) IBOutlet UIButton *butShields;
@property (nonatomic, strong) IBOutlet UIButton *butTeams;

/* tables */

@property (nonatomic, strong) IBOutlet UITableView *pilotsTable;
@property (nonatomic, strong) IBOutlet UITableView *shieldsTable;
@property (nonatomic, strong) IBOutlet UITableView *teamsTable;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilots:(id)sender;
- (IBAction) pressShields:(id)sender;
- (IBAction) pressTeams:(id)sender;

@end
