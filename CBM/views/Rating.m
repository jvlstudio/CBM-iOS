//
//  Rating.m
//  CBM
//
//  Created by Felipe Ricieri on 22/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Rating.h"
#import "RatingCell.h"
#import "RatingTeamCell.h"

#import "Pilot.h"
#import "Teams.h"

#define FRAME_Y             119
#define FRAME_HEIGHT_I5     385
#define FRAME_HEIGHT_I4     FRAME_HEIGHT_I5-88

#define CELL_MENU            @"menuCell"
#define CELL_MENU_PILOT      @"menuPilotCell"

typedef enum RatingCategory : NSInteger
{
    kRatingCategoryPilots   = 0,
    kRatingCategoryShields  = 1,
    kRatingCategoryTeams    = 2
} RatingCategory;

/* interface */

@interface Rating ()
- (void) upAllButtonsUnless:(RatingCategory) category;
- (void) arrowToButton:(RatingCategory) category;
- (void) updateSectionForPilots;
- (void) updateSectionForShields;
- (void) updateSectionForTeams;
@end

/* implementation */

@implementation Rating
{
    FRTools *tools;
    UpdateData *update;
}

@synthesize plist;
@synthesize pilotsData, shieldsData, teamsData;
@synthesize arrow, labSectionLabel1, labSectionLabel2, labSectionLabel3;
@synthesize labelPilots, labelShields, labelTeams;
@synthesize butPilots, butShields, butTeams;
@synthesize pilotsTable, shieldsTable, teamsTable;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // em navigation control,
    // nao deixar tabelas sairem dos limites do
    // view....
    [[self view] setClipsToBounds:YES];
    
    // data
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    plist       = [webservice rating]; //[tools propertyListRead:PLIST_RATING];
    pilotsData  = [plist objectForKey:@"pilots"];
    shieldsData = [plist objectForKey:@"shields"];
    teamsData   = [NSArray array]; //[plist objectForKey:PLIST_KEY_TEAMS];
    
    // frames..
    CGRect framePilots  = pilotsTable.frame;
    CGRect frameShields = shieldsTable.frame;
    CGRect frameTeams   = teamsTable.frame;
    
    if(!IS_IPHONE5)
    {
        framePilots.size.height = FRAME_HEIGHT_I4;
        frameShields.size.height= FRAME_HEIGHT_I4;
        frameTeams.size.height  = FRAME_HEIGHT_I4;
    }
    
    framePilots.origin.y    = FRAME_Y;
    frameShields.origin.x   = WINDOW_WIDTH;
    frameShields.origin.y   = FRAME_Y;
    frameTeams.origin.x     = WINDOW_WIDTH*2;
    frameTeams.origin.y     = FRAME_Y;
    
    [pilotsTable setFrame:framePilots];
    [shieldsTable setFrame:frameShields];
    [teamsTable setFrame:frameTeams];
    
    [[self view] addSubview:pilotsTable];
    [[self view] addSubview:shieldsTable];
    [[self view] addSubview:teamsTable];
    
    // labels..
    [self configureLabel:labelPilots withText:[labelPilots text] andSize:13.0 andColor:COLOR_GREEN_LIGHT];
    [self configureLabel:labelShields withText:[labelShields text] andSize:13.0 andColor:COLOR_GREY_LIGHT];
    [self configureLabel:labelTeams withText:[labelTeams text] andSize:13.0 andColor:COLOR_GREY_LIGHT];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilots:(id)sender
{
    [self upAllButtonsUnless:kRatingCategoryPilots];
    
    [UIView animateWithDuration:0.3
                     animations:^(void)
     {
         CGRect framePilots     = pilotsTable.frame;
         CGRect frameShields    = shieldsTable.frame;
         CGRect frameTeams      = teamsTable.frame;
         framePilots.origin.x   = ZERO;
         frameShields.origin.x  = WINDOW_WIDTH;
         frameTeams.origin.x    = WINDOW_WIDTH*2;
         [pilotsTable setFrame:framePilots];
         [shieldsTable setFrame:frameShields];
         [teamsTable setFrame:frameTeams];
         
     } completion:^(BOOL finished) {
         [self updateSectionForPilots];
     }];
}
- (IBAction) pressShields:(id)sender
{
    [self upAllButtonsUnless:kRatingCategoryShields];
    
    [UIView animateWithDuration:0.3
                     animations:^(void)
     {
         CGRect framePilots     = pilotsTable.frame;
         CGRect frameShields    = shieldsTable.frame;
         CGRect frameTeams      = teamsTable.frame;
         framePilots.origin.x   = -WINDOW_WIDTH;
         frameShields.origin.x  = ZERO;
         frameTeams.origin.x    = WINDOW_WIDTH;
         [pilotsTable setFrame:framePilots];
         [shieldsTable setFrame:frameShields];
         [teamsTable setFrame:frameTeams];
         
     } completion:^(BOOL finished) {
         [self updateSectionForShields];
     }];
}
- (IBAction) pressTeams:(id)sender
{
    [self upAllButtonsUnless:kRatingCategoryTeams];
    
    [UIView animateWithDuration:0.3
                     animations:^(void)
     {
         CGRect framePilots     = pilotsTable.frame;
         CGRect frameShields    = shieldsTable.frame;
         CGRect frameTeams      = teamsTable.frame;
         framePilots.origin.x   = -(WINDOW_WIDTH*2);
         frameShields.origin.x  = -WINDOW_WIDTH;
         frameTeams.origin.x    = ZERO;
         [pilotsTable setFrame:framePilots];
         [shieldsTable setFrame:frameShields];
         [teamsTable setFrame:frameTeams];
         
     } completion:^(BOOL finished) {
         [self updateSectionForTeams];
     }];
}

