//
//  News.m
//  CBM
//
//  Created by Felipe Ricieri on 28/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "News.h"
#import "NewsCell.h"
#import "NewsTitleCell.h"
#import "NewsLoadInfinity.h"
#import "NewsSingle.h"

#define MAIN_BUNDLE     @"NewsCell"

#define CELL            @"newsCell"
#define CELL_TITLE      @"newsTitleCell"

#define CELL_INDEX          0
#define CELL_TITLE_INDEX    1

#define BG              @"cell_news.png"
#define BG_SELECTED     @"cell_news_d.png"

@interface News ()
@property (nonatomic, strong) FRTools *tools;
@property (nonatomic, strong) UpdateData *update;
#pragma mark - 
#pragma mark Inner Methods
- (NSMutableDictionary*) findFeedForId:(NSString*) stringId;
#pragma mark -
#pragma mark SV Methods
- (void) SVPullData:(NSDictionary*) JSON;
- (void) SVInfinityData:(NSDictionary*) JSON;
- (void) SVError;
- (void) loadSingleWithContent:(NSString*) content forId:(NSString *)stringId;
@end

@implementation News

@synthesize tableData;
@synthesize dataReturn;
@synthesize table;
@synthesize tools, update;

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoadWithMenuButton];
    
    // data..
    tools       = [[FRTools alloc] initWithTools];
    tableData   = [tools propertyListRead:PLIST_NEWS];
    update      = [[UpdateData alloc] initWithRootViewController:self];
    
    // weak self..
    __weak typeof(self) weakSelf = self;
    
    // pull to refresh...
    [self.table addPullToRefreshWithActionHandler:^{
        [weakSelf.update requestUpdateFrom:URL_CBM_FEEDS success:^{
            [weakSelf SVPullData:[weakSelf.update JSONData]];
        } fail:^{
            [weakSelf SVError];
        }];
    }];
    
    // infinity...
    [self.table addInfiniteScrollingWithActionHandler:^{
        NSArray *plistReloaded = [weakSelf.tools propertyListRead:PLIST_NEWS];
        NSString *urlToRequest = [NSString stringWithFormat:@"%@/?from=%i&limit=%i", URL_CBM_FEEDS, [plistReloaded count], 5];
        [weakSelf.update requestUpdateFrom:urlToRequest success:^{
            [weakSelf SVInfinityData:[weakSelf.update JSONData]];
        } fail:^{
            [weakSelf SVError];
        }];
        [[weakSelf.table infiniteScrollingView] stopAnimating];
    }];
    
    // inifinity scroll view..
    NSArray *xib    = [[NSBundle mainBundle] loadNibNamed:MAIN_BUNDLE owner:nil options:nil];
    NewsLoadInfinity *infinityLoadView  = (NewsLoadInfinity*)[xib objectAtIndex:2];
    [self configureLabel:[infinityLoadView labelText] withText:[[[infinityLoadView labelText] text] uppercaseString] andSize:14 andColor:COLOR_WHITE];
    [[infinityLoadView activity] startAnimating];
    
    [[[self table] infiniteScrollingView] setCustomView:infinityLoadView forState:SVInfiniteScrollingStateAll];
    
    // trigger pull to refresh
    // if news are empty...
    //if([tableData count] == 0)
        [table triggerPullToRefresh];
}

#pragma mark -
#pragma mark SV Methods

- (void) SVPullData:(NSDictionary*) JSON
{
    NSArray *localData;
    NSMutableArray *plistReloaded;
    
    localData       = [JSON objectForKey:KEY_DATA];
    plistReloaded   = [NSMutableArray array];
    
    // localdata? ..
    if(localData)
    {
        plistReloaded = [NSMutableArray arrayWithArray:localData];
        [tools propertyListWrite:localData forFileName:PLIST_NEWS];
        
        [self setTableData:plistReloaded];
        [[self table] reloadData];
    }
    // stop animating..
    [table.pullToRefreshView stopAnimating];
}

- (void) SVInfinityData:(NSDictionary*) JSON
{
    NSArray *localData;
    NSMutableArray *plistReloaded;
    
    localData       = [JSON objectForKey:KEY_DATA];
    plistReloaded   = [tools propertyListRead:PLIST_NEWS];
    
    // localdata? ..
    if(localData)
    {
        for (NSDictionary *dict in localData)
        {
            [plistReloaded addObject:dict];
        }
        [tools propertyListWrite:plistReloaded forFileName:PLIST_NEWS];
        
        [self setTableData:plistReloaded];
        [[self table] reloadData];
    }
    // stop animating..
    [table.infiniteScrollingView stopAnimating];
}

