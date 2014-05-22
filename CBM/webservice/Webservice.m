//
//  Webservice.m
//  CBM
//
//  Created by Felipe Ricieri on 10/04/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "Webservice.h"

#pragma mark - Interface

@interface Webservice ()
- (NSDictionary*) objectFromString:(NSString*) string;
- (void) sendGETRequestToEndPoint:(NSString*) urlString withParameter:(NSString*) parameter didSucceed:(void(^)(void)) success didFailed:(void(^)(void)) failure;
- (NSString *) stringValue:(id) value;
@end

#pragma mark - Implementation

@implementation Webservice

@synthesize tools;
@synthesize RESTData;
@synthesize JSONData;
@synthesize nextStep;

#pragma mark - Methods

- (id) initTheWebservice
{
    self = [super init];
    tools = [[FRTools alloc] initWithTools];
    return self;
}
- (void) updateData
{
    [self sendGETRequestToEndPoint:URL_ALL withParameter:KEY_EMPTY didSucceed:^{
        //NSString *fileName = [NSString stringWithFormat:@"%@.txt", CACHE_ALL];
        //[tools saveDataToFile:[self RESTData] fileName:CACHE_ALL];
        if([self RESTData]){
            NSDictionary *dict = @{KEY_CONTENT: [self RESTData]};
            [tools propertyListWrite:dict forFileName:PLIST_2014_CONTENT];
            NSLog(@"- [WS]: cache was updated");
        }
    } didFailed:^{
       // nothing...
    }];
}
- (NSInteger) currentStepNumber
{
    NSInteger number = [self nextStepNumber];
    NSInteger currentStep = number-1;
    NSLog(@"-[WS]: %i", currentStep);
    return currentStep;
}
- (NSInteger) nextStepNumber
{
    NSInteger number = 1;
    NSArray *steps = [self steps];
    for (NSDictionary *dict in steps)
        if ([[dict objectForKey:KEY_IS_ENDED] isEqualToString:KEY_NO]){
            number = [[dict objectForKey:KEY_NUM_STEP] integerValue];
            break;
        }
    
    return number;
}

#pragma mark - Pilots Methods

- (NSArray*) pilots
{
    NSDictionary *cache     = [tools propertyListRead:PLIST_2014_CONTENT];
    NSDictionary *object    = [self objectFromString:[cache objectForKey:KEY_CONTENT]];
    NSArray *data           = [object objectForKey:CACHE_KEY_PILOTS];
    
    return data;
}
- (NSArray*) pilotsForTeam:(NSString*) teamId
{
    NSArray *pilots = [self pilots];
    NSMutableArray *mutarr = [NSMutableArray array];
    
    for (NSDictionary *dict in pilots)
        if ([[dict objectForKey:@"team_id"] isEqualToString:teamId])
            [mutarr addObject:dict];
    
    return [mutarr copy];
}
- (NSDictionary*) pilotForNumber:(NSString*) pilotNumber
{
    NSArray *pilots = [self pilots];
    NSDictionary *object = nil;
    
    for (NSDictionary *dict in pilots)
        if ([[dict objectForKey:KEY_NUMBER] isEqualToString:pilotNumber])
            object = dict;
    
    return object;
}

#pragma mark - Teams Methods

- (NSArray*) teams
{
    NSDictionary *cache     = [tools propertyListRead:PLIST_2014_CONTENT];
    NSDictionary *object    = [self objectFromString:[cache objectForKey:KEY_CONTENT]];
    NSArray *data           = [object objectForKey:CACHE_KEY_TEAMS];
    
    return data;
}
- (NSDictionary*) teamForId:(NSString*) teamId
{
    NSArray *pilots = [self teams];
    NSDictionary *object = nil;
    
    for (NSDictionary *dict in pilots)
        if ([[dict objectForKey:KEY_ID] isEqualToString:teamId])
            object = dict;
    
    return object;
}

#pragma mark - Steps Methods

- (NSArray*) steps
{
    NSDictionary *cache     = [tools propertyListRead:PLIST_2014_CONTENT];
    NSDictionary *object    = [self objectFromString:[cache objectForKey:KEY_CONTENT]];
    NSArray *data           = [object objectForKey:CACHE_KEY_STEPS];
    
    return data;
}
- (NSDictionary*) stepForNumber:(NSInteger) stepNumber
{
    NSArray *pilots = [self steps];
    NSDictionary *object = nil;
    
    for (NSDictionary *dict in pilots)
        if ([[dict objectForKey:KEY_NUM_STEP] isEqualToString:[NSString stringWithFormat:@"%i", stepNumber]])
            object = dict;
    
    return object;
}

#pragma mark - Rating Methods

