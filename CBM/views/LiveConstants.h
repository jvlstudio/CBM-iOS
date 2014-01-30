//
//  LiveConstants.h
//  CBM
//
//  Created by Felipe Ricieri on 27/08/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#ifndef CBM_LiveConstants_h
#define CBM_LiveConstants_h

typedef enum CurrentUIInterfaceOrientation : NSUInteger
{
    kInterfaceOrientationPortrait   = 0,
    kInterfaceOrientationLandscape  = 1
}
CurrentUIInterfaceOrientation;

typedef enum TableTag : NSUInteger
{
    kTableTagforPortrait1           = 0,
    kTableTagforPortrait2           = 1,
    kTableTagforPortrait3           = 2,
    kTableTagforPortrait4           = 3,
    kTableTagforLandscape1          = 4,
    kTableTagforLandscape2          = 5,
    kTableTagforLandscape3          = 6,
    kTableTagforLandscape4          = 7
}
TableTag;

#define ROOT_Y              126
#define TABLE_HEIGHT        IS_IPHONE5 ? 378 : 290

#define CELL_STEPS_RESULTS  @"stepsResultsCell"
#define CELL_LAND4          @"liveLandscapeCell4"
#define CELL_LAND5          @"liveLandscapeCell5"

#define CELL_BG             @"cell_steps_results.png"
#define CELL_BG_LAND        @"cell_results_landscape.png"

#define LAP_TIME            @"Lap Time"
#define BEST_LAP_TIME       @"Best Lap Time"

#define XIB_RESOURCES_LIVE  @"StepsResources"
#define CELL_INDEX          2
#define CELL_LAND4_INDEX    6
#define CELL_LAND5_INDEX    8
#define SECTION_INDEX       3
#define SECTION_LAND4_INDEX 5
#define SECTION_LAND5_INDEX 7
#define VIEW_WAITING_INDEX  4

#define TABLE_TRAIN_1       1
#define TABLE_TRAIN_2       2
#define TABLE_PROOF_1       3
#define TABLE_PROOF_2       4
#define TABLE_LANDSCAPE     5

#define TIMER_SECONDS       4.0
#define TIMER_DELAY         1.5

#define KEY_TABLE_ROWS      @"tableRows"
#define KEY_TABLE_DETAILS   @"tableDetails"
#define KEY_REF             @"ref"
#define KEY_PROOF           @"classProva"

#endif
