//
//  Pilot.h
//  CBM
//
//  Created by Felipe Ricieri on 27/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface Pilot : CBMViewController <UITableViewDelegate, UITableViewDataSource>

/* data */

@property (nonatomic) BOOL hasBackButton;
@property (nonatomic, strong) NSDictionary *plist;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *tableCarData;

/* tweet view */

@property (nonatomic, strong) IBOutlet UIView *tweetView;
@property (nonatomic, strong) IBOutlet UILabel *tweetContent;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

/* labels */

@property (nonatomic, strong) IBOutlet UILabel *labelName;
@property (nonatomic, strong) IBOutlet UILabel *labelRanking;
@property (nonatomic, strong) IBOutlet UILabel *labelPoints;
@property (nonatomic, strong) IBOutlet UILabel *labelRating;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewShield;

/* header */

@property (nonatomic, strong) IBOutlet UIImageView *pilotBg;
@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (nonatomic, strong) IBOutlet UIButton *btBio;
@property (nonatomic, strong) IBOutlet UIButton *btStatistic;
@property (nonatomic, strong) IBOutlet UIButton *btCar;

/* views: bio, statistics & car */

@property (nonatomic, strong) IBOutlet UIImageView *pilotImage;

@property (nonatomic, strong) IBOutlet UITextView *bioView;
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UITableView *tableCar;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtBio:(id)sender;
- (IBAction) pressBtStatistic:(id)sender;
- (IBAction) pressBtCar:(id)sender;

#pragma mark -
#pragma mark Move Methods

- (void) moveToBio;
- (void) moveToStatistic;
- (void) moveToCar;

@end
