//
//  Menu.m
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "MenuConstants.h"

#import "Menu.h"
#import "MenuCell.h"
#import "MenuPilotCell.h"
#import "MenuSearchCell.h"
#import "MenuSearchSection.h"

#import "HomeSimple.h"
#import "News.h"
#import "NewsSingle.h"
#import "Pilot.h"
#import "Teams.h"
#import "Tickets.h"
#import "Rating.h"
#import "Steps.h"
#import "StepsSingle.h"
#import "Settings.h"
#import "LiveSingle.h"

/* interface */

@interface Menu ()
- (void) configureSearchTypeData;
- (NSString*) titleForSearchSection:(NSInteger)section;
- (NSString*) textForRightType:(NSString*) type : (NSString*) text;
- (void) presentCenterViewControllerFromSearch:(NSDictionary*) dict;
/* search push.. */
- (void) pushPilotWithDictionary:(NSDictionary*) dict;
- (void) pushStepWithDictionary:(NSDictionary*) dict;
/* update */
- (void) updateWithOption:(NSString*) option;
- (void) pushWithOption:(NSString*) option;
@end

/* implementation */

@implementation Menu
{
    PilotsOrTeams pilotOrTeam;
    
    FRTools *tools;
    UpdateData *update;
    
    NSArray *plistPilots;
    NSArray *plistTeams;
    NSArray *plistSteps;
    
    UIAlertView *alertUpdatePilot;
    UIAlertView *alertUpdateTeams;
    UIAlertView *alertUpdateRating;
    UIAlertView *alertUpdateSteps;
}

@synthesize menuType;
@synthesize menuData;
@synthesize menuTable;
@synthesize menuTableHeader;
@synthesize menuTableFooter;
@synthesize menuBg;
@synthesize menuBgHeader;
@synthesize menuCancelBt;
@synthesize imgBg;
@synthesize searchData;
@synthesize searchTypeData;
@synthesize searchField;
@synthesize searchTable;
@synthesize pilotsData;
@synthesize teamsData;
@synthesize pilotsTable;
@synthesize pilotsTableHeader;
@synthesize pilotsBackButton;

#pragma mark -
#pragma mark Init Methods

