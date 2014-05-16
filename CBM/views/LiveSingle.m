//
//  LiveSingle.m
//  CBM
//
//  Created by Felipe Ricieri on 05/08/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMBarButton.h"

#import "LiveSingle.h"
#import "StepsResultsCell.h"
#import "StepsResultsSection.h"
#import "LiveWaitView.h"
#import "LiveLandscapeCell4.h"
#import "LiveLandscapeCell5.h"

#import "Pilot.h"

/* interface */

@interface LiveSingle ()
- (NSString *) stringValue:(id) value;
- (void) configurePortraitScreen;
- (void) configurePortraitWaitView;
- (void) configureLandscapeScreen;
- (void) configureLandscapeWaitView;
@end

/* implementation */

@implementation LiveSingle
{
    int seconds;
    NSTimer *timer;
    
    FRTools *tools;
    UpdateData *update;
    
    LiveWaitView *vSubPortrait;
    LiveWaitView *vSubLandscape;
}

@synthesize orient;
@synthesize stepDict;
@synthesize imgBackground;
@synthesize pagedControl;
@synthesize vHeader;
@synthesize scrollSetLeft;
@synthesize scrollSetRight;
@synthesize scrollHeader, scrollBody;
@synthesize imgPicture;
@synthesize numStep, cityName;
@synthesize tableData;
@synthesize tables;
@synthesize tableTrain1, tableTrain2, tableProof1, tableProof2;
@synthesize vPortrait, vLandscape;
@synthesize scrLandscape, pcLandscape;
@synthesize tablesLandscape;
@synthesize tableLand1, tableLand2, tableLand3, tableLand4;

#pragma mark -
#pragma mark Init Methods

- (id)initWithDictionary:(NSDictionary *)dict
{
    // dict..
    stepDict        = dict;
    
    self = [super initCBMViewController:@"LiveSingle" withTitle:@"AO VIVO"];
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // plists
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    // portrait..
    [self configurePortraitScreen];
    // landscape ...
    [self configureLandscapeScreen];
    
    // timer..
    seconds = TIMER_SECONDS;
    timer   = [NSTimer scheduledTimerWithTimeInterval:TIMER_DELAY target:self
                                             selector:@selector(updateRows:)
                                             userInfo:nil repeats:YES];
    // fire..
    [timer fire];
}
- (void)viewWillAppear:(BOOL)animated
{
    [update sync:@"Carregando..."];
    [self performSelector:@selector(loadRows) withObject:nil afterDelay:0.5];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
}

#pragma mark -
#pragma mark Timer Methods

