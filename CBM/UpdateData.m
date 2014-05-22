//
//  UpdateData.m
//  CBM
//
//  Created by Felipe Ricieri on 05/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "UpdateData.h"

/* interface */

@interface UpdateData ()
- (void) loadRequestWithURL:(NSString*) urlParam;
- (void) dataToJSON;
- (void) downloadDataToFile:(NSData*) contentData;
- (void) askToRateApp;
@end

/* implementation */

@implementation UpdateData
{
    FRTools *tools;
}

@synthesize data;
@synthesize updateLastKey;
@synthesize JSONData;
@synthesize parentViewController;
@synthesize loadView;
@synthesize successCallback;
@synthesize failCallback;
@synthesize connection;

#pragma mark -
#pragma mark Lifecycle Methods

- (id) initWithRootViewController:(UIViewController*) viewController
{
    tools           = [[FRTools alloc] initWithTools];
    
    data            = KEY_EMPTY;
    updateLastKey   = KEY_EMPTY;
    JSONData        = [NSDictionary dictionary];
    parentViewController    = viewController;
    
    return self;
}

#pragma mark -
#pragma mark Sync Methods

- (void)sync: (NSString *) message;
{
    [self sync:message success:nil];
}

- (void) sync: (NSString *) message success:(void(^)(void))callback
{
    //
    NSArray *xib    = [[NSBundle mainBundle] loadNibNamed:APP_RESOURCES owner:nil options:nil];
    loadView        = [xib objectAtIndex:0];
    CGRect frame    = loadView.frame;
    frame.origin.y = -64;
    [[parentViewController view] addSubview:loadView];
    [loadView setFrame:frame];
    [loadView initActivity];
}

- (void)syncEnd:(NSString *)message
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [loadView endActivity];
        [loadView removeFromSuperview];
    });
}

- (void)syncError:(NSString *)message
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [loadView endActivity];
        [loadView removeFromSuperview];
    });
}

#pragma mark -
#pragma mark Request Methods

- (void) requestUpdateFrom:(NSString*) strURL
                   success:(void (^)(void))callback
{
    [self requestUpdateFrom:strURL success:callback fail:nil];
}

- (void) requestUpdateFrom:(NSString*) strURL
                   success:(void(^)(void))callback
                      fail:(void(^)(void))finished
{
    NSLog(@"==> UpdateData: Loading content from URL: %@.", strURL);
    
    successCallback = callback;
    failCallback    = finished;
    
    [self loadRequestWithURL:strURL];
}

#pragma mark -
#pragma mark Download Methods

- (void) downlaodDataFrom:(NSString*) strURL
                  success:(void(^)(void))callback
{
    [self downlaodDataFrom:strURL success:callback fail:nil];
}

- (void) downlaodDataFrom:(NSString*) strURL
                  success:(void(^)(void))callback
                     fail:(void(^)(void))finished
{
    NSLog(@"==> UpdateData: Downloading content from URL: %@.", strURL);
    
    NSURL  *url = [NSURL URLWithString:strURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSLog(@"==> UpdateData: Data downloaded successly!");
        
        data = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        // set json..
        if(data) [self dataToJSON];
        // call back..
        if(callback)  callback();
    }
    else {
        NSLog(@"==> UpdateData: Data DID NOT downloaded.");
        
        // call back..
        if(finished) finished();
    }
}

- (void) askToRateApp
{
    NSLog(@"ready to ask");
    NSDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    if (![[logs objectForKey:LOG_RATE_APPSTORE] isEqual:KEY_YES])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Avalie o Aplicativo" message:TEXT_RATE_APP delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Ok!", nil];
        [alertView show];
    }
}

#pragma mark -
#pragma mark In Methods

- (void)loadRequestWithURL:(NSString *)urlParam
{
    NSURL *url          = [NSURL URLWithString:urlParam];
    NSURLRequest *req   = [[NSURLRequest alloc] initWithURL:url
                                                cachePolicy:NSURLCacheStorageNotAllowed
                                            timeoutInterval:6.0];
    
    connection          = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection start];
}

- (void)dataToJSON
{
    NSError *error;
    NSDictionary *result;
    
    SBJSON *json    = [SBJSON new];
    result          = [json objectWithString:data error:&error];
    
    if(result)
    {
        JSONData    = result;
        NSLog(@"==> UpdateData: JSON fetched successly!");
    }
    else {
        NSLog(@"==> UpdateData: The results cannot be fetched as JSON (result is nil).");
    }
}

- (void)downloadDataToFile:(NSData *)contentData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"filename.txt"];
    [contentData writeToFile:filePath atomically:YES];
}

#pragma mark -
#pragma mark Request Updates Methods

- (void) readLogs
{
    NSDictionary *reRead = [tools propertyListRead:PLIST_LOGS];
    NSLog(@"==> Logs PList: %@", reRead);
}

- (NSMutableDictionary *)nextStep
{
    NSArray *propList = [tools propertyListRead:PLIST_UPDATES];
    NSMutableDictionary *nextStep;
    
    for (NSMutableDictionary *step in propList)
    {
        if ([[step objectForKey:KEY_IS_ENDED] isEqual:KEY_NO])
        {
            nextStep = step;
            break;
        }
    }
    
    //NSLog(@"==> nextStep: %@", nextStep);
    return nextStep;
}

- (NSString *) logKeyWithKey:(NSString *)key andUpdate:(NSString *)update
{
    NSString *keyToSearch = [NSString stringWithFormat:@"%@_%@", key, update];
    return keyToSearch;
}