- (NSDictionary*) rating
{
    NSMutableArray *parr    = [NSMutableArray array];
    NSMutableArray *sarr    = [NSMutableArray array];
    NSArray *pilotsRating   = [self wtvisionRowsForStep:[self currentStepNumber] type:kClassChampsPilots];
    NSArray *shieldsRating  = [self wtvisionRowsForStep:[self currentStepNumber] type:kClassChampsShields];
    
    // pilots..
    for (NSDictionary *dict in [pilotsRating objectAtIndex:0]) {
        NSDictionary *pilot = [self pilotForNumber:[dict objectForKey:KEY_NUMBER]];
        NSDictionary *fdict = @{KEY_ID: [self stringValue:[pilot objectForKey:KEY_ID]],
                                KEY_NAME: [self stringValue:[pilot objectForKey:KEY_NAME]],
                                KEY_CAR: [self stringValue:[pilot objectForKey:KEY_CAR]],
                                KEY_TEAM: [self stringValue:[pilot objectForKey:KEY_TEAM]],
                                KEY_POINTS: [self stringValue:[dict objectForKey:KEY_POINTS]],
                                KEY_NUMBER: [self stringValue:[dict objectForKey:KEY_NUMBER]],
                                KEY_POSITION: [self stringValue:[dict objectForKey:KEY_POSITION]]};
        [parr addObject:fdict];
    }
    
    // shields..
    for (NSDictionary *dict in [shieldsRating objectAtIndex:0]) {
        NSDictionary *fdict = @{KEY_ID: [dict objectForKey:KEY_POSITION],
                                KEY_NAME: [dict objectForKey:KEY_NAME],
                                KEY_SLUG: [[dict objectForKey:KEY_NAME] lowercaseString],
                                KEY_POINTS: [dict objectForKey:KEY_POINTS]};
        [sarr addObject:fdict];
    }
    
    NSDictionary *results = @{@"pilots": parr, @"shields": sarr};
    return results;
}

#pragma mark - WTvision Methods