#pragma mark -
#pragma mark Actions

- (void) upAllButtonsUnless:(RatingCategory)category
{
    [butPilots setSelected:NO];
    [butShields setSelected:NO];
    [butTeams setSelected:NO];
    
    switch (category)
    {
        case kRatingCategoryPilots:
        {
            [butPilots setSelected:YES];
        }
            break;
        case kRatingCategoryShields:
        {
            [butShields setSelected:YES];
        }
            break;
        case kRatingCategoryTeams:
        {
            [butTeams setSelected:YES];
        }
            break;
    }
    
    [self arrowToButton:category];
}

- (void)arrowToButton:(RatingCategory)category
{
    CGFloat offsetX;
    switch (category)
    {
        case kRatingCategoryPilots:
        {
            offsetX = butPilots.frame.size.width/2;
        }
            break;
        case kRatingCategoryShields:
        {
            offsetX = (butShields.frame.size.width/2) + butShields.frame.origin.x;
        }
            break;
        case kRatingCategoryTeams:
        {
            offsetX = (butTeams.frame.size.width/2) + butTeams.frame.origin.x;
        }
            break;
    }
    // animate..
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rectArrow = arrow.frame;
        rectArrow.origin.x = offsetX;
        [arrow setFrame:rectArrow];
    }];
}

- (void) updateSectionForPilots
{
    [labelPilots setTextColor:COLOR_GREEN_LIGHT];
    [labelShields setTextColor:COLOR_GREY_LIGHT];
    [labelTeams setTextColor:COLOR_GREY_LIGHT];
    
    [labSectionLabel1 setText:@"Posição"];
    [labSectionLabel2 setText:@"Nome do Piloto"];
    [labSectionLabel3 setText:@"Pontos"];
}
- (void) updateSectionForShields
{
    [labelPilots setTextColor:COLOR_GREY_LIGHT];
    [labelShields setTextColor:COLOR_GREEN_LIGHT];
    [labelTeams setTextColor:COLOR_GREY_LIGHT];
    
    [labSectionLabel1 setText:@"Montadora"];
    [labSectionLabel2 setText:@""];
    [labSectionLabel3 setText:@"Pontos"];
}
- (void) updateSectionForTeams
{
    [labelPilots setTextColor:COLOR_GREY_LIGHT];
    [labelShields setTextColor:COLOR_GREY_LIGHT];
    [labelTeams setTextColor:COLOR_GREEN_LIGHT];
    
    [labSectionLabel1 setText:@"Montadora"];
    [labSectionLabel2 setText:@"Nome da Equipe"];
    [labSectionLabel3 setText:@"Pontos"];
}

