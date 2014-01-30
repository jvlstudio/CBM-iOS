//
//  Steps.m
//  CBM
//
//  Created by Felipe Ricieri on 23/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Steps.h"
#import "StepsCell.h"
#import "StepsEndCell.h"
#import "StepsSingle.h"

#define XIB_RESOURCES   @"StepsResources"

#define CELL_STEPS      @"stepsCell"
#define CELL_STEPS_END  @"stepsEndCell"

#define CELL_INDEX      0
#define CELL_END_INDEX  1

#define CELL_BG         @"cell_steps_list.png"
#define CELL_BG_D       @"cell_steps_list_d.png"
#define CELL_BG_ENDED   @"cell_steps_list_ended.png"
#define CELL_BG_ENDED_D @"cell_steps_list_ended_d.png"

/* interface */

@interface Steps ()
- (void) performWithNewContent;
- (void) pushWithContent;
@end

/* implementation */

@implementation Steps
{
    FRTools *tools;
    UpdateData *update;
    
    NSIndexPath *selectedIndex;
}

@synthesize tableData;
@synthesize table;
@synthesize tableHeader;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // data..
    tools       = [[FRTools alloc] initWithTools];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    tableData = [tools propertyListRead:PLIST_STEPS];
    [table setTableHeaderView:tableHeader];
}

#pragma mark -
#pragma mark UITableViewDatasource and UITableViewDelegate Methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell      = nil;
    // bgs
    UIImageView *bg_up  = nil;
    UIImageView *bg_down= nil;
    
    NSDictionary *obj = [tableData objectAtIndex:indexPath.row];
    
    if(![[obj objectForKey:KEY_IS_ENDED] isEqualToString:KEY_YES])
    {
        cell = (StepsCell *)[tableView dequeueReusableCellWithIdentifier:CELL_STEPS];
        if(!cell)
            cell = (StepsCell*)[xib objectAtIndex:CELL_INDEX];
        
        bg_up   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG]];
        [bg_up setContentMode:UIViewContentModeTop];
        bg_down = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_D]];
        [bg_down setContentMode:UIViewContentModeTop];
        
        // num step
        [self defaultFontTo:[cell numStep] withSize:13.0 andColor:COLOR_GREY_LIGHT];
        [[cell numStep] setText:[NSString stringWithFormat:@"%@ª ETAPA", [obj objectForKey:KEY_NUM_STEP]]];
        // city name
        [self defaultFontTo:[cell cityName] withSize:24.0 andColor:COLOR_WHITE];
        [[cell cityName] setText:[[obj objectForKey:KEY_CITY_NAME] uppercaseString]];
        // date day
        [self defaultFontTo:[cell dateDay] withSize:24.0 andColor:COLOR_WHITE];
        [[cell dateDay] setText:[obj objectForKey:KEY_DATE_DAY]];
        // date mounth
        [self defaultFontTo:[cell dateMounth] withSize:12.0 andColor:COLOR_WHITE];
        [[cell dateMounth] setText:[obj objectForKey:KEY_DATE_MONTH]];
    }
    else {
        cell = (StepsEndCell *)[tableView dequeueReusableCellWithIdentifier:CELL_STEPS_END];
        if(!cell)
            cell = (StepsEndCell*)[xib objectAtIndex:CELL_END_INDEX];
        
        bg_up   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_ENDED]];
        [bg_up setContentMode:UIViewContentModeTop];
        bg_down = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CELL_BG_ENDED_D]];
        [bg_down setContentMode:UIViewContentModeTop];
        
        // num step
        [self defaultFontTo:[cell numStep] withSize:13.0 andColor:COLOR_GREY_LIGHT];
        [[cell numStep] setText:[NSString stringWithFormat:@"%@ª ETAPA", [obj objectForKey:KEY_NUM_STEP]]];
        // city name
        [self defaultFontTo:[cell cityName] withSize:24.0 andColor:COLOR_WHITE];
        [[cell cityName] setText:[[obj objectForKey:KEY_CITY_NAME] uppercaseString]];
        // date day
        [self defaultFontTo:[cell labDateDay] withSize:24.0 andColor:COLOR_WHITE];
        [[cell labDateDay] setText:[obj objectForKey:KEY_DATE_DAY]];
        // date mounth
        [self defaultFontTo:[cell labDateMounth] withSize:12.0 andColor:COLOR_WHITE];
        [[cell labDateMounth] setText:[obj objectForKey:KEY_DATE_MONTH]];
        
        [cell startAnimation];
    }
    
    [cell setBackgroundView:bg_up];
    [cell setSelectedBackgroundView:bg_down];
    
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // update..
    selectedIndex = indexPath;
    if ([update isReadyToRequestUpdateForKey:LOG_UPDATE_STEPS_ROWS])
    {
        [update sync:@"Atualizando conteúdo..."];
        [self performSelector:@selector(performWithNewContent) withObject:nil afterDelay:0.3];
    }
    else {
        [self pushWithContent];
    }
}

#pragma mark -
#pragma mark Inner Methods

- (void) performWithNewContent
{
    NSArray *plist = [tools propertyListRead:PLIST_STEPS_ROWS];
    [update downlaodDataFrom:URL_STEPS_ROWS success:^{
        [update updatesDidLoad];
        NSArray *arr = [[update JSONData] objectForKey:KEY_DATA];
        if ([arr count] > [plist count]) {
            [update syncEnd:@"Atualização Completa!"];
            [tools propertyListWrite:arr forFileName:PLIST_STEPS_ROWS];
            [self pushWithContent];
        }
    } fail:^{
        // do not push
        // if the content is not there...
        [update syncError:@"Erro ao completar atualização."];
    }];
}

- (void) pushWithContent
{
    NSDictionary *obj = [tableData objectAtIndex:selectedIndex.row];
    
    StepsSingle *vc = [[StepsSingle alloc] initWithDictionary:obj andBackButton:YES];
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
