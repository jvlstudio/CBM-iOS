//
//  StepsResults.h
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMPageControl.h"

#import "StepsResultsCell.h"

@interface StepsResults : CBMViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary *stepDict;
@property (nonatomic, strong) NSArray *plist;

/* scrolls */

@property (nonatomic, strong) IBOutlet CBMPageControl *pagedControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollHeader;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollBody;
@property (nonatomic, strong) IBOutlet UIButton *scrollSetRight;
@property (nonatomic, strong) IBOutlet UIButton *scrollSetLeft;

@property (nonatomic, strong) IBOutlet UILabel *numStep;
@property (nonatomic, strong) IBOutlet UILabel *cityName;
@property (nonatomic, strong) IBOutlet UIImageView *imgPicture;

/* tables */

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSArray *tables;

@property (nonatomic, strong) IBOutlet UITableView *tableTrain1;
@property (nonatomic, strong) IBOutlet UITableView *tableTrain2;
@property (nonatomic, strong) IBOutlet UITableView *tableProof1;
@property (nonatomic, strong) IBOutlet UITableView *tableProof2;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressLeft:(id)sender;
- (IBAction) pressRight:(id)sender;
- (void) shakeToLeft;
- (void) shakeToRight;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dict;

#pragma mark -
#pragma mark Other Methods

- (void) configureLabelToHeader:(NSArray*) texts;
- (void) configureTable:(UITableView*) table toIndex:(int) index;

/* hack */

- (void) setValuesOfCell:(StepsResultsCell*) cell
               forObject:(NSDictionary*) obj
            andIndexPath:(NSIndexPath*) indexPath
                andTable:(UITableView*) tab;

@end
