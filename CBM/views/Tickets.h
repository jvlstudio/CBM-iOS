//
//  Tickets.h
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"
#import "CBMPageControl.h"

@interface Tickets : CBMViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *plist;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *salepoints;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) IBOutlet UIView *rootView;
@property (nonatomic, strong) IBOutlet CBMPageControl *pagedControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollPass;

@property (nonatomic, strong) IBOutlet UIButton *btSales;
@property (nonatomic, strong) IBOutlet UIButton *btRules1;
@property (nonatomic, strong) IBOutlet UIButton *btRules2;

#pragma mark -
#pragma mark View Methods

- (void) configureTicketPassViews;
- (int) getNextStepIndex;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtSales:(id)sender;
- (IBAction) pressBtRules1:(id)sender;
- (IBAction) pressBtRules2:(id)sender;

- (void) touchPassView:(id) sender;

@end
