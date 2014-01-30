//
//  Pilot.m
//  CBM
//
//  Created by Felipe Ricieri on 27/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Pilot.h"
#import "PilotCell.h"
#import "PilotCarCell.h"
#import "PilotConstants.h"

#define PLACEHOLDER_BIO     @"A Biografia deste piloto ainda não está disponível. Por favor, aguarde a próxima atualização."

@implementation Pilot
{
    FRTools *tools;
    UpdateData *update;
}

@synthesize hasBackButton;
@synthesize plist;
@synthesize tableData;
@synthesize tableCarData;
@synthesize activity;
@synthesize tweetContent;
@synthesize tweetView;
@synthesize labelName;
@synthesize labelRanking;
@synthesize labelRating;
@synthesize labelPoints;
@synthesize imgViewShield;
@synthesize pilotBg;
@synthesize sectionView;
@synthesize btBio;
@synthesize btCar;
@synthesize btStatistic;
@synthesize pilotImage;
@synthesize bioView;
@synthesize table;
@synthesize tableCar;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;
{
    self = [super initCBMViewController:VC_PILOTS withTitle:@"PILOTO"];
    if(self)
    {
        hasBackButton = willHaveBackButton;
        plist = dDict;
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    if (hasBackButton)
        [super viewDidLoadWithBackButton];
    else
        [super viewDidLoadWithMenuButtonButShowPilots];
    
    [activity startAnimating];
    
    // data..
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    // vars..
    NSString *rating    = [NSString stringWithFormat:@"%@", [plist objectForKey:KEY_NUMBER]];
    NSString *points    = [NSString stringWithFormat:@"%@", [plist objectForKey:KEY_POINTS]];
    NSString *ranking   = [NSString stringWithFormat:@"%@", [plist objectForKey:KEY_RANKING]];
    
    // data
    tableData           = [plist objectForKey:KEY_META];
    tableCarData        = [plist objectForKey:KEY_META_CAR];
    
    // labels
    [self configureLabel:labelName withText:[plist objectForKey:KEY_NAME] andSize:25.0 andColor:COLOR_WHITE];
    [self configureLabel:labelRating withText:rating andSize:27.0 andColor:COLOR_GREEN];
    [self configureLabel:labelPoints withText:points andSize:27.0 andColor:COLOR_WHITE];
    [self configureLabel:labelRanking withText:ranking andSize:27.0 andColor:COLOR_WHITE];
    if ([[plist objectForKey:KEY_BIO] length] > 5)
        [bioView setText:[plist objectForKey:KEY_BIO]];
    else
        [bioView setText:PLACEHOLDER_BIO];
    
    NSString *shieldPilot = [NSString stringWithFormat:@"shield_large_%@.png", [plist objectForKey:KEY_SHIELD]];
    [imgViewShield setImage:[UIImage imageNamed:shieldPilot]];
    
    // add sections
    [sectionView setFrame:FRAME_SECTION_MIN2];
    [[self view] addSubview:sectionView];
    
    // configure tables
    [bioView setFrame:FRAME_TABLE_MIN0];
    [table setFrame:FRAME_TABLE_MIN1];
    [tableCar setFrame:FRAME_TABLE_MIN2];
    
    // add tables
    [[self view] addSubview:bioView];
    [[self view] addSubview:table];
    [[self view] addSubview:tableCar];
    
    [[self view] setClipsToBounds:YES];
    
    // pilot image
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@", URL_UPLOADS, [plist objectForKey:KEY_PICTURE]];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    __weak typeof(self) weakSelf = self;
    [pilotImage setImageWithURL:url
               placeholderImage:nil
                        options:SDWebImageCacheMemoryOnly
                        success:^(UIImage *image) {
                            [weakSelf.activity stopAnimating];
                            [weakSelf.activity setHidden:YES];
                            if(CGSizeEqualToSize(weakSelf.pilotImage.image.size, CGSizeZero))
                                [weakSelf.pilotImage setImage:[UIImage imageNamed:PILOT_NOIMAGE]];
                        }
                        failure:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // super..
    [super viewWillAppear:animated];
    [super configureViewController:self withTitle:@"PILOTO"];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtBio:(id)sender
{
    [self moveToBio];
}
- (IBAction) pressBtStatistic:(id)sender
{
    [self moveToStatistic];
}
- (IBAction) pressBtCar:(id)sender
{
    [self moveToCar];
}

#pragma mark -
#pragma mark UITableViewDataDelegate and UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/* rows */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == table)
        return 68;
    else
        return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == table)
        return [tableData count];
    else
        return [tableCarData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:MAIN_BUNDLE owner:nil options:nil];
    // data
    id cell      = nil;
    UIImageView *bgUp;
    
    // pilot cell...
    if( tableView == table )
    {
        // obj..
        NSDictionary *obj = [tableData objectAtIndex:indexPath.row];
        // cell..
        cell = (PilotCell *)[tableView dequeueReusableCellWithIdentifier:CELL_PILOT];
        if(!cell)
            cell = (PilotCell*)[xib objectAtIndex:0];
        // bg..
        int p = indexPath.row%2;
        if(p==0)
            bgUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_PILOT_LIGHT]];
        else
            bgUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_PILOT_DARK]];
        // label..
        [self configureLabel:[cell labelKey] withText:[[obj objectForKey:KEY_LABEL] uppercaseString] andSize:25.0 andColor:COLOR_GREY_LIGHT];
        [self configureLabel:[cell labelValue] withText:[obj objectForKey:KEY_VALUE] andSize:40.0 andColor:COLOR_GREY_LIGHT];
    }
    // pilot car cell..
    else {
        // obj..
        NSDictionary *obj = [tableCarData objectAtIndex:indexPath.row];
        // cell..
        cell = (PilotCarCell *)[tableView dequeueReusableCellWithIdentifier:CELL_PILOT_CAR];
        if(!cell)
            cell = (PilotCarCell*)[xib objectAtIndex:1];
        // bg..
        int p = indexPath.row%2;
        if(p==0)
            bgUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_PILOT_CAR_LIGHT]];
        else
            bgUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_PILOT_CAR_DARK]];
        // label..
        [self configureLabel:[cell labelKey] withText:[[obj objectForKey:KEY_LABEL] uppercaseString] andSize:18.0 andColor:COLOR_GREY_LIGHT];
        [self configureLabel:[cell labelValue] withText:[obj objectForKey:KEY_VALUE] andSize:14.0 andColor:COLOR_GREY_LIGHT];
    }
    
    [cell setBackgroundView:bgUp];
    
	return cell;
}

