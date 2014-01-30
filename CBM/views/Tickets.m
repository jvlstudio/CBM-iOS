//
//  Tickets.m
//  CBM
//
//  Created by Felipe Ricieri on 24/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "Tickets.h"
#import "TicketsSales.h"
#import "TicketsRules.h"
#import "TicketPassView.h"

#import "StepsSingle.h"

#define CGRECT_SCROLL   CGRectMake(0,0,WINDOW_WIDTH,WINDOW_HEIGHT-STATUS_BAR_HEIGHT)


@implementation Tickets
{
    FRTools *tools;
}

@synthesize plist;
@synthesize data;
@synthesize salepoints;
@synthesize scroll;
@synthesize rootView;
@synthesize pagedControl;
@synthesize scrollPass;
@synthesize btRules1;
@synthesize btRules2;
@synthesize btSales;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // plist
    tools       = [[FRTools alloc] initWithTools];
    plist       = [tools propertyListRead:PLIST_STEPS];
    data        = [plist objectAtIndex:0];
    salepoints  = [data objectForKey:KEY_SALEPOINTS];
    
    // scroll
    scroll = [[UIScrollView alloc] initWithFrame:CGRECT_SCROLL];
    [scroll setShowsVerticalScrollIndicator:NO];
    [scroll setPagingEnabled:NO];
    [scroll setDelegate:self];
    [scroll setContentSize:CGSizeMake(WINDOW_WIDTH, rootView.frame.size.height+STATUS_BAR_HEIGHT)];
    
    int nextIndex = [self getNextStepIndex];
    
    [scrollPass setContentSize:CGSizeMake(WINDOW_WIDTH*[plist count], 330)];
    [scrollPass setContentOffset:CGPointMake(WINDOW_WIDTH*nextIndex, ZERO)];
    
    [pagedControl setNumberOfPages:[plist count]];
    [pagedControl setCurrentPage:nextIndex];
    
    // views
    [self configureTicketPassViews];
    
    [scroll addSubview:rootView];
    [[self view] addSubview:scroll];
}

#pragma mark -
#pragma mark View Methods

- (void) configureTicketPassViews
{
    for (int i = 0; i<[plist count]; i++)
    {
        // obj..
        NSDictionary *obj = [plist objectAtIndex:i];
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"TicketPassView" owner:nil options:nil];
        
        // view..
        TicketPassView *tkpass = [xib objectAtIndex:0];
        [tkpass setFrame:CGRectMake(WINDOW_WIDTH*i, 0, tkpass.frame.size.width, tkpass.frame.size.height)];
        [[tkpass but] addTarget:self action:@selector(touchPassView:) forControlEvents:UIControlEventTouchUpInside];
        
        // text..
        // num steps
        [self defaultFontTo:[tkpass numStep] withSize:24.0 andColor:COLOR_BLACK];
        [[tkpass numStep] setText:[NSString stringWithFormat:@"%@ª ETAPA", [obj objectForKey:KEY_NUM_STEP]]];
        // city name
        [self defaultFontTo:[tkpass cityName] withSize:24.0 andColor:COLOR_BLACK];
        [[tkpass cityName] setText:[[obj objectForKey:KEY_CITY_NAME] uppercaseString]];
        // circuit
        [self defaultFontTo:[tkpass circuit] withSize:12.0 andColor:COLOR_BLACK];
        [[tkpass circuit] setText:[obj objectForKey:KEY_ADDRESS]];
        // date_day
        [self defaultFontTo:[tkpass dateDayMounth] withSize:24.0 andColor:COLOR_BLACK];
        [[tkpass dateDayMounth] setText:[NSString stringWithFormat:@"%@ %@", [obj objectForKey:KEY_DATE_DAY], [obj objectForKey:KEY_DATE_MONTH]]];
        // date_month
        [self defaultFontTo:[tkpass dateWeek] withSize:24.0 andColor:COLOR_BLACK];
        //[[tkpass dateWeek] setText:[[obj objectForKey:KEY_DATE_WEEK] uppercaseString]];
        
        [scrollPass addSubview:tkpass];
    }
}

- (int) getNextStepIndex
{
    // get next step..
    NSArray *steps = [tools propertyListRead:PLIST_STEPS];
    int index=0;
    for (NSDictionary *step in steps){
        if ([[step objectForKey:KEY_IS_ENDED] isEqual:KEY_NO])
            break;
        index++;
    }
    return index;
}

#pragma mark -
#pragma mark IBActions

- (IBAction) pressBtSales:(id)sender
{
    TicketsSales *vc = [[TicketsSales alloc] initCBMViewController:@"TicketsSales" withTitle:@"PONTOS DE VENDA"];
    [[self navigationController] pushViewController:vc animated:YES];
}
- (IBAction) pressBtRules1:(id)sender
{
    TicketsRules *vc = [[TicketsRules alloc] initCBMViewController:@"TicketsRules"];
    CBMNavigationController *n;
    n = [[CBMNavigationController alloc] initWithCBMControllerAndRightButton:vc title:@"Regras e Observações"];
    [self presentViewController:n animated:YES completion:nil];
}
- (IBAction) pressBtRules2:(id)sender
{
    TicketsRules *vc = [[TicketsRules alloc] initCBMViewController:@"TicketsRules"];
    CBMNavigationController *n;
    n = [[CBMNavigationController alloc] initWithCBMControllerAndRightButton:vc title:@"Meia Entrada"];
    [self presentViewController:n animated:YES completion:nil];
}

- (void)touchPassView:(id)sender
{
    float currentPage   = scrollPass.contentOffset.x / WINDOW_WIDTH;
    NSArray *plistTemp  = [tools propertyListRead:PLIST_STEPS];
    NSDictionary *obj   = [plistTemp objectAtIndex:currentPage];
    
    StepsSingle *vc = [[StepsSingle alloc] initWithDictionary:obj andBackButton:YES];
    [[self navigationController] pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == scrollPass)
    {
        float currentPage = scrollView.contentOffset.x / WINDOW_WIDTH;
        [pagedControl setCurrentPage:currentPage];
        data       = [plist objectAtIndex:currentPage];
        salepoints = [data objectForKey:KEY_SALEPOINTS];
    }
}

@end