- (id) initWithMenuType:(TypeMenuList)dMenuType
{
    self = [super initCBMViewController:VC_MENU];
    if (self)
    {
        menuType = dMenuType;
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // data..
    tools           = [[FRTools alloc] initWithTools];
    update          = [[UpdateData alloc] initWithRootViewController:self];
    webservice      = [[Webservice alloc] initTheWebservice];
    
    // plists..
    plistPilots     = [webservice pilots]; //[tools propertyListRead:PLIST_PILOTS];
    plistTeams      = [webservice teams]; //[tools propertyListRead:PLIST_TEAMS];
    plistSteps      = [webservice steps]; //[tools propertyListRead:PLIST_STEPS];
    
    // set..
    menuData        = [tools propertyListRead:PLIST_MENU];
    pilotsData      = [plistPilots copy];
    teamsData       = [plistTeams copy];
    searchData      = [NSMutableArray array];
    searchTypeData  = [NSMutableArray array];
    
    // alerts..
    alertUpdatePilot    = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_PILOT
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    alertUpdateTeams    = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_TEAMS
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    alertUpdateRating   = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_RATING
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    alertUpdateSteps    = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                     message:ALERT_MESSAGE_STEPS
                                                    delegate:self cancelButtonTitle:ALERT_CANCEL_BUTTON
                                           otherButtonTitles:nil];
    
    // set content..
    [self configureSearchTypeData];
    
    // frames
    [menuTable setFrame:CGRECT_0];
    [pilotsTable setFrame:CGRECT_1];
    [pilotsTable setAlpha:0.0];
    [searchTable setFrame:CGRECT_SEARCH];
    [searchTable setHidden:YES];
    
    [[self view] addSubview:menuTable];
    [[self view] addSubview:pilotsTable];
    [[self view] addSubview:searchTable];
    
    // show menu
    switch (menuType)
    {
        case kTypeMenuData:
        {
            [self menuSlideOptions];
        }
            break;
        case kTypeMenuPilots:
        {
            [self menuSlidePilotsAndTeamsForLog:LOG_UPDATE_PILOTS];
            pilotOrTeam = kPilotChosen;
        }
            break;
        case kTypeMenuTeams:
        {
            [self menuSlidePilotsAndTeamsForLog:LOG_UPDATE_TEAMS];
            pilotOrTeam = kTeamChosen;
        }
            break;
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilotsBackButton:(id)sender
{
    [self menuSlideOptions];
}
- (IBAction) pressMenuCancelButton:(id)sender
{
    [self menuSearchFinish:nil andData:nil];
}

#pragma mark -
#pragma mark Menu Action

- (void) menuSlideOptions
{
    [UIView animateWithDuration:DELAY
                     animations:^(void)
     {
         [menuTable setFrame:CGRECT_1];
         [pilotsTable setFrame:CGRECT_2];
     } completion:^(BOOL finished){
         pilotsTable.alpha = 0;
     }];
}
- (void) menuSlidePilotsAndTeamsForLog:(NSString *)log
{
    // pilots..
    if ([log isEqual:LOG_UPDATE_PILOTS]){
        pilotsData  = [webservice pilots]; //[tools propertyListRead:PLIST_PILOTS];
        [pilotsTable reloadData];
    }
    // teams..
    else {
        pilotsData  = [webservice teams]; //[tools propertyListRead:PLIST_TEAMS];
        [pilotsTable reloadData];
    }
    
    pilotsTable.alpha = 1;
    [UIView animateWithDuration:DELAY
                     animations:^(void)
     {
         [menuTable setFrame:CGRECT_0];
         [pilotsTable setFrame:CGRECT_1];
     }];
}
- (void) menuSearchStart
{
    // change bg
    imgBg.image = [UIImage imageNamed:@"bg_viewcontroller_02.png"];
    menuData = [NSMutableArray arrayWithObjects:nil];
    
    // enlarge views..
    CGRect rectReveal       = self.revealSideViewController.rootViewController.view.frame;
    CGRect rectMenuTable    = menuTable.frame;
    CGRect rectMenuHead     = menuTableHeader.frame;
    CGRect rectMenuBg       = menuBg.frame;
    CGRect rectMenuBt       = menuCancelBt.frame;
    
    rectReveal.origin.x     = WINDOW_WIDTH;
    
    rectMenuTable.origin.y  = -menuBgHeader.frame.size.height;
    rectMenuTable.size.width= WINDOW_WIDTH;
    rectMenuTable.size.height += menuBgHeader.frame.size.height;
    
    rectMenuHead.size.width = WINDOW_WIDTH;
    rectMenuBg.size.width   = WINDOW_WIDTH;
    rectMenuBt.origin.x     = 227;
    
    [UIView animateWithDuration:DELAY animations:^(void){
        self.revealSideViewController.rootViewController.view.frame = rectReveal;
        menuTable.frame = rectMenuTable;
        menuTableHeader.frame = rectMenuHead;
        menuBg.frame = rectMenuBg;
        menuCancelBt.frame = rectMenuBt;
    } completion:^(BOOL finished){
        menuBgHeader.alpha = 0;
        searchTable.hidden = NO;
    }];
}
- (void) menuSearchFinish:(SEL) selectorToExec
                  andData:(NSDictionary *)dDict;
{
    [searchField endEditing:YES];
    
    // change bg
    imgBg.image = [UIImage imageNamed:@"bg_menu.png"];
    menuData = [tools propertyListRead:PLIST_MENU];
    
    // diminute views..
    CGRect rectReveal       = self.revealSideViewController.rootViewController.view.frame;
    
    CGRect rectMenuTable    = CGRECT_1;
    CGRect rectMenuHead     = menuTableHeader.frame;
    CGRect rectMenuBg       = menuBg.frame;
    CGRect rectMenuBt       = menuCancelBt.frame;
    
    rectReveal.origin.x     = WINDOW_WIDTH - SIDE_MENU_OFFSET;
    
    rectMenuHead.size.width = MENU_WIDTH;
    rectMenuBg.size.width   = MENU_WIDTH;
    rectMenuBt.origin.x     = 242;
    
    searchTable.hidden = YES;
    [UIView animateWithDuration:DELAY animations:^(void){
        self.revealSideViewController.rootViewController.view.frame = rectReveal;
        menuTable.frame = rectMenuTable;
        menuTableHeader.frame = rectMenuHead;
        menuBg.frame = rectMenuBg;
        menuCancelBt.frame = rectMenuBt;
        menuBgHeader.alpha = 1;
    } completion:^(BOOL finished) {
        if(selectorToExec)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector: selectorToExec withObject: dDict];
#pragma clang diagnostic pop
        }
    }];
}

