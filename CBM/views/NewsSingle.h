//
//  NewsSingle.h
//  CBM
//
//  Created by Felipe Ricieri on 28/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "CBMViewController.h"

@interface NewsSingle : CBMViewController
<UIScrollViewDelegate, UIWebViewDelegate, UIActionSheetDelegate>

/* data */

@property (nonatomic) BOOL hasBackButton;
@property (nonatomic, strong) NSDictionary *dict;

/* imgviews */

@property (nonatomic, strong) IBOutlet UIImageView *imgViewBottom;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewTitle;

/* labels */

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelDateDay;
@property (nonatomic, strong) IBOutlet UILabel *labelDateMonth;

/* others */

@property (nonatomic, strong) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) IBOutlet UIView *viewContent;
@property (nonatomic, strong) IBOutlet UIWebView *webContent;
@property (nonatomic, strong) IBOutlet UIButton *btShare;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;

#pragma mark -
#pragma mark IBAction

- (IBAction) pressBtShare:(id)sender;

@end