- (void)SVError
{
    // stop..
    [table.pullToRefreshView stopAnimating];
    [table.infiniteScrollingView stopAnimating];
    [update syncError:@"Tente novamente"];
}

- (void) loadSingleWithContent:(NSString*) content forId:(NSString *)stringId
{
    NSDictionary *obj;
    NSMutableDictionary *dict;
    
    dict    = [self findFeedForId:stringId];
    [dict setObject:content forKey:KEY_CONTENT];
    
    obj     = [NSDictionary dictionaryWithDictionary:dict];
    
    [update syncEnd:@"Conteúdo carregado!"];
    
    NewsSingle *vc = [[NewsSingle alloc] initWithDictionary:obj andBackButton:YES];
    [[self navigationController] pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Methods

- (NSMutableDictionary*) findFeedForId:(NSString *)stringId
{
    NSMutableDictionary *mDict;
    NSArray *plistReloaded;
    
    plistReloaded  = [tools propertyListRead:PLIST_NEWS];
    
    for (NSDictionary *feed in plistReloaded)
    {
        if([[feed objectForKey:KEY_ID] isEqualToString:stringId])
        {
            mDict = (NSMutableDictionary*)feed;
            break;
        }
    }
    return mDict;
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
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // xib
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:MAIN_BUNDLE owner:nil options:nil];
    // data
    id cell      = nil;
    NSDictionary *obj = [tableData objectAtIndex:indexPath.row];
    
    // cells..
    // news title cell..
    if( [[obj objectForKey:KEY_DESCRIPTION] isEqualToString:KEY_EMPTY]
    ||  [[obj objectForKey:KEY_DESCRIPTION] isEqualToString:KEY_SPACE] )
    {
        cell = (NewsTitleCell *)[tableView dequeueReusableCellWithIdentifier:CELL_TITLE];
        if(!cell)
            cell = (NewsTitleCell*)[xib objectAtIndex:CELL_TITLE_INDEX];
        
        [self configureLabel:[cell labelTitle] withText:[[obj objectForKey:KEY_TITLE] uppercaseString] andSize:15.0 andColor:COLOR_BLACK];
    }
    // news cell..
    else
    {
        cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CELL];
        if(!cell)
            cell = (NewsCell*)[xib objectAtIndex:CELL_INDEX];
        
        [self configureLabel:[cell labelTitle] withText:[[obj objectForKey:KEY_TITLE] uppercaseString] andSize:14.0 andColor:COLOR_BLACK];
        [self configureLabel:[cell labelDescription] withText:[obj objectForKey:KEY_DESCRIPTION] andSize:11.0 andColor:COLOR_GREY_LIGHT];
        
        [[cell labelDescription] alignTop];
        [[cell labelTitle] alignBottom];
    }
    
    // bg..
    NSString *urlString = [NSString stringWithFormat:@"%@", [obj objectForKey:KEY_IMAGE]];
    NSURL *nsurl = [NSURL URLWithString:urlString];
    [[cell imgViewPicture] setImageWithURL:nsurl placeholderImage:[UIImage imageNamed:NO_IMAGE]];
    // label..
    [self configureLabel:[cell labelDateDay] withText:[obj objectForKey:KEY_DATE_DAY] andSize:14.0 andColor:COLOR_WHITE];
    [self configureLabel:[cell labelDateMonth] withText:[tools monthForNumber:[[obj objectForKey:KEY_DATE_MONTH] intValue]] andSize:10.0 andColor:COLOR_WHITE];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[update sync:@"Buscando Conteúdo..."];
    
    NSDictionary *obj;
    //NSString *objId;
    //NSString *urlToRequest;
    
    obj            = [tableData objectAtIndex:indexPath.row];
    //objId        = [obj objectForKey:KEY_ID];
    //urlToRequest = [NSString stringWithFormat:@"%@/?id=%@", URL_CBM_CONTENT, objId];
    
    NSURL *urlToOpen = [NSURL URLWithString:[obj objectForKey:KEY_LINK]];
    [[UIApplication sharedApplication] openURL:urlToOpen];
    
    /*// ...
    [update requestUpdateFrom:urlToRequest success:^{
        [self loadSingleWithContent:[update data] forId:objId];
    } fail:^{
        [self SVError];
    }];*/
}

@end
