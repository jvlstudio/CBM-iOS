//
//  TicketsSales.m
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "TicketsSales.h"

#import "TicketSalesCell.h"
#import "TicketSalesSection.h"

#define HEIGHT_CLOSED   42
#define HEIGHT_OPENED   85

#define CELL_ID         @"ticketSalesCell"
#define CELL_BG_CLOSED  @"cell_tickets_closed.png"
#define CELL_BG_OPENED  @"cell_tickets_opened.png"

#define XIB_RESOURCES   @"TicketSalesCell"


@implementation TicketsSales
{
    FRTools *tools;
    NSIndexPath *rowOpened;
}

@synthesize plist;
@synthesize tableData;
@synthesize table;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithBackButton];
    
    // data..
    tools       = [[FRTools alloc] initWithTools];
    plist       = [tools propertyListRead:PLIST_ROADS_SALEPOINTS];
    tableData   = plist;
}

- (void)viewWillAppear:(BOOL)animated
{
    // super..
    [super viewWillAppear:animated];
    [super configureViewController:self withTitle:@"PONTOS DE VENDA"];
}

#pragma mark -
#pragma mark UITableViewDatasource and UITableViewDelegate Methods

/* sections */

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    TicketSalesSection *sect = (TicketSalesSection*)[xib objectAtIndex:1];
    [self configureLabel:[sect labelTitle] withText:[[tableData objectAtIndex:section] objectForKey:KEY_NAME] andSize:12.0 andColor:COLOR_GREY_LIGHT];
    
    return sect;
}

/* rows */

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL is = [self checkIfIsOpen:indexPath];
    
    if(is)
    {
        return HEIGHT_OPENED;
    }
    else {
        
        return HEIGHT_CLOSED;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[tableData objectAtIndex:section] objectForKey:KEY_SALEPOINTS] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:XIB_RESOURCES owner:nil options:nil];
    id cell      = nil;
    
    NSDictionary *obj = [[[tableData objectAtIndex:indexPath.section] objectForKey:KEY_SALEPOINTS] objectAtIndex:indexPath.row];
    cell = (TicketSalesCell *)[tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if(!cell)
        cell = (TicketSalesCell*)[xib objectAtIndex:0];
    
    [[cell imgBg] setImage:[UIImage imageNamed:CELL_BG_CLOSED]];
    [self configureLabel:[cell labelName] withText:[obj objectForKey:KEY_NAME] andSize:13.0 andColor:COLOR_WHITE];
    [self configureLabel:[cell labelCity] withText:[obj objectForKey:KEY_CITY] andSize:11.0 andColor:COLOR_WHITE];
    
    [[cell labelAddress] setText:[obj objectForKey:KEY_ADDRESS]];
    [[cell labelAddress] setHidden:YES];
    
    [cell setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [cell setClipsToBounds:YES];
    
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketSalesCell *cell = (TicketSalesCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL is = [self checkIfIsOpen:indexPath];
    
    // bgs...
    UIImage *bgClosed   = [UIImage imageNamed:CELL_BG_CLOSED];
    UIImage *bgOpened   = [UIImage imageNamed:CELL_BG_OPENED];
    
    if( is )
    {
        rowOpened = nil;
        [[cell imgBg] setImage:bgClosed];
        [[cell labelAddress] setHidden:YES];
    }
    else {
        // get old row
        TicketSalesCell *oldrow = (TicketSalesCell *)[tableView cellForRowAtIndexPath:rowOpened];
        [[oldrow imgBg] setImage:bgClosed];
        [[oldrow labelAddress] setHidden:YES];
        
        rowOpened = indexPath;
        [[cell imgBg] setImage:bgOpened];
        [[cell labelAddress] setHidden:NO];
    }
    
    [table beginUpdates];
    [table endUpdates];
}

#pragma mark -
#pragma mark Other Methods

- (BOOL) checkIfIsOpen: (NSIndexPath*) row
{
    if([rowOpened isEqual:row]){
        return YES;
    }else{
        return NO;
    }
}

@end
