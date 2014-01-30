//
//  MenuConstants.h
//  CBM
//
//  Created by Felipe Ricieri on 27/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#ifndef CBM_MenuConstants_h
#define CBM_MenuConstants_h

#define DELAY           0.3

#define INDEX_HOME      1
#define INDEX_NEWS      7
#define INDEX_PILOTS    3
#define INDEX_TEAMS     4
#define INDEX_TICKETS   6
#define INDEX_RATING    2
#define INDEX_STEPS     5
#define INDEX_LIVE      0
#define INDEX_SETTINGS  8

#define MENU_WIDTH      236

#define TABLE_MENU              0
#define TABLE_PILOTS            1
#define TABLE_SEARCH            2
#define TABLE_SEARCH_SECTION    3

#define SEARCH_SECTION_PILOTS   0
#define SEARCH_SECTION_NEWS     1
#define SEARCH_SECTION_STEPS    2

#define SEARCH_HEIGHT           (IS_IPHONE5 ? 283 : 195)

#define CGRECT_SEARCH   CGRectMake(ZERO, 70, WINDOW_WIDTH, SEARCH_HEIGHT)
#define CGRECT_0        CGRectMake(-MENU_WIDTH, ZERO, MENU_WIDTH, WINDOW_HEIGHT+20)
#define CGRECT_1        CGRectMake(ZERO, ZERO, MENU_WIDTH, WINDOW_HEIGHT+20)
#define CGRECT_2        CGRectMake(MENU_WIDTH, ZERO, MENU_WIDTH, WINDOW_HEIGHT+20)

#define CELL_MENU           @"menuCell"
#define CELL_MENU_PILOT     @"menuPilotCell"
#define CELL_MENU_SEARCH    @"menuSearchCell"

#define XIB_RESOURCES       @"MenuResources"

#define BG_CELL_PILOT       @"cell_menu_pilot.png"
#define BG_CELL_PILOT_D     @"cell_menu_pilot_d.png"
#define BG_CELL_SEARCH      @"cell_menu_search.png"
#define BG_CELL_SEARCH_D    @"cell_menu_search_d.png"

typedef enum PilotsOrTeams : NSUInteger
{
    kPilotChosen    = 0,
    kTeamChosen     = 1
}
PilotsOrTeams;

#endif