#pragma mark -
#pragma mark UITextField Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self menuSearchStart];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [searchTypeData removeAllObjects];
    NSString *needle = [[NSString stringWithFormat:@"%@%@", [searchField text], string] lowercaseString];
    
    for (NSDictionary *info in searchData)
    {
        NSString *haystack = [[info objectForKey:KEY_NAME] lowercaseString];
        if ([haystack rangeOfString:needle].location != NSNotFound)
        {
            [searchTypeData addObject:info];
        }
    }
    
    if ([needle isEqual:KEY_EMPTY])
        [searchTypeData removeAllObjects];
    
    [searchTable reloadData];
    
    return YES;
}

#pragma mark -
#pragma mark UITableViewDatasource and UITableViewDelegate Methods

/* sections */

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // menu...
    if(tableView == menuTable)
    {
        return menuTableHeader;
    }
    // pilots...
    else if(tableView == pilotsTable)
    {
        return pilotsTableHeader;
    }
    else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // menu..
    if(tableView == menuTable)
        return [menuTableHeader frame].size.height;
    // pilots...
    else if(tableView == pilotsTable)
        return [pilotsTableHeader frame].size.height;
    // default..
    else
        return 0.0;
}

/* rows */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // menu...
    if(tableView == menuTable)
        return [menuData count];
    // pilots..
    else if(tableView == pilotsTable)
        return [pilotsData count];
    // search...
    else if(tableView == searchTable)
        return [searchTypeData count];
    // default...
    else
        return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell      = nil;
    
    // tables..
    // menu..
    if(tableView == menuTable)
    {
        cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:CELL_MENU];
        if(!cell)
            cell = (MenuCell*)[xib objectAtIndex:TABLE_MENU];
        
        NSString *bgUp   = [NSString stringWithFormat:@"menu_%@.png", [menuData objectAtIndex:indexPath.row]];
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgUp]];
        [cell setBackgroundView:ubg];
        [ubg setContentMode:UIViewContentModeTop];
        
        NSString *bgDown = [NSString stringWithFormat:@"menu_%@_d.png", [menuData objectAtIndex:indexPath.row]];
        UIImageView *dbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgDown]];
        [cell setSelectedBackgroundView:dbg];
        [dbg setContentMode:UIViewContentModeTop];
    }
    // pilots..
    else if(tableView == pilotsTable)
    {
        NSDictionary *obj = [pilotsData objectAtIndex:indexPath.row];
        cell = (MenuPilotCell *)[tableView dequeueReusableCellWithIdentifier:CELL_MENU_PILOT];
        if(!cell)
            cell = (MenuPilotCell*)[xib objectAtIndex:TABLE_PILOTS];
        
        NSString *shield = [NSString stringWithFormat:@"shield_%@.png", [obj objectForKey:KEY_SHIELD]];
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_CELL_PILOT]];
        [cell setBackgroundView:ubg];
        [ubg setContentMode:UIViewContentModeTop];
        
        UIImageView *dbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_CELL_PILOT_D]];
        [cell setSelectedBackgroundView:dbg];
        [dbg setContentMode:UIViewContentModeTop];
        
        [[cell labelName] setTextColor:[UIColor whiteColor]];
        [[cell labelName] setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
        [[cell labelName] setText:[[obj objectForKey:KEY_NAME] uppercaseString]];
        
        [[cell shield] setImage:[UIImage imageNamed:shield]];
    }
    // search..
    else if(tableView == searchTable)
    {
        NSDictionary *obj = [searchTypeData objectAtIndex:indexPath.row];
        cell = (MenuSearchCell*)[tableView dequeueReusableCellWithIdentifier:CELL_MENU_SEARCH];
        if(!cell)
            cell = (MenuSearchCell*)[xib objectAtIndex:TABLE_SEARCH];
        
        NSString *type   = [NSString stringWithFormat:@"search_type_%@.png", [obj objectForKey:KEY_TYPE]];
        UIImageView *ubg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_CELL_SEARCH]];
        [cell setBackgroundView:ubg];
        [ubg setContentMode:UIViewContentModeTop];
        
        UIImageView *dbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BG_CELL_SEARCH_D]];
        [cell setSelectedBackgroundView:dbg];
        [dbg setContentMode:UIViewContentModeTop];
        
        [[cell labelName] setTextColor:[UIColor whiteColor]];
        [[cell labelName] setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
        [[cell labelName] setText:[self textForRightType:[obj objectForKey:KEY_TYPE] :[obj objectForKey:KEY_NAME]]];
        
        [[cell imgType] setImage:[UIImage imageNamed:type]];
    }
    
	return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // switch..
    if (tableView == menuTable)
    {
        switch (indexPath.row) {
                
            case INDEX_HOME:
            {
                HomeSimple *c = [[HomeSimple alloc] initCBMViewController:@"HomeSimple"];
                CBMNavigationController *n;
                n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_HOME];
                [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                PP_RELEASE(c);
                PP_RELEASE(n);
            }
                break;
                
            case INDEX_NEWS:
            {
                News *c = [[News alloc] initCBMViewController:VC_NEWS];
                CBMNavigationController *n;
                n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_NEWS];
                [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                PP_RELEASE(c);
                PP_RELEASE(n);
            }
                break;
                
            case INDEX_PILOTS:
            {
                pilotsData = [webservice pilots]; //[tools propertyListRead:PLIST_PILOTS];
                /*
                if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_PILOTS])
                {
                    [update sync:SYNC_START_MESSAGE];
                    [self performSelector:@selector(updateWithOption:) withObject:LOG_UPDATE_PILOTS afterDelay:0.3];
                }
                else {
                    [self pushWithOption:LOG_UPDATE_PILOTS];
                }
                */
                [self pushWithOption:LOG_UPDATE_PILOTS];
            }
                break;
                
            case INDEX_TEAMS:
            {
                pilotsData = [webservice teams]; //[tools propertyListRead:PLIST_TEAMS];
                /*
                if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_TEAMS])
                {
                    [update sync:SYNC_START_MESSAGE];
                    [self performSelector:@selector(updateWithOption:) withObject:LOG_UPDATE_TEAMS afterDelay:0.3];
                }
                else {
                    [self pushWithOption:LOG_UPDATE_TEAMS];
                }
                */
                [self pushWithOption:LOG_UPDATE_TEAMS];
            }
                break;
                
            case INDEX_TICKETS:
            {
                Tickets *c = [[Tickets alloc] initCBMViewController:VC_TICKETS];
                CBMNavigationController *n;
                n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_TICKETS];
                [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                PP_RELEASE(c);
                PP_RELEASE(n);
            }
                break;
                
            case INDEX_RATING:
            {
                /*
                if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_RATING])
                {
                    [update sync:SYNC_START_MESSAGE];
                    [self performSelector:@selector(updateWithOption:) withObject:LOG_UPDATE_RATING afterDelay:0.3];
                }
                else {
                    [self pushWithOption:LOG_UPDATE_RATING];
                }
                */
                
                UpdateData *up = [[UpdateData alloc] initWithRootViewController:self];
                [up sync:@"Atualizando..."];
                [webservice wtvisionDataForStep:[webservice currentStepNumber] didSucceed:^{
                    [up syncEnd:@""];
                    [self pushWithOption:LOG_UPDATE_RATING];
                } didFail:^{
                    [up syncEnd:@""];
                    [tools dialogWithMessage:@"Não foi possível conectar-se a internet para carregar os resultados dessa etapa. Por favor, verifique sua conexão e tente novamente." title:@"Sem conexão"];
                }];
                
                //[self pushWithOption:LOG_UPDATE_RATING];
            }
                break;
                
            case INDEX_STEPS:
            {
                /*
                if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_STEPS])
                {
                    [update sync:SYNC_START_MESSAGE];
                    [self performSelector:@selector(updateWithOption:) withObject:LOG_UPDATE_STEPS afterDelay:0.3];
                }
                else {
                    [self pushWithOption:LOG_UPDATE_STEPS];
                }
                */
                [self pushWithOption:LOG_UPDATE_STEPS];
            }
                break;
                
            case INDEX_SETTINGS:
            {
                Settings *c = [[Settings alloc] initCBMViewController:VC_SETTINGS];
                CBMNavigationController *n;
                n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_SETTINGS];
                [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                PP_RELEASE(c);
                PP_RELEASE(n);
            }
                break;
                
            case INDEX_LIVE:
            {
                /*
                if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_STEPS])
                {
                    [update sync:SYNC_START_MESSAGE];
                    [self performSelector:@selector(updateWithOption:) withObject:LOG_UPDATE_LIVE afterDelay:0.3];
                }
                else {
                    [self pushWithOption:LOG_UPDATE_LIVE];
                }
                */
                [self pushWithOption:LOG_UPDATE_LIVE];
            }
                break;
                
            default:
                break;
        }
    }
    // pilot choose..
    else if(tableView == pilotsTable)
    {
        NSDictionary *obj   = [pilotsData objectAtIndex:indexPath.row];
        MenuPilotCell *cell = (MenuPilotCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *shield    = [NSString stringWithFormat:@"shield_%@_d.png", [obj objectForKey:KEY_SHIELD]];
        [[cell shield] setImage:[UIImage imageNamed:shield]];
        
        switch (pilotOrTeam)
        {
            case kPilotChosen:
            {
                [webservice wtvisionDataForStep:[webservice currentStepNumber] didSucceed:^{
                    Pilot *c = [[Pilot alloc] initWithDictionary:obj andBackButton:NO];
                    CBMNavigationController *n;
                    n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_PILOTS];
                    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                    PP_RELEASE(c);
                    PP_RELEASE(n);
                } didFail:^{
                    [tools dialogWithMessage:@"Não foi possível conectar-se a internet para carregar os resultados dessa etapa. Por favor, verifique sua conexão e tente novamente." title:@"Sem conexão"];
                }];
            }
                break;
            case kTeamChosen:
            {
                Teams *c = [[Teams alloc] initWithDictionary:obj];
                CBMNavigationController *n;
                n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_TEAMS];
                [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
                PP_RELEASE(c);
                PP_RELEASE(n);
            }
                break;
        }
    }
    // search choose..
    else if(tableView == searchTable)
    {
        [self presentCenterViewControllerFromSearch:[searchTypeData objectAtIndex:indexPath.row]];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        // do not try to update
        // once more...
        case 0:
        {
            // pilots..
            if (alertView == alertUpdatePilot)
                [self pushWithOption:LOG_UPDATE_PILOTS];
            // teams..
            if (alertView == alertUpdateTeams)
                [self pushWithOption:LOG_UPDATE_TEAMS];
            // rating..
            else if (alertView == alertUpdateRating)
                [self pushWithOption:LOG_UPDATE_RATING];
            // steps..
            else if (alertView == alertUpdateSteps)
                [self pushWithOption:LOG_UPDATE_STEPS];
        }
            break;
    }
}