- (NSString*) getNextKeyToUpdate
{
    NSString *updateKey = @"";
    
    // dates..
    NSDate *today       = [NSDate dateWithTimeIntervalSinceNow:ZERO];
    NSDate *nextDate    = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSMutableDictionary *nextStep   = [self nextStep];
    NSString *dateString            = [nextStep objectForKey:KEY_DATE];
    nextDate                        = [dateFormatter dateFromString:dateString];
    
    if (nextStep)
    {
        // compare..
        if ([today compare:nextDate] == NSOrderedSame
        ||  [today compare:nextDate] == NSOrderedDescending)
        {
            NSLog(@"the date is later or same to today");
            NSLog(@"time to update...");
            updateKey = [nextStep objectForKey:KEY_KEY];
        }
        else {
            NSLog(@"[UPDATE] the next update will happen at %@", nextDate);
            // ... ask to rate
            [self askToRateApp];
        }
    }
    
    NSLog(@"==> updateKey: %@", updateKey);
    return updateKey;
}

- (BOOL) checkIfKeyAndUpdateAreDone:(NSString*) key : (NSString*) update
{
    BOOL is;
    NSDictionary *pLogs     = [tools propertyListRead:PLIST_LOGS];
    NSString *keyToSearch   = [self logKeyWithKey:key andUpdate:update];
    
    NSLog(@"==> keyToSearch: %@", keyToSearch);
    
    if ([[pLogs objectForKey:keyToSearch] isEqual:KEY_YES])
    {
        is = YES;
    } else {
        is = NO;
    }
    
    return is;
}

- (BOOL) isReadyToRequestUpdateForKey:(NSString *)key
{
    BOOL isReady = NO;
    NSString *keyToUpdate       = [self getNextKeyToUpdate];
    
    if (![keyToUpdate isEqual:KEY_EMPTY])
    {
        if (![self checkIfKeyAndUpdateAreDone:key : keyToUpdate])
        {
            updateLastKey = key;
            isReady = YES;
        }
    }
    
    return isReady;
}

- (BOOL) checkIfWasEntireUpdated
{
    BOOL can;
    // vars..
    NSMutableArray *pUpdates        = [tools propertyListRead:PLIST_UPDATES];
    NSDictionary *pLogs             = [tools propertyListRead:PLIST_LOGS];
    NSString *currentKey            = [self getNextKeyToUpdate];
    // keys..
    NSString *keyPilots             = [self logKeyWithKey:LOG_UPDATE_PILOTS andUpdate:currentKey];
    NSString *keyTeams              = [self logKeyWithKey:LOG_UPDATE_TEAMS andUpdate:currentKey];
    NSString *keyRating             = [self logKeyWithKey:LOG_UPDATE_RATING andUpdate:currentKey];
    NSString *keySteps              = [self logKeyWithKey:LOG_UPDATE_STEPS andUpdate:currentKey];
    NSString *keyStepsRows          = [self logKeyWithKey:LOG_UPDATE_STEPS_ROWS andUpdate:currentKey];
    // check..
    if ([[pLogs objectForKey:keyPilots] isEqual:KEY_YES]
    &&  [[pLogs objectForKey:keyTeams] isEqual:KEY_YES]
    &&  [[pLogs objectForKey:keyRating] isEqual:KEY_YES]
    &&  [[pLogs objectForKey:keySteps] isEqual:KEY_YES]
    &&  [[pLogs objectForKey:keyStepsRows] isEqual:KEY_YES]
    ){
        int p = 0;
        for (NSMutableDictionary *up in pUpdates)
        {
            if ([[up objectForKey:KEY_KEY] isEqual:currentKey])
            {
                [up setObject:KEY_YES forKey:KEY_IS_ENDED];
                [pUpdates setObject:up atIndexedSubscript:p];
                can = YES;
                
                NSLog(@"==> Updates PList updated: %@ is YES", [up objectForKey:KEY_KEY]);
                break;
            }
            p++;
        }
        [tools propertyListWrite:pUpdates forFileName:PLIST_UPDATES];
    }
    else {
        NSLog(@"==> [UPDATE] the update was not entire updated.");
        can = NO;
    }
    // return..
    return can;
}

- (void) updatesDidLoad
{
    NSMutableDictionary *pLogs  = [tools propertyListRead:PLIST_LOGS];
    NSString *keyToUpdate       = [self getNextKeyToUpdate];
    
    // update..
    NSString *keyToLog = [self logKeyWithKey:updateLastKey andUpdate:keyToUpdate];
    [pLogs setObject:KEY_YES forKey:keyToLog];
    [tools propertyListWrite:pLogs forFileName:PLIST_LOGS];
    NSLog(@"==> PList Logs updated with sucess! With key: %@", keyToLog);
    // log..
    //[self readLogs];
    [self checkIfWasEntireUpdated];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            // ...
            // cancelou
        }
            break;
        case 1:
        {
            // ...
            NSURL *urlToOpen = [NSURL URLWithString:URL_APPSTORE];
            [[UIApplication sharedApplication] openURL:urlToOpen];
        }
            break;
    }
    
    // ... ask no more
    NSMutableDictionary *logs = [tools propertyListRead:PLIST_LOGS];
    [logs setObject:KEY_YES forKey:LOG_RATE_APPSTORE];
    [tools propertyListWrite:logs forFileName:PLIST_LOGS];
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dData
{
    data = [[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self dataToJSON];
    
    // call back..
    if (successCallback)
        successCallback();
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [tools errorWithError:error];
    
    // call back..
    if (failCallback)
        failCallback();
}

@end
