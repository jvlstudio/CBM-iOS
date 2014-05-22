//
//  AppConstants.h
//  CBM
//
//  Created by Felipe Ricieri on 10/04/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#ifndef CBM_AppConstants_h
#define CBM_AppConstants_h

#define IS_IPHONE5          (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IPHONE5_OFFSET      88
#define IPHONE5_COEF        IS_IPHONE5 ? ZERO : IPHONE5_OFFSET

#define ZERO                        0

#define STATUS_BAR_HEIGHT           20
#define NAVIGATIONBAR_HEIGHT        44
#define WINDOW_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define WINDOW_HEIGHT               [[UIScreen mainScreen] bounds].size.height-STATUS_BAR_HEIGHT

#define VIEW_HEIGHT                 WINDOW_HEIGHT - STATUS_BAR_HEIGHT
#define NAV_VIEW_HEIGHT             WINDOW_HEIGHT - NAVIGATIONBAR_HEIGHT

#define FONT_UBUNTU                 @"Ubuntu-BoldItalic"
#define FONT_NEOTECH                @"NeoTechStd-MediumItalic"
#define FONT_NEOSANS                @"NeoSansIntel-MediumItalic"

#define FONT_NAME                   FONT_NEOTECH

#define FACEBOOK_APP_ID             @"545799515482272"
#define FACEBOOK_APP_SECRET         @"6c74c81d8f2e91ad750e938f181fa838"
#define GOOGLE_ANALYTICS_TRACKER    @""
#define PARSE_APP_ID                @"fVyVhCs85hpgBuiVmKdQww28uBYxyVNVNa8B673p"
#define PARSE_APP_SECRET            @"PWxb89bui7GbpEDZrigrPSJTI0clGAiNn2E59W5e"
#define CRASH_ANALYTICS_KEY         @"48118b9b5992c16c30f272709e02fe01c05ee2d5"

#define APP_RESOURCES               @"AppResources"

/* colors */

#define COLOR_WHITE         [UIColor whiteColor]
#define COLOR_BLACK         [UIColor blackColor]
#define COLOR_CLEAR         [UIColor clearColor]

#define COLOR_GREY_LIGHT    [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]
#define COLOR_GREY_LIGHTER  [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0]
#define COLOR_YELLOW        [UIColor colorWithRed:236.0/255.0 green:201.0/255.0 blue:50.0/255.0 alpha:1.0]
#define COLOR_GREEN         [UIColor colorWithRed:31.0/255.0 green:93.0/255.0 blue:46.0/255.0 alpha:1.0]
#define COLOR_GREEN_LIGHT   [UIColor colorWithRed:67.0/255.0 green:168.0/255.0 blue:79.0/255.0 alpha:1.0]

/* view controllers */

#define VC_MENU             @"Menu"
#define VC_HOME             @"Home"
#define VC_NEWS             @"News"
#define VC_PILOTS           @"Pilot"
#define VC_TEAMS            @"Teams"
#define VC_TICKETS          @"Tickets"
#define VC_RATING           @"Rating"
#define VC_STEPS            @"Steps"
#define VC_SETTINGS         @"Settings"
#define VC_LIVE             @"Live"

#define TITLE_HOME          @"Copa Petrobras de Marcas"
#define TITLE_NEWS          @"News"
#define TITLE_PILOTS        @"Pilotos"
#define TITLE_TEAMS         @"Equipes"
#define TITLE_TICKETS       @"Ingressos"
#define TITLE_RATING        @"Classificação"
#define TITLE_STEPS         @"Etapas"
#define TITLE_SETTINGS      @"Configurações"
#define TITLE_LIVE          @"AO VIVO"

/* plists */

#define PLIST_MENU              @"CBM-Menu"
#define PLIST_PILOTS            @"CBM-Pilots"
#define PLIST_SHIELDS           @"CBM-Shields"
#define PLIST_RATING            @"CBM-Rating"
#define PLIST_STEPS             @"CBM-Steps"
#define PLIST_STEPS_ROWS        @"CBM-Steps-Rows"
#define PLIST_STEPS_PROOFS      @"CBM-Steps-Proofs"
#define PLIST_NEWS              @"CBM-News"
#define PLIST_ROADS_SALEPOINTS  @"CBM-Roads-Salepoints"
#define PLIST_TEAMS             @"CBM-Teams"
#define PLIST_UPDATES           @"CBM-Updates"
#define PLIST_LOGS              @"CBM-Logs"

#define PLIST_2014_CONTENT      @"CBM-2014-ContentAll"
#define PLIST_2014_WTVISION     @"CBM-2014-WTVision"