#pragma mark -
#pragma mark Actions

- (void) updateWithOption:(NSString *)option
{
    // pilots..
    if ([option isEqual:LOG_UPDATE_PILOTS])
    {
        [update downlaodDataFrom:URL_PILOTS success:^{
            [update updatesDidLoad];
            [update syncEnd:SYNC_END_MESSAGE];
            NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
            [tools propertyListWrite:arr forFileName:PLIST_PILOTS];
            pilotsData = [webservice pilots]; //[tools propertyListRead:PLIST_PILOTS];
            [pilotsTable reloadData];
            [self pushWithOption:option];
        } fail:^{
            [update syncError:SYNC_ERROR_MESSAGE];
            [alertUpdatePilot show];
        }];
    }
    // teams..
    if ([option isEqual:LOG_UPDATE_TEAMS])
    {
        [update downlaodDataFrom:URL_TEAMS success:^{
            [update updatesDidLoad];
            [update syncEnd:SYNC_END_MESSAGE];
            NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
            [tools propertyListWrite:arr forFileName:PLIST_TEAMS];
            pilotsData = [webservice pilots]; //[tools propertyListRead:PLIST_TEAMS];
            [pilotsTable reloadData];
            [self pushWithOption:option];
        } fail:^{
            [update syncError:SYNC_ERROR_MESSAGE];
            [alertUpdateTeams show];
        }];
    }
    // rating..
    else if([option isEqual:LOG_UPDATE_RATING])
    {
        [update downlaodDataFrom:URL_RATING success:^{
            [update updatesDidLoad];
            [update syncEnd:SYNC_END_MESSAGE];
            NSDictionary *dict = [[update JSONData] objectForKey:KEY_DATA];
            [tools propertyListWrite:dict forFileName:PLIST_RATING];
            [self pushWithOption:option];
        } fail:^{
            [update syncError:SYNC_ERROR_MESSAGE];
            [alertUpdateRating show];
        }];
    }
    // steps..
    else if([option isEqual:LOG_UPDATE_STEPS]
        ||  [option isEqual:LOG_UPDATE_LIVE])
    {
        [update downlaodDataFrom:URL_STEPS success:^{
            [update updatesDidLoad];
            [update syncEnd:SYNC_END_MESSAGE];
            NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
            [tools propertyListWrite:arr forFileName:PLIST_STEPS];
            [self pushWithOption:option];
        } fail:^{
            [update syncError:SYNC_ERROR_MESSAGE];
            [alertUpdateSteps show];
        }];
    }
}
- (void) pushWithOption:(NSString *)option
{
    // pilots..
    if ([option isEqual:LOG_UPDATE_PILOTS])
    {
        // show pilots..
        [self menuSlidePilotsAndTeamsForLog:option];
        pilotOrTeam = kPilotChosen;
    }
    // teams..
    else if([option isEqual:LOG_UPDATE_TEAMS])
    {
        // show teams..
        [self menuSlidePilotsAndTeamsForLog:option];
        pilotOrTeam = kTeamChosen;
    }
    // rating..
    else if([option isEqual:LOG_UPDATE_RATING])
    {
        Rating *c = [[Rating alloc] initCBMViewController:VC_RATING];
        CBMNavigationController *n;
        n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_RATING];
        [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
        PP_RELEASE(c);
        PP_RELEASE(n);
    }
    // steps..
    else if([option isEqual:LOG_UPDATE_STEPS])
    {
        Steps *c = [[Steps alloc] initCBMViewController:VC_STEPS];
        CBMNavigationController *n;
        n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_STEPS];
        [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
        PP_RELEASE(c);
        PP_RELEASE(n);
    }
    // live..
    else if([option isEqual:LOG_UPDATE_LIVE])
    {
        // get next step..
        NSInteger nextStepNumber = [webservice nextStepNumber];
        if (nextStepNumber == 0) {
            [tools dialogWithMessage:@"Não há livetime acontecendo no momento." title:@"Livetime"];
        }
        else {
            NSDictionary *nextStep = [webservice stepForNumber:nextStepNumber];
            LiveSingle *c = [[LiveSingle alloc] initWithDictionary:nextStep];
            CBMNavigationController *n;
            n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_LIVE];
            [n setLetRotateToLandscape:YES];
            [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
            PP_RELEASE(c);
            PP_RELEASE(n);
        }
    }
}

