//
//  LiveSingle.h
//  CBM
//
//  Created by Felipe Ricieri on 05/08/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMPageControl.h"

#import "LiveConstants.h"

@interface LiveSingle : CBMViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic) CurrentUIInterfaceOrientation orient;
@property (nonatomic, strong) NSDictionary *stepDict;

/* scrolls */

@property (nonatomic, strong) IBOutlet CBMPageControl *pagedControl;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackground;
@property (nonatomic, strong) IBOutlet UIView *vHeader;
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

@property (nonatomic, strong) UITableView *tableTrain1;
@property (nonatomic, strong) UITableView *tableTrain2;
@property (nonatomic, strong) UITableView *tableProof1;
@property (nonatomic, strong) UITableView *tableProof2;

/* landscape */

@property (nonatomic, strong) IBOutlet UIView *vPortrait;
@property (nonatomic, strong) IBOutlet UIView *vLandscape;
@property (nonatomic, strong) IBOutlet CBMPageControl *pcLandscape;
@property (nonatomic, strong) IBOutlet UIScrollView *scrLandscape;

@property (nonatomic, strong) NSArray *tablesLandscape;
@property (nonatomic, strong) UITableView *tableLand1;
@property (nonatomic, strong) UITableView *tableLand2;
@property (nonatomic, strong) UITableView *tableLand3;
@property (nonatomic, strong) UITableView *tableLand4;

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
#pragma mark Timer Methods

- (void) loadRows;
- (void) updateRows:(id)sender;
- (void) processData:(NSArray *)arrayOfProofs;

#pragma mark -
#pragma mark Other Methods

- (void) configureLabelToHeader:(NSArray*) texts;
- (void) setValuesOfCell:(UITableViewCell*) dcell
               forObject:(NSDictionary*) obj
            andIndexPath:(NSIndexPath*) indexPath
                andTable:(UITableView*) tab
                toOrient:(CurrentUIInterfaceOrientation) orientation;

#pragma mark -
#pragma mark Rotate Methods

- (void) rotateViewToOrientation;
- (void) rotateViewToOrientationPortrait;
- (void) rotateViewToOrientationLandscape;

@end