- (void) loadRows
{
    NSString *urlLiveStep   = [NSString stringWithFormat:@"%@/%@etapa.json", URL_LIVE, [stepDict objectForKey:KEY_NUM_STEP]];
    NSLog(@"-[LIVE]: live URL %@", urlLiveStep);
    [update downlaodDataFrom:urlLiveStep success:^{
        [update syncEnd:@"Live Time atualizado."];
        NSDictionary *returnData = [update JSONData];
        [self processData:[returnData objectForKey:KEY_DATA]];
    } fail:^{
        // nothing..
    }];
}
- (void) updateRows:(id)sender
{
    seconds--;
    
    NSString *strNow        = [NSString stringWithFormat:@"live_go_0%i.png", seconds+1];
    UIImageView *imgViewNow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:strNow]];
    UIBarButtonItem *bt     = [[UIBarButtonItem alloc] initWithCustomView:imgViewNow];
    self.navigationItem.rightBarButtonItem = bt;
    
    if (seconds == -1)
    {
        seconds = TIMER_SECONDS;
        [self loadRows];
    }
}
- (void) processData:(NSArray *)arrayOfProofs
{
    NSMutableArray *mutArr = [NSMutableArray array];
    // chasing only the "classProva" dictionaries...
    for (NSDictionary *dict in arrayOfProofs)
    {
        NSDictionary *tabRows   = [dict objectForKey:KEY_TABLE_ROWS];
        NSDictionary *tabDetail = [dict objectForKey:KEY_TABLE_DETAILS];
        //...
        if (tabDetail)
            if ([[tabDetail objectForKey:KEY_REF] isEqual:KEY_PROOF])
                [mutArr addObject:tabRows];
    }
    // choosing the last one..
    if ([mutArr count] > 0)
    {
        // re-arranging the steps...
        NSMutableArray *reSteps = [NSMutableArray array];
        for (NSArray *proofs in mutArr)
        {
            NSMutableArray *reProof = [NSMutableArray array];
            for (NSArray *rows in proofs)
            {
                NSString *fPosition     = [self stringValue:[[rows objectAtIndex:0] objectForKey:KEY_VALUE]];
                NSString *fNumber       = [self stringValue:[[rows objectAtIndex:1] objectForKey:KEY_VALUE]];
                NSString *fPilotName    = [self stringValue:[[rows objectAtIndex:2] objectForKey:KEY_VALUE]];
                NSString *fTimeLaps     = [self stringValue:[[rows objectAtIndex:3] objectForKey:KEY_VALUE]];
                NSString *fLaps         = [self stringValue:[[rows objectAtIndex:4] objectForKey:KEY_VALUE]];
                NSString *fTimeBestLap  = [self stringValue:[[rows objectAtIndex:5] objectForKey:KEY_VALUE]];
                NSString *fBestLap      = [self stringValue:[[rows objectAtIndex:6] objectForKey:KEY_VALUE]];
                NSString *fGap          = [self stringValue:[[rows objectAtIndex:7] objectForKey:KEY_VALUE]];
                NSString *fGapAnt       = [self stringValue:[[rows objectAtIndex:8] objectForKey:KEY_VALUE]];
                
                NSDictionary *pilotDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           fPosition, KEY_POSITION,
                                           fNumber, KEY_NUMBER,
                                           fPilotName, KEY_PILOT,
                                           fTimeLaps, KEY_TIME_TOTAL,
                                           fTimeBestLap, KEY_TIME_BEST_LAP,
                                           fBestLap, KEY_BEST_LAP,
                                           fGap, KEY_GAP,
                                           fGapAnt, KEY_GAP_ANT,
                                           fLaps, KEY_LAPS, nil];
                [reProof addObject:pilotDict];
            }
            [reSteps addObject:reProof];
        }
        
        // setting table data..
        tableData = reSteps;
        // reload..
        if ([tableData count] >= TABLE_TRAIN_1){
            [tableTrain1 reloadData];
            [tableLand1 reloadData];
        }
        if ([tableData count] >= TABLE_TRAIN_2){
            [tableTrain2 reloadData];
            [tableLand2 reloadData];
        }
        if ([tableData count] >= TABLE_PROOF_1){
            [tableProof1 reloadData];
            [tableLand3 reloadData];
        }
        if ([tableData count] >= TABLE_PROOF_2){
            [tableProof2 reloadData];
            [tableLand4 reloadData];
        }
        // .. hide wait views
        if ([tableData count] > ZERO)
        {
            [vSubPortrait setHidden:YES];
            [vSubLandscape setHidden:YES];
        }
    }
}
- (NSString *) stringValue:(id) value
{
    NSString *str = [NSString stringWithFormat:@"%@", value];
    return str;
}

#pragma mark -
#pragma mark Other Methods

- (void) configureLabelToHeader:(NSArray *)texts
{
    int i = 0;
    for (NSString *text in texts)
    {
        CGRect frame = CGRectMake(i*WINDOW_WIDTH, 27, WINDOW_WIDTH, 33);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        
        [self defaultFontTo:label withSize:23.0 andColor:COLOR_YELLOW];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        // shadow
        [label setShadowColor:[UIColor darkGrayColor]];
        [label setShadowOffset:CGSizeMake(0, -0.5)];
        //
        [label setText:text];
        
        [scrollHeader addSubview:label];
        i++;
    }
}