#pragma mark -
#pragma mark Search Advanced Methods

- (void)configureSearchTypeData
{
    // type data > pilots..
    for (NSDictionary *pilot in pilotsData)
    {
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        [row setObject:[pilot objectForKey:KEY_NAME] forKey:KEY_NAME];
        [row setObject:[pilot objectForKey:KEY_ID] forKey:KEY_ID];
        [row setObject:KEY_TYPE_PILOTS forKey:KEY_TYPE];
        [searchData addObject:row];
    }
    // type data > steps..
    for (NSDictionary *step in plistSteps)
    {
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        [row setObject:[step objectForKey:KEY_CITY_NAME] forKey:KEY_NAME];
        [row setObject:[step objectForKey:KEY_NUM_STEP] forKey:KEY_ID];
        [row setObject:KEY_TYPE_STEPS forKey:KEY_TYPE];
        [searchData addObject:row];
    }
}
- (NSString*) titleForSearchSection:(NSInteger)section
{
    NSString *stringToReturn;
    switch (section)
    {
        case SEARCH_SECTION_PILOTS:
        {
            stringToReturn = TITLE_PILOTS;
        }
            break;
        case SEARCH_SECTION_NEWS:
        {
            stringToReturn = TITLE_NEWS;
        }
            break;
        case SEARCH_SECTION_STEPS:
        {
            stringToReturn = TITLE_STEPS;
        }
            break;
    }
    return stringToReturn;
}
- (NSString *)textForRightType:(NSString*)type :(NSString *)text
{
    NSString *textToReturn = @"";
    // pilots..
    if([type isEqual: KEY_TYPE_PILOTS])
    {
        textToReturn = @"Piloto";
    }
    // steps..
    else if([type isEqual: KEY_TYPE_STEPS])
    {
        textToReturn = @"Etapa";
    }
    NSString *txtName = [[NSString stringWithFormat:@"%@: %@", textToReturn, text] uppercaseString];
    return txtName;
}
- (void) presentCenterViewControllerFromSearch:(NSDictionary *)dict
{
    // pilots...
    // ....
    if([[dict objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_PILOTS])
    {
        NSDictionary *dictToOpen;
        for (NSDictionary *pilot in plistPilots)
        {
            if([[pilot objectForKey:KEY_ID] isEqualToString:[dict objectForKey:KEY_ID]])
            {
                dictToOpen = pilot;
                break;
            }
        }
        [self menuSearchFinish:@selector(pushPilotWithDictionary:) andData:dictToOpen];
    }
    // steps...
    // ....
    else if([[dict objectForKey:KEY_TYPE] isEqualToString:KEY_TYPE_STEPS])
    {
        NSDictionary *dictToOpen;
        for (NSDictionary *step in plistSteps)
        {
            if([[step objectForKey:KEY_NUM_STEP] isEqualToString:[dict objectForKey:KEY_ID]])
            {
                dictToOpen = step;
                break;
            }
        }
        [self menuSearchFinish:@selector(pushStepWithDictionary:) andData:dictToOpen];
    }
}

#pragma mark -
#pragma mark Push Custom Methods

- (void) pushPilotWithDictionary:(NSDictionary *)dict
{
    Pilot *c = [[Pilot alloc] initWithDictionary:dict andBackButton:NO];
    CBMNavigationController *n;
    n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_PILOTS];
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
- (void) pushStepWithDictionary:(NSDictionary *)dict
{
    StepsSingle *c = [[StepsSingle alloc] initWithDictionary:dict andBackButton:NO];
    CBMNavigationController *n;
    n = [[CBMNavigationController alloc] initWithCBMControllerAndLeftButton:c title:TITLE_STEPS];
    [self.revealSideViewController popViewControllerWithNewCenterController:n animated:YES];
    PP_RELEASE(c);
    PP_RELEASE(n);
}

@end