- (NSArray*) wtvisionResults:(NSArray*) proofs forType:(WTvisionType) wtype
{
    NSMutableArray *mutArr  = [NSMutableArray array];
    NSArray *retArr         = [NSArray array];
    // chasing only the "classProva" dictionaries...
    for (NSDictionary *dict in proofs)
    {
        NSDictionary *tabRows   = [dict objectForKey:KEY_TABLE_ROWS];
        NSDictionary *tabDetail = [dict objectForKey:KEY_TABLE_DETAILS];
        //...
        if (tabDetail)
            if ([[tabDetail objectForKey:KEY_REF] isEqual:[WTV_TYPES objectAtIndex:wtype]]
            && tabRows)
                [mutArr addObject:tabRows];
    }
    
    // hack for "pilots" and "shields"
    if (wtype == kClassChampsPilots){
        NSDictionary *tab = [proofs objectAtIndex:4];
        mutArr = [NSMutableArray array];
        [mutArr addObject:[tab objectForKey:KEY_TABLE_ROWS]];
    }
    if (wtype == kClassChampsShields){
        NSDictionary *tab = [proofs objectAtIndex:5];
        mutArr = [NSMutableArray array];
        [mutArr addObject:[tab objectForKey:KEY_TABLE_ROWS]];
    }
    
    // choosing the last one..
    if ([mutArr count] > 0)
    {
        // wtypes...
        switch (wtype)
        {
            // proof..
            // ...
            case kClassProofs:
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
                
                retArr = [reSteps copy];
            }
                break;
                
            // champ..
            // ...
            case kClassChampsPilots:
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
                        NSString *fPoints       = [self stringValue:[[rows objectAtIndex:3] objectForKey:KEY_VALUE]];
                        
                        NSDictionary *pilotDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   fPosition, KEY_POSITION,
                                                   fNumber, KEY_NUMBER,
                                                   fPilotName, KEY_NAME,
                                                   fPoints, KEY_POINTS, nil];
                        [reProof addObject:pilotDict];
                    }
                    [reSteps addObject:reProof];
                }
                
                retArr = [reSteps copy];
            }
                break;
            
            // champ..
            // ...
            case kClassChampsShields:
            {
                // re-arranging the steps...
                NSMutableArray *reSteps = [NSMutableArray array];
                for (NSArray *proofs in mutArr)
                {
                    NSMutableArray *reProof = [NSMutableArray array];
                    for (NSArray *rows in proofs)
                    {
                        NSString *fPosition     = [self stringValue:[[rows objectAtIndex:0] objectForKey:KEY_VALUE]];
                        NSString *fShieldName   = [self stringValue:[[rows objectAtIndex:1] objectForKey:KEY_VALUE]];
                        NSString *fPoints       = [self stringValue:[[rows objectAtIndex:2] objectForKey:KEY_VALUE]];
                        
                        NSDictionary *pilotDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   fPosition, KEY_POSITION,
                                                   fShieldName, KEY_NAME,
                                                   fPoints, KEY_POINTS, nil];
                        [reProof addObject:pilotDict];
                    }
                    [reSteps addObject:reProof];
                }
                
                retArr = [reSteps copy];
            }
                break;
        }
    }
    
    return retArr;
}
- (void) wtvisionDataForStep:(NSInteger) stepNumber didSucceed:(void(^)(void)) succed didFail:(void(^)(void)) fail
{
    NSString *stepNumberStr = [NSString stringWithFormat:@"%i", stepNumber];
    NSString *slug          = [NSString stringWithFormat:@"%@etapa", stepNumberStr];
    NSMutableDictionary *plist = [tools propertyListRead:PLIST_2014_WTVISION];
    
    NSString *cacheData     = [plist objectForKey:slug];
    NSDictionary *object    = nil;
    if (cacheData) {
        object    = [self objectFromString:cacheData];
    }
    
    NSLog(@"- [WS]: check if cache data is on for step #%@..", stepNumberStr);
    
    if (!object
    ||  ![object objectForKey:KEY_DATA]
    || [[object objectForKey:KEY_DATA] count] < 1)
    {
        NSLog(@"- [WS]: cache data is off..");
        NSString *url = [NSString stringWithFormat:URL_WTVISION, stepNumberStr];
        [self sendGETRequestToEndPoint:url withParameter:KEY_EMPTY didSucceed:^{
            //[tools saveDataToFile:[self RESTData] fileName:dataFileExt];
            [plist setObject:[self RESTData] forKey:slug];
            [tools propertyListWrite:plist forFileName:PLIST_2014_WTVISION];
            NSLog(@"- [WS]: succed! ended to save data..");
            if (succed) succed();
        } didFailed:^{
            NSLog(@"- [WS]: fail! ended to save data..");
            if (fail) fail();
        }];
    }
    else {
        NSLog(@"- [WS]: cache data is on..");
        if (succed) succed();
    }
}
- (NSArray*) wtvisionRowsForStep:(NSInteger) stepNumber type:(WTvisionType) wtype
{
    NSString *stepNumberStr = [NSString stringWithFormat:@"%i", stepNumber];
    NSString *slug          = [NSString stringWithFormat:@"%@etapa", stepNumberStr];
    
    NSDictionary *plist     = [tools propertyListRead:PLIST_2014_WTVISION];
    NSString *cacheData     = [plist objectForKey:slug];
    NSDictionary *object    = [self objectFromString:cacheData];
    
    NSArray *results = [self wtvisionResults:[object objectForKey:KEY_DATA] forType:wtype];
    return results;
}

#pragma mark - Private Methods

- (NSDictionary*) objectFromString:(NSString*) string
{
    SBJSON *json = [SBJSON new];
    NSDictionary *data = [json objectWithString:string];
    return data;
}
- (void) sendGETRequestToEndPoint:(NSString*) urlString withParameter:(NSString*) parameter didSucceed:(void(^)(void)) success didFailed:(void(^)(void)) failure
{
    NSString *urlWithParams = [NSString stringWithFormat:@"%@?%@", urlString, parameter];
    NSURL *url              = [NSURL URLWithString:urlWithParams];
    NSMutableURLRequest *req= [[NSMutableURLRequest alloc] initWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:20.0];
    //[req setHTTPMethod:@"POST"];
    //[req setHTTPBody:[POSTData dataUsingEncoding:NSUTF8StringEncoding]];
    
	[NSURLConnection sendAsynchronousRequest:req
									   queue:[NSOperationQueue mainQueue]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   
                               // error..
							   if (connectionError)
								   if (failure)
									   failure();
                               
							   // data..
							   if (data) {
								   RESTData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSError *error;
                                   NSDictionary *result;
                                   SBJSON *json    = [SBJSON new];
                                   result          = [json objectWithString:RESTData error:&error];
                                   
                                   if(result)
                                   {
                                       JSONData    = result;
                                       NSLog(@"- [WS]: JSON fetched successly!");
                                   }
                                   else {
                                       NSLog(@"- [WS]: The results cannot be fetched as JSON (result is nil).");
                                       NSLog(@"- [WS] RESTData: %@", RESTData);
                                   }
							   }
                               
                               // success..
							   if (success)
								   success();
                           }];
}
- (NSString *) stringValue:(id) value
{
    if(!value) value = @"";
    NSString *str = [NSString stringWithFormat:@"%@", value];
    return str;
}

@end
