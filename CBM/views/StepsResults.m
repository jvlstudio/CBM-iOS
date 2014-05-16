//
//  StepsResults.m
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "StepsResults.h"
#import "StepsResultsCell.h"
#import "StepsResultsSection.h"

#import "Pilot.h"

#define ROOT_Y          126
#define TABLE_HEIGHT    IS_IPHONE5 ? 378 : 290

#define CELL_STEPS_RESULTS  @"stepsResultsCell"
#define CELL_BG             @"cell_steps_results.png"

#define LAP_TIME            @"Lap Time"
#define BEST_LAP_TIME       @"Best Lap Time"

#define XIB_RESOURCES       @"StepsResources"
#define CELL_INDEX          2
#define SECTION_INDEX       3

#define TABLE_TRAIN_1   0
#define TABLE_TRAIN_2   1
#define TABLE_PROOF_1   2
#define TABLE_PROOF_2   3


@implementation StepsResults
{
    FRTools *tools;
    UpdateData *update;
    
    NSArray *dataTrain1;
    NSArray *dataTrain2;
    NSArray *dataProof1;
    NSArray *dataProof2;
}

@synthesize plist;
@synthesize stepDict;
@synthesize pagedControl;
@synthesize scrollSetLeft;
@synthesize scrollSetRight;
@synthesize scrollHeader, scrollBody;
@synthesize imgPicture;
@synthesize numStep, cityName;
@synthesize tableData;
@synthesize tables;
@synthesize tableTrain1, tableTrain2;
@synthesize tableProof1, tableProof2;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dict
{
    // dict..
    stepDict        = dict;
    
    self = [super initCBMViewController:@"StepsResults" withTitle:@"RESULTADOS"];
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    
    // plists
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    //plist       = [tools propertyListRead:PLIST_STEPS_ROWS];
    tableData   = [webservice wtvisionRowsForStep:[[stepDict objectForKey:KEY_NUM_STEP] integerValue] type:kClassProofs]; //[plist objectAtIndex:([[stepDict objectForKey:KEY_NUM_STEP] intValue]-1)];
    
    // data..
    dataTrain1  = [tableData objectAtIndex:TABLE_TRAIN_1];
    dataTrain2  = [tableData objectAtIndex:TABLE_TRAIN_2];
    dataProof1  = [tableData objectAtIndex:TABLE_PROOF_1];
    dataProof2  = [tableData objectAtIndex:TABLE_PROOF_2];
    
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
    [scrollBody setFrame:CGRectMake(ZERO, ROOT_Y, WINDOW_WIDTH, TABLE_HEIGHT)];
    
    [scrollHeader setContentSize:CGSizeMake(WINDOW_WIDTH * [texts count], scrollHeader.frame.size.height)];
    [scrollBody setContentSize:CGSizeMake(WINDOW_WIDTH * [texts count], scrollBody.frame.size.height)];
    [pagedControl setNumberOfPages:[texts count]];
    [pagedControl setCurrentPage:ZERO];
    
    // tables..
    [self configureTable:tableTrain1 toIndex:TABLE_TRAIN_1];
    [self configureTable:tableTrain2 toIndex:TABLE_TRAIN_2];
    [self configureTable:tableProof1 toIndex:TABLE_PROOF_1];
    [self configureTable:tableProof2 toIndex:TABLE_PROOF_2];
    
    tables  = [NSArray arrayWithObjects:tableTrain1, tableTrain2, tableProof1, tableProof2, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // super..
    [super viewWillAppear:animated];
    [super configureViewController:self withTitle:@"RESULTADOS"];
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

- (void) configureTable:(UITableView*) table
                toIndex:(int)index
{
    CGRect rect = CGRectMake(index*WINDOW_WIDTH, ZERO, WINDOW_WIDTH, TABLE_HEIGHT);
    [table setFrame:rect];
    [table setShowsVerticalScrollIndicator:NO];
    
    [scrollBody addSubview:table];
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
    NSArray *xib    = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    StepsResultsSection *sec    = (StepsResultsSection*)[xib objectAtIndex:SECTION_INDEX];
    
    /*
    // t1..
    if(tableView == tableTrain1)
        [[sec lapOrBestLap] setText:LAP_TIME];
    // t2..
    else if (tableView == tableTrain2)
        [[sec lapOrBestLap] setText:LAP_TIME];
    // p1..
    else if (tableView == tableProof1)
        [[sec lapOrBestLap] setText:BEST_LAP_TIME];
    // p2..
    else if (tableView == tableProof2)
        [[sec lapOrBestLap] setText:BEST_LAP_TIME];
    else
        [[sec lapOrBestLap] setText:LAP_TIME];*/
    
    [[sec lapOrBestLap] setText:BEST_LAP_TIME];
    
    return sec;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // t1..
    if(tableView == tableTrain1)
        return [dataTrain1 count];
    // t2..
    else if (tableView == tableTrain2)
        return [dataTrain2 count];
    // p1..
    else if (tableView == tableProof1)
        return [dataProof1 count];
    // p2..
    else if (tableView == tableProof2)
        return [dataProof2 count];
    else
        return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell      = nil;
    
    // bgs
    UIImageView *bg_up  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG]];
    [bg_up setContentMode:UIViewContentModeTop];
    
    // cell
    cell = (StepsResultsCell *)[tableView dequeueReusableCellWithIdentifier:CELL_STEPS_RESULTS];
    if(!cell)
        cell = (StepsResultsCell*)[xib objectAtIndex:CELL_INDEX];
    
    // t1..
    if(tableView == tableTrain1)
    {
        NSDictionary *obj = [dataTrain1 objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableTrain1];
    }
    // t2..
    else if (tableView == tableTrain2)
    {
        NSDictionary *obj = [dataTrain2 objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableTrain2];
    }
    // run..
    else if (tableView == tableProof1)
    {
        NSDictionary *obj = [dataProof1 objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableProof1];
    }
    // rating..
    else if (tableView == tableProof2)
    {
        NSDictionary *obj = [dataProof2 objectAtIndex:indexPath.row];
        [self setValuesOfCell:cell forObject:obj andIndexPath:indexPath andTable:tableProof2];
    }
    else {
        NSLog(@"[STEPS : RESULTS] Algo errado aconteceu...");
    }
    
    [cell setBackgroundView:bg_up];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSDictionary *obj;
    NSDictionary *pilotDict;
    // t1..
    if(tableView == tableTrain1)
    {
        obj = [dataTrain1 objectAtIndex:indexPath.row];
    }
    // t2..
    else if (tableView == tableTrain2)
    {
        obj = [dataTrain2 objectAtIndex:indexPath.row];
    }
    // run..
    else if (tableView == tableProof1)
    {
        obj = [dataProof1 objectAtIndex:indexPath.row];
    }
    // rating..
    else if (tableView == tableProof2)
    {
        obj = [dataProof2 objectAtIndex:indexPath.row];
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
    */
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == scrollHeader)
    {
        float currentPage = scrollView.contentOffset.x / WINDOW_WIDTH;
        [pagedControl setCurrentPage:currentPage];
        
        [UIView animateWithDuration:0.3f
                         animations:^(void)
         {
             [scrollBody setContentOffset:CGPointMake(scrollHeader.contentOffset.x, 0)];
         }];
    }
}

