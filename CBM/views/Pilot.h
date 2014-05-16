//
//  Pilot.h
//  CBM
//
//  Created by Felipe Ricieri on 27/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface Pilot : CBMViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIView *tweetView;
    IBOutlet UILabel *tweetContent;
    IBOutlet UIActivityIndicatorView *activity;
    
    IBOutlet UILabel *labelName;
    IBOutlet UILabel *labelPosition;
    IBOutlet UILabel *labelPoints;
    IBOutlet UILabel *labelNumber;
    IBOutlet UIImageView *imgViewShield;
    
    IBOutlet UIImageView *pilotBg;
    IBOutlet UIView *sectionView;
    IBOutlet UIButton *btBio;
    IBOutlet UIButton *btStatistic;
    IBOutlet UIButton *btCar;
    
    IBOutlet UIImageView *pilotImage;
    
    IBOutlet UITextView *bioView;
    IBOutlet UITableView *table;
    IBOutlet UITableView *tableCar;
}

/* data */

@property (nonatomic) BOOL hasBackButton;
@property (nonatomic, strong) NSDictionary *plist;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *tableCarData;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIImageView *pilotImage;

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