#pragma mark -
#pragma mark Implementation Methods

- (void) configurePortraitScreen
{
    // header..
    NSArray *texts = [tools propertyListRead:PLIST_STEPS_PROOFS];
    [self configureLabelToHeader:texts];
    
    // info
    [cityName setText:[[stepDict objectForKey:KEY_CITY_NAME] uppercaseString]];
    [self defaultFontTo:cityName withSize:24.0 andColor:COLOR_WHITE];
    [numStep setText:[NSString stringWithFormat:@"%@ª ETAPA", [stepDict objectForKey:KEY_NUM_STEP]]];
    [self defaultFontTo:numStep withSize:13.0 andColor:COLOR_WHITE];
    
    NSString *picImg = [NSString stringWithFormat:@"steps_lap_%@_tiny.png", [stepDict objectForKey:KEY_SLUG]];
    [imgPicture setImage:[UIImage imageNamed:picImg]];
    
    // scrolls..
    [scrollHeader setContentSize:CGSizeMake(WINDOW_WIDTH * [texts count], scrollHeader.frame.size.height)];
    [scrollBody setFrame:CGRectMake(ZERO, ROOT_Y, WINDOW_WIDTH, TABLE_HEIGHT)];
    [scrollBody setContentSize:CGSizeMake(WINDOW_WIDTH * [texts count], scrollBody.frame.size.height)];
    
    [pagedControl setNumberOfPages:[texts count]];
    [pagedControl setCurrentPage:ZERO];
    
    // data..
    tableTrain1 = [[UITableView alloc] initWithFrame:scrollBody.frame style:UITableViewStylePlain];
    tableTrain2 = [[UITableView alloc] initWithFrame:scrollBody.frame style:UITableViewStylePlain];
    tableProof1 = [[UITableView alloc] initWithFrame:scrollBody.frame style:UITableViewStylePlain];
    tableProof2 = [[UITableView alloc] initWithFrame:scrollBody.frame style:UITableViewStylePlain];
    tables      = [NSArray arrayWithObjects:tableTrain1, tableTrain2, tableProof1, tableProof2, nil];
    
    // tables..
    for (uint i=0; i<[tables count]; i++)
    {
        UITableView *table  = (UITableView*)[tables objectAtIndex:i];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setBackgroundColor:COLOR_CLEAR];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // ...
        CGRect rect     = scrollBody.frame;
        rect.origin.x   = rect.size.width*i;
        rect.origin.y   = ZERO;
        [table setFrame:rect];
        [table setTag:i];
        // ...
        [scrollBody addSubview:table];
        [table reloadData];
    }
    
    // wait view..
    [self configurePortraitWaitView];
}
- (void) configurePortraitWaitView
{
    NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES_LIVE owner:nil options:nil];
    vSubPortrait        = (LiveWaitView*)[xib objectAtIndex:VIEW_WAITING_INDEX];
    
    CGRect rectSub  = scrollBody.frame;
    CGRect rectImg  = rectSub;
    CGRect rectLab  = [[vSubPortrait labText] frame];
    rectImg.origin.y= ZERO;
    rectLab.origin.y= 170;
    rectLab.origin.x= (WINDOW_WIDTH/2)-(rectLab.size.width/2);
    [vSubPortrait setFrame:rectSub];
    [[vSubPortrait imgBackground] setFrame:rectImg];
    [[vSubPortrait labText] setFrame:rectLab];
    [[vSubPortrait labText] setText:[[[vSubPortrait labText] text] uppercaseString]];
    [self defaultFontTo:[vSubPortrait labText] withSize:17.0 andColor:COLOR_WHITE];
    [[self view] addSubview:vSubPortrait];
}
- (void) configureLandscapeScreen
{
    // data..
    tableLand1      = [[UITableView alloc] initWithFrame:scrLandscape.frame style:UITableViewStylePlain];
    tableLand2      = [[UITableView alloc] initWithFrame:scrLandscape.frame style:UITableViewStylePlain];
    tableLand3      = [[UITableView alloc] initWithFrame:scrLandscape.frame style:UITableViewStylePlain];
    tableLand4      = [[UITableView alloc] initWithFrame:scrLandscape.frame style:UITableViewStylePlain];
    tablesLandscape = [NSArray arrayWithObjects:tableLand1, tableLand2, tableLand3, tableLand4, nil];
    
    // frame..
    CGRect rectScroll       = scrLandscape.frame;
    CGRect rectPage         = pcLandscape.frame;
    
    // scroll..
    rectScroll.size.width   = WINDOW_HEIGHT+STATUS_BAR_HEIGHT;
    [scrLandscape setFrame:rectScroll];
    [scrLandscape setContentSize:CGSizeMake(scrLandscape.frame.size.width*[tablesLandscape count], scrLandscape.frame.size.height)];
    
    // page..
    [pcLandscape setNumberOfPages:[tablesLandscape count]];
    [pcLandscape setCurrentPage:ZERO];
    rectPage.origin.x       = ((WINDOW_HEIGHT+STATUS_BAR_HEIGHT)/2)-(rectPage.size.width/2);
    [pcLandscape setFrame:rectPage];
    
    // tables..
    for (uint i=0; i<[tablesLandscape count]; i++)
    {
        UITableView *table  = (UITableView*)[tablesLandscape objectAtIndex:i];
        [table setDelegate:self];
        [table setDataSource:self];
        [table setBackgroundColor:COLOR_CLEAR];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // ...
        CGRect rect     = scrLandscape.frame;
        rect.origin.x   = rect.size.width*i;
        rect.origin.y   = ZERO;
        [table setFrame:rect];
        [table setTag:i+[tablesLandscape count]];
        // ...
        [scrLandscape addSubview:table];
        [table reloadData];
    }
    
    // wait view..
    [self configureLandscapeWaitView];
}
- (void) configureLandscapeWaitView
{
    NSArray *xib        = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES_LIVE owner:nil options:nil];
    vSubLandscape       = (LiveWaitView*)[xib objectAtIndex:VIEW_WAITING_INDEX];
    
    CGRect rectSub  = scrLandscape.frame;
    CGRect rectImg  = rectSub;
    CGRect rectLab  = [[vSubLandscape labText] frame];
    rectImg.origin.y= ZERO;
    rectLab.origin.y= 150;
    rectLab.origin.x= ((WINDOW_HEIGHT+STATUS_BAR_HEIGHT)/2)-(rectLab.size.width/2);
    [vSubLandscape setFrame:rectSub];
    [[vSubLandscape imgBackground] setFrame:rectImg];
    [[vSubLandscape labText] setFrame:rectLab];
    [[vSubLandscape labText] setText:[[[vSubLandscape labText] text] uppercaseString]];
    [self defaultFontTo:[vSubLandscape labText] withSize:17.0 andColor:COLOR_WHITE];
    [vLandscape addSubview:vSubLandscape];
}