/* hack */

- (void) setValuesOfCell:(StepsResultsCell*) cell
               forObject:(NSDictionary*) obj
            andIndexPath:(NSIndexPath*) indexPath
                andTable:(UITableView *)tab
{
    // position
    int j           = indexPath.row + 1;
    NSString *nPos  = (j > 9
                       ? [NSString stringWithFormat:@"%i", j]
                       : [NSString stringWithFormat:@"0%i", j]);
    
    [self defaultFontTo:[cell numPosition] withSize:14.0 andColor:COLOR_YELLOW];
    [[cell numPosition] setText:nPos];
    // pilot name
    [self defaultFontTo:[cell pilot] withSize:12.0 andColor:COLOR_WHITE];
    [[cell pilot] setText:[[obj objectForKey:KEY_PILOT] uppercaseString]];
    
    /*// lap time
    if(tab == tableTrain1 || tab == tableTrain2)
    {
        [self defaultFontTo:[cell lapTime] withSize:12.0 andColor:COLOR_WHITE];
        [[cell lapTime] setText:[obj objectForKey:KEY_LAP_TIME]];
    }
    else {
        [self defaultFontTo:[cell lapTime] withSize:12.0 andColor:COLOR_WHITE];
        [[cell lapTime] setText:[obj objectForKey:KEY_TIME_BEST_LAP]];
    }*/
    
    [self defaultFontTo:[cell lapTime] withSize:12.0 andColor:COLOR_WHITE];
    [[cell lapTime] setText:[obj objectForKey:KEY_TIME_BEST_LAP]];
    
    // gap
    [self defaultFontTo:[cell gap] withSize:12.0 andColor:COLOR_WHITE];
    [[cell gap] setText:[obj objectForKey:KEY_GAP]];
    // laps
    [self defaultFontTo:[cell laps] withSize:12.0 andColor:COLOR_WHITE];
    [[cell laps] setText:[obj objectForKey:KEY_LAPS]];
}

@end
