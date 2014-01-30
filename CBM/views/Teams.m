//
//  Teams.m
//  CBM
//
//  Created by Felipe Ricieri on 29/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Teams.h"
#import "TeamCell.h"
#import "TeamPilotCell.h"

#import "Pilot.h"

#define SECTION_PILOT           0
#define SECTION_INFO            1

#define XIB_RESOURCES           @"TeamResources"
#define RESOURCES_CELL          0
#define RESOURCES_CELL_PILOT    1
#define IDENTIFIER_CELL         @"teamCell"
#define IDENTIFIER_CELL_PILOT   @"teamPilotCell"

#define BG_CELL                 @"cell_teams_1.png"
#define BG_CELL_ALTERNATIVE     @"cell_teams_2.png"
#define BG_CELL_PILOT           @"cell_teams_pilot.png"

@interface Teams ()
- (void) setInfo;
@end

@implementation Teams
{
    FRTools *tools;
}

@synthesize hasBackButton;
@synthesize dict;
@synthesize plistPilots;
@synthesize dataPilots, dataMeta;
@synthesize table;
@synthesize imgViewCover;
@synthesize labName, labPoints, labRanking;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict
{
    self    = [super initCBMViewController:VC_TEAMS withTitle:@"EQUIPE"];
    if(self)
    {
        hasBackButton = NO;
        dict = dDict;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;
{
    self = [super initCBMViewController:VC_TEAMS withTitle:@"EQUIPE"];
    if(self)
    {
        hasBackButton = willHaveBackButton;
        dict = dDict;
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
        [super viewDidLoadWithMenuButtonButShowTeams];
    
    // ..
    [self setInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    // super..
    [super viewWillAppear:animated];
    [super configureViewController:self withTitle:@"EQUIPE"];
}

#pragma mark -
#pragma mark Methods

- (void)setInfo
{
    // data..
    tools           = [[FRTools alloc] initWithTools];
    plistPilots     = [tools propertyListRead:PLIST_PILOTS];
    
    dataPilots      = [NSMutableArray array];
    dataMeta        = [dict objectForKey:KEY_META];
    
    for (NSDictionary *aPilot in plistPilots)
    {
        for (NSString *bPilot in [dict objectForKey:KEY_PILOTS])
        {
            if ([[aPilot objectForKey:KEY_SLUG] isEqual:bPilot])
            {
                [dataPilots addObject:aPilot];
            }
        }
    }
    
    // labels..
    NSString *points    = [NSString stringWithFormat:@"%i", [[dict objectForKey:KEY_POINTS] intValue]];
    NSString *ranking   = [NSString stringWithFormat:@"%i", [[dict objectForKey:KEY_RANKING] intValue]];
    [self configureLabel:labName withText:[[dict objectForKey:KEY_NAME] uppercaseString] andSize:25.0 andColor:COLOR_WHITE];
    [self configureLabel:labRanking withText:ranking andSize:25.0 andColor:COLOR_WHITE];
    [self configureLabel:labPoints withText:points andSize:20.0 andColor:COLOR_WHITE];
    
    NSString *bgCover   = [NSString stringWithFormat:@"team_%@.png", [dict objectForKey:KEY_SLUG]];
    [imgViewCover setImage:[UIImage imageNamed:bgCover]];
    
    // rect..
    CGRect rectTable         = table.frame;
    rectTable.size.height   -= IPHONE5_COEF;
    [table setFrame:rectTable];
}

#pragma mark -
#pragma mark Merge Actions

- (NSString*) mergeBackgroundForIndex:(int)index
{
    int res = index%2;
    if (res == ZERO)
        return BG_CELL;
    else
        return BG_CELL_ALTERNATIVE;
}

#pragma mark -
#pragma mark UITableViewDataDelegate and UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 1)];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

/* rows */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForCell = 2.0;
    switch (indexPath.section)
    {
        case SECTION_PILOT:
        {
            heightForCell = 42.0;
        }
            break;
        case SECTION_INFO:
        {
            heightForCell = 50.0;
        }
            break;
    }
    return heightForCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section)
    {
        case SECTION_PILOT:
        {
            numberOfRows = [dataPilots count];
        }
            break;
        case SECTION_INFO:
        {
            numberOfRows = [dataMeta count];
        }
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib    = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell;
    
    if (indexPath.section == SECTION_PILOT)
    {
        NSDictionary *obj = [dataPilots objectAtIndex:indexPath.row];
        cell = (TeamPilotCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_CELL_PILOT];
        if(!cell)
            cell = (TeamPilotCell*)[xib objectAtIndex:RESOURCES_CELL_PILOT];
        
        int number = [[obj objectForKey:KEY_NUMBER] intValue];
        NSString *strNumber = number < 10 ? [NSString stringWithFormat:@"0%i", number] : [NSString stringWithFormat:@"%i", number];
        [self configureLabel:[cell labPilotNumber] withText:strNumber andSize:33.0 andColor:COLOR_GREEN];
        [self configureLabel:[cell labPilotName] withText:[[obj objectForKey:KEY_NAME] uppercaseString] andSize:15.0 andColor:COLOR_WHITE];
        
        // img..
        [[cell activity] startAnimating];
        NSString *imgUrl    = [NSString stringWithFormat:@"%@/pilot_%@.png", URL_UPLOADS, [obj objectForKey:KEY_SLUG]];
        NSURL *url          = [NSURL URLWithString:imgUrl];
        [[cell imgViewPilot] setImageWithURL:url
                            placeholderImage:nil
                                     options:SDWebImageCacheMemoryOnly
                                     success:^(UIImage *image)
         {
             [[cell activity] stopAnimating];
             [[cell activity] setHidden:YES];
             if(CGSizeEqualToSize([cell imgViewPilot].image.size, CGSizeZero))
                 [[cell imgViewPilot] setImage:[UIImage imageNamed:PILOT_NOIMAGE]];
         }
                                     failure:nil];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_CELL_PILOT]];
        [cell setBackgroundView:bg];
        return cell;
    }
    // meta..
    else
    {
        NSDictionary *obj = [dataMeta objectAtIndex:indexPath.row];
        cell = (TeamCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_CELL];
        if(!cell)
            cell = (TeamCell*)[xib objectAtIndex:RESOURCES_CELL];
        
        [self configureLabel:[cell labLabel] withText:[[obj objectForKey:KEY_LABEL] uppercaseString] andSize:12.0 andColor:COLOR_GREY_LIGHT];
        [self configureLabel:[cell labValue] withText:[[obj objectForKey:KEY_VALUE] uppercaseString] andSize:19.0 andColor:COLOR_GREY_LIGHT];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self mergeBackgroundForIndex:indexPath.row]]];
        [cell setBackgroundView:bg];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // index..
    switch (indexPath.section)
    {
        // pilots..
        case SECTION_PILOT:
        {
            NSDictionary *pilot = [dataPilots objectAtIndex:indexPath.row];
            Pilot *c = [[Pilot alloc] initWithDictionary:pilot andBackButton:YES];
            [[self navigationController] pushViewController:c animated:YES];
        }
            break;
        // info..
        case SECTION_INFO:
        {
            // nothing..
        }
            break;
    }
}

@end