#pragma mark -
#pragma mark UITableViewDatasource and UITableViewDelegate Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69.0;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // pilots..
    if(tableView == pilotsTable)
        return [pilotsData count];
    // shields..
    else if(tableView == shieldsTable)
        return [shieldsData count];
    // teams..
    else
        return [teamsData count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"RatingCell" owner:nil options:nil];
    id cell      = nil;
    
    // pilots..
    if(tableView == pilotsTable)
    {
        NSDictionary *obj = [pilotsData objectAtIndex:indexPath.row];
        cell = (RatingCell *)[tableView dequeueReusableCellWithIdentifier:CELL_MENU];
        if(!cell)
            cell = (RatingCell*)[xib objectAtIndex:0];
        
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_rating_pilot.png"]];
        [ubg setContentMode:UIViewContentModeTop];
        [cell setBackgroundView:ubg];
        [cell setSelectedBackgroundView:ubg];
        
        // position..
        int k = indexPath.row+1;
        NSString *numRanking    = [NSString stringWithFormat:@"%iº", k];
        [self configureLabel:[cell numberRanking] withText:numRanking andSize:24.0 andColor:COLOR_WHITE];
        // pilot name..
        [self defaultFontTo:[cell pilotName] withSize:13.0 andColor:COLOR_WHITE];
        NSString *pilotName = [[obj objectForKey:KEY_NAME] isEqualToString:KEY_EMPTY] ? @"Piloto não cadastrado" : [[obj objectForKey:KEY_NAME] uppercaseString];
        [[cell pilotName] setText:pilotName];
        // team name..
        [self defaultFontTo:[cell teamName] withSize:10.0 andColor:COLOR_GREY_LIGHT];
        [[cell teamName] setText:[obj objectForKey:KEY_TEAM]];
        // car name..
        [self defaultFontTo:[cell carName] withSize:10.0 andColor:COLOR_GREY_LIGHT];
        [[cell carName] setText:[obj objectForKey:KEY_CAR]];
        [[cell numberCar] setText:[obj objectForKey:KEY_NUMBER]];
        // points..
        [self configureLabel:[cell points] withText:[NSString stringWithFormat:@"%@", [obj objectForKey:KEY_POINTS]] andSize:24.0 andColor:COLOR_YELLOW];
    }
    // shields..
    else if(tableView == shieldsTable)
    {
        NSDictionary *obj = [shieldsData objectAtIndex:indexPath.row];
        cell = (RatingTeamCell *)[tableView dequeueReusableCellWithIdentifier:CELL_MENU_PILOT];
        if(!cell)
            cell = (RatingTeamCell*)[xib objectAtIndex:1];
        
        NSString *shield = [NSString stringWithFormat:@"cell_rating_shield_%@.png", [obj objectForKey:KEY_KEY]];
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:shield]];
        [ubg setContentMode:UIViewContentModeTop];
        [cell setBackgroundView:ubg];
        [cell setSelectedBackgroundView:ubg];
        
        // name..
        [self defaultFontTo:[cell shieldName] withSize:22.0 andColor:COLOR_WHITE];
        [[cell shieldName] setText:[[obj objectForKey:KEY_NAME] uppercaseString]];
        // points..
        [self configureLabel:[cell points] withText:[NSString stringWithFormat:@"%@", [obj objectForKey:KEY_POINTS]] andSize:24.0 andColor:COLOR_GREEN_LIGHT];
        // bg..
        NSString *bgString  = [NSString stringWithFormat:@"cell_rating_shield_%@.png", [obj objectForKey:KEY_SLUG]];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgString]];
        [cell setBackgroundView:bgView];
    }
    // teams..
    else {
        NSDictionary *obj = [teamsData objectAtIndex:indexPath.row];
        cell = (RatingTeamCell *)[tableView dequeueReusableCellWithIdentifier:CELL_MENU_PILOT];
        if(!cell)
            cell = (RatingTeamCell*)[xib objectAtIndex:1];
        
        NSString *shield = [NSString stringWithFormat:@"cell_rating_shield_%@.png", [obj objectForKey:KEY_KEY]];
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:shield]];
        [ubg setContentMode:UIViewContentModeTop];
        [cell setBackgroundView:ubg];
        [cell setSelectedBackgroundView:ubg];
        
        // name..
        [self defaultFontTo:[cell shieldName] withSize:22.0 andColor:COLOR_WHITE];
        [[cell shieldName] setText:[[obj objectForKey:KEY_NAME] uppercaseString]];
        // points..
        [self configureLabel:[cell points] withText:[NSString stringWithFormat:@"%@", [obj objectForKey:KEY_POINTS]] andSize:24.0 andColor:COLOR_GREEN_LIGHT];
        // bg..
        NSString *bgString  = [NSString stringWithFormat:@"cell_rating_shield_%@.png", [obj objectForKey:KEY_SHIELD]];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgString]];
        [cell setBackgroundView:bgView];
    }
    
	return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (tableView == pilotsTable)
    {
        NSDictionary *dataPilot;
        NSDictionary *selectedPilot = [pilotsData objectAtIndex:indexPath.row];
        NSArray *plistPilots        = [tools propertyListRead:PLIST_PILOTS];
        
        for (NSDictionary *pilot in plistPilots)
        {
            if([[pilot objectForKey:KEY_ID] isEqualToString:[selectedPilot objectForKey:KEY_ID]])
            {
                dataPilot = pilot;
                break;
            }
        }
        Pilot *c = [[Pilot alloc] initWithDictionary:dataPilot andBackButton:YES];
        [[self navigationController] pushViewController:c animated:YES];
    }
    // teams
    if (tableView == teamsTable)
    {
        NSDictionary *dataTeam;
        NSDictionary *selectedTeam  = [teamsData objectAtIndex:indexPath.row];
        NSArray *plistTeams         = [tools propertyListRead:PLIST_TEAMS];
        
        for (NSDictionary *team in plistTeams)
        {
            if([[team objectForKey:KEY_ID] isEqualToString:[selectedTeam objectForKey:KEY_ID]])
            {
                dataTeam = team;
                break;
            }
        }
        
        Teams *c = [[Teams alloc] initWithDictionary:dataTeam andBackButton:YES];
        [[self navigationController] pushViewController:c animated:YES];
    }
    */
}

@end