#define PLIST_KEY_PILOTS        @"pilots"
#define PLIST_KEY_SHIELDS       @"shields"
#define PLIST_KEY_TEAMS         @"teams"

/* urls */

#define URL_QRCODE              @"http://chart.apis.google.com/chart?cht=qr&chs=500x500&chl="
#define URL_IMAGE_HOLD          @"http://brasileirodemarcas.com.br/wp-content/themes/brdemarcas/timthumb.php?src=http://brasileirodemarcas.com.br/wp-content/uploads/2011/07/110712_tar-larg.jpg&w=710&h=400"

#define URL_IKOMM               @"http://apps.ikomm.com.br/cbm2014"
#define URL_GRAPH               [NSString stringWithFormat:@"%@/%@", URL_IKOMM, @"rest"]
#define URL_SAFE                [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"safe.php"]
#define URL_HOME                [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"home.php"]
#define URL_NEWS                @"http://www.brasileirodemarcas.com.br/index.php/mobile-feeds/"
#define URL_STEPS               [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"steps.php"]
#define URL_STEPS_ROWS          [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"steps-rows.php"]
#define URL_PILOTS              [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"pilots.php"]
#define URL_TEAMS               [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"teams.php"]
#define URL_RANKING             [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"ranking.php"]
#define URL_RATING              [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"rating.php"]
#define URL_UPDATE              [NSString stringWithFormat:@"%@/%@", URL_GRAPH, @"update.php"]
#define URL_LIVE                @"http://dataserver.wtvision.com/table/copamarcas"
#define URL_UPLOADS             [NSString stringWithFormat:@"%@/%@", URL_IKOMM, @"uploads/pilots"]

#define URL_CBM                 @"http://www.brasileirodemarcas.com.br/index.php"
#define URL_CBM_FEEDS           [NSString stringWithFormat:@"%@/%@", URL_CBM, @"mobile-feeds"]
#define URL_CBM_CONTENT         [NSString stringWithFormat:@"%@/%@", URL_CBM, @"mobile-feed-content"]

#define URL_APPSTORE            @"https://itunes.apple.com/us/app/inrace-copa-petrobras-marcas/id670257049?ls=1&mt=8"

#define URL_WTVISION            @"http://dataserver.wtvision.com/table/copamarcas/%@etapa/json"
#define URL_ALL                 @"http://apps.ikomm.com.br/cbm2014/rest/all.php"

/* update */

#define UPDATE_HOME                 @"home"
#define UPDATE_PILOTS               @"pilots"
#define UPDATE_TEAMS                @"teams"
#define UPDATE_RATING               @"rating"
#define UPDATE_STEPS                @"steps"
#define UPDATE_STEPS_ROWS           @"steps_rows"

/* logs */

#define LOG_UPDATE_PILOTS           @"pilots"
#define LOG_UPDATE_TEAMS            @"teams"
#define LOG_UPDATE_RATING           @"rating"
#define LOG_UPDATE_STEPS            @"steps"
#define LOG_UPDATE_STEPS_ROWS       @"steps_rows"
#define LOG_UPDATE_LIVE             @"live"
#define LOG_SETTINGS_NOTIFICATIONS  @"settings_notifications"
#define LOG_SHOWN_ANIMATION         @"shownAnimation"
#define LOG_RATE_APPSTORE           @"rateAppStore"

/* alert */

#define TEXT_RATE_APP           @"Está gostando da Copa Petrobras de Marcas? Deixe-nos saber! Avalie o App InRace na App Store."

#define ALERT_TITLE             @"Erro de conexão"
#define ALERT_MESSAGE_PILOT     @"A tabela de pilotos foi atualizada, porém não foi possível carregá-la. Verifique sua conexão com a internet e tente novamente mais tarde."
#define ALERT_MESSAGE_TEAMS     @"A tabela de equipes foi atualizada, porém não foi possível carregá-la. Verifique sua conexão com a internet e tente novamente mais tarde."
#define ALERT_MESSAGE_RATING    @"A tabela de classificação foi atualizada, porém não foi possível carregá-la. Verifique sua conexão com a internet e tente novamente mais tarde."
#define ALERT_MESSAGE_STEPS     @"A tabela de etapas foi atualizada, porém não foi possível carregá-la. Verifique sua conexão com a internet e tente novamente mais tarde."
#define ALERT_CANCEL_BUTTON     @"OK"

#define SYNC_START_MESSAGE      @"Carregando atualização..."
#define SYNC_END_MESSAGE        @"Atualização Completa!"
#define SYNC_ERROR_MESSAGE      @"Erro ao carregar atualização."

/* menu */

#define SIDE_MENU_OFFSET        84.0

#endif
