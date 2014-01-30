//
//  Menu.h
//  CBM
//
//  Created by Felipe Ricieri on 21/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

typedef enum TypeMenuList : NSInteger
{
    kTypeMenuData   = 0,
    kTypeMenuPilots = 1,
    kTypeMenuTeams  = 2
} TypeMenuList;

@interface Menu : CBMViewController
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) TypeMenuList menuType;

/* menu */

@property (nonatomic, strong) NSMutableArray *menuData;
@property (nonatomic, strong) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) IBOutlet UIView *menuTableHeader;
@property (nonatomic, strong) IBOutlet UIView *menuTableFooter;
@property (nonatomic, strong) IBOutlet UIImageView *menuBg;
@property (nonatomic, strong) IBOutlet UIImageView *menuBgHeader;
@property (nonatomic, strong) IBOutlet UIButton *menuCancelBt;

/* search */

@property (nonatomic, strong) NSMutableArray *searchData;
@property (nonatomic, strong) NSMutableArray *searchTypeData;
@property (nonatomic, strong) IBOutlet UIImageView *imgBg;
@property (nonatomic, strong) IBOutlet UITextField *searchField;
@property (nonatomic, strong) IBOutlet UITableView *searchTable;

/* pilots */

@property (nonatomic, strong) NSArray *pilotsData;
@property (nonatomic, strong) NSArray *teamsData;
@property (nonatomic, strong) IBOutlet UITableView *pilotsTable;
@property (nonatomic, strong) IBOutlet UIView *pilotsTableHeader;
@property (nonatomic, strong) IBOutlet UIButton *pilotsBackButton;

#pragma mark -
#pragma mark Init Methods

- (id) initWithMenuType:(TypeMenuList) dMenuType;

#pragma mark -
#pragma mark IBActions

- (IBAction) pressPilotsBackButton:(id)sender;
- (IBAction) pressMenuCancelButton:(id)sender;

#pragma mark -
#pragma mark Menu Action

- (void) menuSlideOptions;
- (void) menuSlidePilotsAndTeamsForLog:(NSString*) log;
- (void) menuSearchStart;
- (void) menuSearchFinish:(SEL) selectorToExec andData:(NSDictionary*) dDict;

@end