#pragma mark -
#pragma mark Move Methods

- (void) moveToBio
{
    [UIView animateWithDuration:DELAY
                     animations:^(void){
                         [pilotBg setFrame:FRAME_SECTION_MIN2];
                         [sectionView setFrame:FRAME_SECTION_MIN1];
                         [bioView setFrame:FRAME_TABLE_MIN1];
                         [table setFrame:FRAME_TABLE_MIN2];
                         [tableCar setFrame:FRAME_TABLE_MIN3];
    }];
}
- (void) moveToStatistic
{
    [UIView animateWithDuration:DELAY
                     animations:^(void){
                         [pilotBg setFrame:FRAME_SECTION_MIN2];
                         [sectionView setFrame:FRAME_SECTION_MIN2];
                         [bioView setFrame:FRAME_TABLE_MIN0];
                         [table setFrame:FRAME_TABLE_MIN1];
                         [tableCar setFrame:FRAME_TABLE_MIN2];
                     }];
}
- (void) moveToCar
{
    [UIView animateWithDuration:DELAY
                     animations:^(void){
                         [pilotBg setFrame:FRAME_SECTION_MAX2];
                         [sectionView setFrame:FRAME_SECTION_MAX3];
                         [bioView setFrame:FRAME_TABLE_MAX0];
                         [table setFrame:FRAME_TABLE_MAX0];
                         [tableCar setFrame:FRAME_TABLE_MAX1];
                     }];
}

@end
