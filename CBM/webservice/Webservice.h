//
//  Webservice.h
//  CBM
//
//  Created by Felipe Ricieri on 10/04/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Constants

#define CACHE_ALL           @"content_all"
#define CACHE_PILOTS        @"content_pilots"
#define CACHE_TEAMS         @"content_teams"
#define CACHE_STEPS         @"content_steps"
#define CACHE_EXTENSION     @"txt"
#define CACHE_KEY_PILOTS    @"pilots"
#define CACHE_KEY_TEAMS     @"teams"
#define CACHE_KEY_STEPS     @"steps"

#define KEY_TABLE_ROWS      @"tableRows"
#define KEY_TABLE_DETAILS   @"tableDetails"
#define KEY_REF             @"ref"

#define WTV_TYPES           @[@"classProva", @"classChamp", @"classChamp"]

#pragma mark - Interface

@interface Webservice : NSObject
{
    FRTools *tools;
    
    NSString *RESTData;
    NSDictionary *JSONData;
    NSDictionary *nextStep;
    
    NSArray *contentPilots;
    NSArray *contentTeams;
    NSArray *contentSteps;
}

@property (nonatomic, strong) FRTools *tools;
@property (nonatomic, strong) NSString *RESTData;
@property (nonatomic, strong) NSDictionary *JSONData;
@property (nonatomic, strong) NSDictionary *nextStep;

#pragma mark - Methods

- (id) initTheWebservice;
- (void) updateData;
- (NSInteger) currentStepNumber;
- (NSInteger) nextStepNumber;

#pragma mark - Pilots Methods

- (NSArray*) pilots;
- (NSArray*) pilotsForTeam:(NSString*) teamId;
- (NSDictionary*) pilotForNumber:(NSString*) pilotNumber;

#pragma mark - Teams Methods

- (NSArray*) teams;
- (NSDictionary*) teamForId:(NSString*) teamId;

#pragma mark - Steps Methods

- (NSArray*) steps;
- (NSDictionary*) stepForNumber:(NSInteger) stepNumber;

#pragma mark - Rating Methods

- (NSDictionary*) rating;

#pragma mark - WTvision Methods

- (NSArray*) wtvisionResults:(NSArray*) proofs forType:(WTvisionType) wtype;
- (void) wtvisionDataForStep:(NSInteger) stepNumber didSucceed:(void(^)(void)) succed didFail:(void(^)(void)) fail;
- (NSArray*) wtvisionRowsForStep:(NSInteger) stepNumber type:(WTvisionType) wtype;

@end
