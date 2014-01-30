//
//  PilotConstants.h
//  CBM
//
//  Created by Felipe Ricieri on 27/06/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#ifndef CBM_PilotConstants_h
#define CBM_PilotConstants_h

#define MAIN_BUNDLE     @"PilotCells"
#define CELL_PILOT      @"pilotCell"
#define CELL_PILOT_CAR  @"pilotCarCell"

#define BG_PILOT_LIGHT      @"cell_pilot_light.png"
#define BG_PILOT_DARK       @"cell_pilot_dark.png"
#define BG_PILOT_CAR_LIGHT  @"cell_pilot_car_light.png"
#define BG_PILOT_CAR_DARK   @"cell_pilot_car_dark.png"

#define DELAY               0.4

#define TABLE_Y_MIN         201
#define TABLE_Y_MAX         38
#define TABLE_HEIGHT_MIN    IS_IPHONE5 ? 304 : 216
#define TABLE_HEIGHT_MAX    IS_IPHONE5 ? 461 : 373

#define SECTION_Y           163

#define FRAME_SECTION_MIN1  CGRectMake(107, SECTION_Y, WINDOW_WIDTH, TABLE_Y_MAX)
#define FRAME_SECTION_MIN2  CGRectMake(0, SECTION_Y, WINDOW_WIDTH, TABLE_Y_MAX)
#define FRAME_SECTION_MIN3  CGRectMake(-107, SECTION_Y, WINDOW_WIDTH, TABLE_Y_MAX)

#define FRAME_SECTION_MAX1  CGRectMake(107, ZERO, WINDOW_WIDTH, TABLE_Y_MAX)
#define FRAME_SECTION_MAX2  CGRectMake(0, ZERO, WINDOW_WIDTH, TABLE_Y_MAX)
#define FRAME_SECTION_MAX3  CGRectMake(-107, ZERO, WINDOW_WIDTH, TABLE_Y_MAX)

#define FRAME_TABLE_MIN0    CGRectMake(-WINDOW_WIDTH, TABLE_Y_MIN, WINDOW_WIDTH, TABLE_HEIGHT_MIN)
#define FRAME_TABLE_MIN1    CGRectMake(ZERO, TABLE_Y_MIN, WINDOW_WIDTH, TABLE_HEIGHT_MIN)
#define FRAME_TABLE_MIN2    CGRectMake(WINDOW_WIDTH, TABLE_Y_MIN, WINDOW_WIDTH, TABLE_HEIGHT_MIN)
#define FRAME_TABLE_MIN3    CGRectMake(WINDOW_WIDTH*2, TABLE_Y_MIN, WINDOW_WIDTH, TABLE_HEIGHT_MIN)

#define FRAME_TABLE_MAX0    CGRectMake(-WINDOW_WIDTH, TABLE_Y_MAX, WINDOW_WIDTH, TABLE_HEIGHT_MAX)
#define FRAME_TABLE_MAX1    CGRectMake(ZERO, TABLE_Y_MAX, WINDOW_WIDTH, TABLE_HEIGHT_MAX)
#define FRAME_TABLE_MAX2    CGRectMake(WINDOW_WIDTH, TABLE_Y_MAX, WINDOW_WIDTH, TABLE_HEIGHT_MAX)
#define FRAME_TABLE_MAX3    CGRectMake(WINDOW_WIDTH*2, TABLE_Y_MAX, WINDOW_WIDTH, TABLE_HEIGHT_MAX)

#endif