#pragma mark -
#pragma mark UITableViewDatasource and UITableViewDelegate Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32.0;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sec;
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES_LIVE owner:nil options:nil];
    
    switch (orient)
    {
        case kInterfaceOrientationPortrait:
        {
            sec = [xib objectAtIndex:SECTION_INDEX];
        }
            break;
        case kInterfaceOrientationLandscape:
        {
            if (IS_IPHONE5)
                sec = [xib objectAtIndex:SECTION_LAND5_INDEX];
            else
                sec = [xib objectAtIndex:SECTION_LAND4_INDEX];
        }
            break;
    }
    
    return sec;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnValue = ZERO;
    // t1..
    if(tableView == tableTrain1 || tableView == tableLand1)
    {
        if ([tableData count] >= TABLE_TRAIN_1)
        {
            returnValue = [[tableData objectAtIndex:section] count];
        }
        else {
            returnValue = ZERO;
        }
    }
    // t2..
    else if (tableView == tableTrain2 || tableView == tableLand2)
    {
        if ([tableData count] >= TABLE_TRAIN_2)
        {
            returnValue = [[tableData objectAtIndex:section] count];
        }
        else {
            returnValue = ZERO;
        }
    }
    // p1..
    else if (tableView == tableProof1 || tableView == tableLand3)
    {
        if ([tableData count] >= TABLE_PROOF_1)
        {
            returnValue = [[tableData objectAtIndex:section] count];
        }
        else {
            returnValue = ZERO;
        }
    }
    // p2..
    else if (tableView == tableProof2 || tableView == tableLand4)
    {
        if ([tableData count] >= TABLE_PROOF_2)
        {
            returnValue = [[tableData objectAtIndex:section] count];
        }
        else {
            returnValue = ZERO;
        }
    }
    // ..
    else
    {
        returnValue = ZERO;
    }
    
    return returnValue;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell      = nil;
    UIImageView *bg_up;
    
    // ... cells for portrait
    // ...
    if (tableView == tableTrain1
    ||  tableView == tableTrain2
    ||  tableView == tableProof1
    ||  tableView == tableProof2 )
    {
        // xib
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES_LIVE owner:nil options:nil];
        bg_up  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG]];
        // cell
        cell = (StepsResultsCell*)[tableView dequeueReusableCellWithIdentifier:CELL_STEPS_RESULTS];
        if(!cell)
            cell = (StepsResultsCell*)[xib objectAtIndex:CELL_INDEX];
    }
    
    // ... cells for landscape
    // ...
    if (tableView == tableLand1
    ||  tableView == tableLand2
    ||  tableView == tableLand3
    ||  tableView == tableLand4 )
    {
        // xib
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES_LIVE owner:nil options:nil];
        bg_up  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_LAND]];
        // cell
        if (!IS_IPHONE5)
        {
            cell = (LiveLandscapeCell4*)[tableView dequeueReusableCellWithIdentifier:CELL_LAND4];
            if(!cell)
                cell = (LiveLandscapeCell4*)[xib objectAtIndex:CELL_LAND4_INDEX];
        }
        else
        {
            cell = (LiveLandscapeCell5*)[tableView dequeueReusableCellWithIdentifier:CELL_LAND5];
            if(!cell)
                cell = (LiveLandscapeCell5*)[xib objectAtIndex:CELL_LAND5_INDEX];
        }
    }
    
    // ... content
    // ... portrait 1
    if(tableView == tableTrain1)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_1-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableTrain1 toOrient:kInterfaceOrientationPortrait];
    }
    // ... portrait 2
    else if (tableView == tableTrain2)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_2-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableTrain2 toOrient:kInterfaceOrientationPortrait];
    }
    // ... portrait 3
    else if (tableView == tableProof1)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_1-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableProof1 toOrient:kInterfaceOrientationPortrait];
    }
    // ... portrait 4
    else if (tableView == tableProof2)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_2-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableProof2 toOrient:kInterfaceOrientationPortrait];
    }
    
    // ... landscape 1
    else if(tableView == tableLand1)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_1-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableLand1 toOrient:kInterfaceOrientationLandscape];
    }
    // ... landscape 2
    else if (tableView == tableLand2)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_2-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableLand2 toOrient:kInterfaceOrientationLandscape];
    }
    // ... landscape 3
    else if (tableView == tableLand3)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_1-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableLand3 toOrient:kInterfaceOrientationLandscape];
    }
    // ... landscape 4
    else if (tableView == tableLand4)
    {
        NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_2-1)];
        NSDictionary *obj   = [dataTemp objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableLand4 toOrient:kInterfaceOrientationLandscape];
    }
    
    // ...
    else {
        NSLog(@"[STEPS : RESULTS] Algo errado aconteceu...");
    }
    
    // background..
    [bg_up setContentMode:UIViewContentModeTop];
    [cell setBackgroundView:bg_up];
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (orient != kInterfaceOrientationLandscape)
    {
        NSDictionary *obj;
        NSDictionary *pilotDict;
        // t1..
        if(tableView == tableTrain1)
        {
            NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_1-1)];
            obj   = [dataTemp objectAtIndex:indexPath.row];
        }
        // t2..
        else if (tableView == tableTrain2)
        {
            NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_TRAIN_2-1)];
            obj   = [dataTemp objectAtIndex:indexPath.row];
        }
        // run..
        else if (tableView == tableProof1)
        {
            NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_1-1)];
            obj   = [dataTemp objectAtIndex:indexPath.row];
        }
        // rating..
        else if (tableView == tableProof2)
        {
            NSArray *dataTemp   = [tableData objectAtIndex:(TABLE_PROOF_2-1)];
            obj   = [dataTemp objectAtIndex:indexPath.row];
        }
        
        // make key..
        NSString *strKey    = [[obj objectForKey:KEY_PILOT] lowercaseString];
        strKey              = [strKey stringByReplacingOccurrencesOfString:KEY_SPACE withString:KEY_UNIFIER];
        NSArray *plistPilot = [tools propertyListRead:PLIST_PILOTS];
        for (NSDictionary *pit in plistPilot)
        {
            if ([[pit objectForKey:KEY_SLUG] isEqual:strKey])
            {
                pilotDict = pit;
            }
        }
        
        Pilot *c = [[Pilot alloc] initWithDictionary:pilotDict andBackButton:YES];
        [[self navigationController] pushViewController:c animated:YES];
    }
    */
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // ... scroll header (portrait)
    if(scrollView == scrollHeader)
    {
        float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        [pagedControl setCurrentPage:currentPage];
        [pcLandscape setCurrentPage:currentPage];
        [scrLandscape setContentOffset:CGPointMake(scrLandscape.frame.size.width*currentPage, ZERO)];
        
        [UIView animateWithDuration:0.3f
                         animations:^(void)
         {
             [scrollBody setContentOffset:CGPointMake(scrollHeader.contentOffset.x, ZERO)];
         }];
    }
    // ... scrol (landscape)
    if (scrollView == scrLandscape)
    {
        float currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        [pagedControl setCurrentPage:currentPage];
        [pcLandscape setCurrentPage:currentPage];
        [scrollBody setContentOffset:CGPointMake(scrollBody.frame.size.width*currentPage, ZERO)];
        [scrollHeader setContentOffset:CGPointMake(scrollHeader.frame.size.width*currentPage, ZERO)];
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressLeft:(id)sender
{
    float currentPage   = scrollHeader.contentOffset.x / WINDOW_WIDTH;
    float prevPage      = currentPage - 1;
    float delay         = 0.3f;
    
    if(prevPage >= 0)
    {
        CGPoint frameHeader = scrollHeader.contentOffset;
        CGPoint frameBody   = scrollBody.contentOffset;
        
        frameHeader.x       = prevPage * WINDOW_WIDTH;
        frameBody.x         = prevPage * WINDOW_WIDTH;
        
        [pagedControl setCurrentPage:prevPage];
        [UIView animateWithDuration:delay
                         animations:^(void)
         {
             [scrollHeader setContentOffset:frameHeader];
             [scrollBody setContentOffset:frameBody];
         }];
    }
    else {
        [self shakeToLeft];
    }
}
- (IBAction) pressRight:(id)sender
{
    float currentPage   = scrollHeader.contentOffset.x / WINDOW_WIDTH;
    float nextPage      = currentPage + 1;
    float delay         = 0.3f;
    
    if(nextPage < 4) // total of proofs
    {
        CGPoint frameHeader = scrollHeader.contentOffset;
        CGPoint frameBody   = scrollBody.contentOffset;
        
        frameHeader.x       = nextPage * WINDOW_WIDTH;
        frameBody.x         = nextPage * WINDOW_WIDTH;
        
        [pagedControl setCurrentPage:nextPage];
        [UIView animateWithDuration:delay
                         animations:^(void)
         {
             [scrollHeader setContentOffset:frameHeader];
             [scrollBody setContentOffset:frameBody];
         }];
    }
    else {
        [self shakeToRight];
    }
}
- (void) shakeToLeft
{
    float delayHalf     = 0.1f;
    [UIView animateWithDuration:delayHalf animations:^{
        CGRect frameH       = scrollHeader.frame;
        CGRect frameB       = scrollBody.frame;
        frameH.origin.x = -10;
        frameB.origin.x = -10;
        [scrollHeader setFrame:frameH];
        [scrollBody setFrame:frameB];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:delayHalf animations:^{
            CGRect frameH       = scrollHeader.frame;
            CGRect frameB       = scrollBody.frame;
            frameH.origin.x = 10;
            frameB.origin.x = 10;
            [scrollHeader setFrame:frameH];
            [scrollBody setFrame:frameB];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:delayHalf animations:^{
                CGRect frameH       = scrollHeader.frame;
                CGRect frameB       = scrollBody.frame;
                frameH.origin.x = 0;
                frameB.origin.x = 0;
                [scrollHeader setFrame:frameH];
                [scrollBody setFrame:frameB];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
- (void) shakeToRight
{
    float delayHalf     = 0.1f;
    [UIView animateWithDuration:delayHalf animations:^{
        CGRect frameH       = scrollHeader.frame;
        CGRect frameB       = scrollBody.frame;
        frameH.origin.x = 10;
        frameB.origin.x = 10;
        [scrollHeader setFrame:frameH];
        [scrollBody setFrame:frameB];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:delayHalf animations:^{
            CGRect frameH       = scrollHeader.frame;
            CGRect frameB       = scrollBody.frame;
            frameH.origin.x = -10;
            frameB.origin.x = -10;
            [scrollHeader setFrame:frameH];
            [scrollBody setFrame:frameB];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:delayHalf animations:^{
                CGRect frameH       = scrollHeader.frame;
                CGRect frameB       = scrollBody.frame;
                frameH.origin.x = 0;
                frameB.origin.x = 0;
                [scrollHeader setFrame:frameH];
                [scrollBody setFrame:frameB];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

/* hack */

- (void) setValuesOfCell:(UITableViewCell*) dcell
               forObject:(NSDictionary*) obj
            andIndexPath:(NSIndexPath*) indexPath
                andTable:(UITableView *)tab
                toOrient:(CurrentUIInterfaceOrientation)orientation
{
    // position
    int j           = indexPath.row + 1;
    NSString *nPos  = (j > 9
                       ? [NSString stringWithFormat:@"%i", j]
                       : [NSString stringWithFormat:@"0%i", j]);
    // ...
    switch (orientation)
    {
        case kInterfaceOrientationPortrait:
        {
            StepsResultsCell *cell = (StepsResultsCell*) dcell;
            // ...
            [self defaultFontTo:[cell numPosition] withSize:14.0 andColor:COLOR_YELLOW];
            [[cell numPosition] setText:nPos];
            // pilot name
            [self defaultFontTo:[cell pilot] withSize:12.0 andColor:COLOR_WHITE];
            [[cell pilot] setText:[[obj objectForKey:KEY_PILOT] uppercaseString]];
            
            [self defaultFontTo:[cell lapTime] withSize:12.0 andColor:COLOR_WHITE];
            [[cell lapTime] setText:[obj objectForKey:KEY_TIME_BEST_LAP]];
            
            // gap
            [self defaultFontTo:[cell gap] withSize:12.0 andColor:COLOR_WHITE];
            [[cell gap] setText:[obj objectForKey:KEY_GAP]];
            // laps
            [self defaultFontTo:[cell laps] withSize:12.0 andColor:COLOR_WHITE];
            [[cell laps] setText:[obj objectForKey:KEY_LAPS]];
        }
            break;
        case kInterfaceOrientationLandscape:
        {
            if (IS_IPHONE5)
            {
                LiveLandscapeCell5 *cell = (LiveLandscapeCell5*) dcell;
                // ...
                [self defaultFontTo:[cell labPos] withSize:14.0 andColor:COLOR_YELLOW];
                [[cell labPos] setText:nPos];
                // number
                [self defaultFontTo:[cell labNum] withSize:13.0 andColor:COLOR_WHITE];
                [[cell labNum] setText:[[obj objectForKey:KEY_NUMBER] uppercaseString]];
                // pilot name
                [self defaultFontTo:[cell labName] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labName] setText:[[obj objectForKey:KEY_PILOT] uppercaseString]];
                // car
                [self defaultFontTo:[cell labCar] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labCar] setText:[[obj objectForKey:KEY_BEST_LAP] uppercaseString]];
                
                [self defaultFontTo:[cell labTimeBestLap] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labTimeBestLap] setText:[obj objectForKey:KEY_TIME_BEST_LAP]];
                // ...
                [self defaultFontTo:[cell labTimeTotal] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labTimeTotal] setText:[obj objectForKey:KEY_TIME_TOTAL]];
                
                // gap
                [self defaultFontTo:[cell labGap] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labGap] setText:[obj objectForKey:KEY_GAP]];
                [self defaultFontTo:[cell labGapAnt] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labGapAnt] setText:[obj objectForKey:KEY_GAP_ANT]];
                // laps
                [self defaultFontTo:[cell labLaps] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labLaps] setText:[obj objectForKey:KEY_LAPS]];
            }
            else {
                LiveLandscapeCell4 *cell = (LiveLandscapeCell4*) dcell;
                // ...
                [self defaultFontTo:[cell labPos] withSize:14.0 andColor:COLOR_YELLOW];
                [[cell labPos] setText:nPos];
                // number
                [self defaultFontTo:[cell labNum] withSize:13.0 andColor:COLOR_WHITE];
                [[cell labNum] setText:[[obj objectForKey:KEY_NUMBER] uppercaseString]];
                // pilot name
                [self defaultFontTo:[cell labName] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labName] setText:[[obj objectForKey:KEY_PILOT] uppercaseString]];
                // car
                [self defaultFontTo:[cell labCar] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labCar] setText:[[obj objectForKey:KEY_BEST_LAP] uppercaseString]];
                
                [self defaultFontTo:[cell labTimeBestLap] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labTimeBestLap] setText:[obj objectForKey:KEY_TIME_BEST_LAP]];
                
                // gap
                [self defaultFontTo:[cell labGap] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labGap] setText:[obj objectForKey:KEY_GAP]];
                // laps
                [self defaultFontTo:[cell labLaps] withSize:12.0 andColor:COLOR_WHITE];
                [[cell labLaps] setText:[obj objectForKey:KEY_LAPS]];
            }
        }
            break;
    }
}

#pragma mark -
#pragma mark Rotate Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            orient = kInterfaceOrientationPortrait;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            orient = kInterfaceOrientationLandscape;
        }
            break;
    }
    [self rotateViewToOrientation];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // ..
}
- (void) rotateViewToOrientation
{
    switch (orient)
    {
        case kInterfaceOrientationPortrait:
        {
            [self rotateViewToOrientationPortrait];
        }
            break;
        case kInterfaceOrientationLandscape:
        {
            [self rotateViewToOrientationLandscape];
        }
    }
}
- (void) rotateViewToOrientationPortrait
{
    [self setView:vPortrait];
    [super setMenuButton];
}
- (void) rotateViewToOrientationLandscape
{
    [self setView:vLandscape];
    [[self navigationItem] setLeftBarButtonItem:nil];
    
}

@end
