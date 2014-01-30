//
//  NewsSingle.m
//  CBM
//
//  Created by Felipe Ricieri on 28/05/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import "NewsSingle.h"

#define TEXT_CONTENT_SIZE   375

@implementation NewsSingle
{
    FRTools *tools;
}

@synthesize hasBackButton;
@synthesize dict;
@synthesize imgViewTitle;
@synthesize imgViewBottom;
@synthesize labelTitle;
@synthesize labelDateDay;
@synthesize labelDateMonth;
@synthesize scroll;
@synthesize viewContent;
@synthesize webContent;
@synthesize btShare;

#pragma mark -
#pragma mark Init Methods

- (id) initWithDictionary:(NSDictionary*) dDict andBackButton:(BOOL) willHaveBackButton;
{
    self = [super initCBMViewController:@"NewsSingle" withTitle:@"Notícia"];
    if(self)
    {
        dict = dDict;
        hasBackButton = willHaveBackButton;
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    if (hasBackButton)
        [super viewDidLoadWithBackButton];
    else
        [super viewDidLoadWithMenuButton];
    
    // methods..
    tools       = [[FRTools alloc] initWithTools];
    
    // labels..
    [self configureLabel:labelTitle withText:[dict objectForKey:KEY_TITLE] andSize:20.0 andColor:COLOR_BLACK];
    [self configureLabel:labelDateDay withText:[dict objectForKey:KEY_DATE_DAY] andSize:14.0 andColor:COLOR_WHITE];
    //[self configureLabel:labelDateMonth withText:[tools monthForNumber:[[dict objectForKey:KEY_DATE_MONTH] intValue]] andSize:11.0 andColor:COLOR_WHITE];
    
    [labelTitle alignTop];
    
    // txt..
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *htmlContent   = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=\"news_single.css\" /></head><body>%@</body></html>", [dict objectForKey:KEY_CONTENT]];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webContent loadHTMLString:htmlContent baseURL:baseURL];
    
    // views..
    CGSize scrollSize = CGSizeMake(WINDOW_WIDTH, viewContent.frame.size.height);
    [scroll setContentSize:scrollSize];
    [scroll addSubview:viewContent];
}

#pragma mark -
#pragma mark IBAction

- (IBAction) pressBtShare:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Abrir em..."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancelar"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Safari", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - 
#pragma mark UIWebViewDelegateMethods

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest
 navigationType:(UIWebViewNavigationType)inType
{
    if ( inType == UIWebViewNavigationTypeLinkClicked )
    {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // scroll
    float contentHeight = [[webContent scrollView] contentSize].height;
    if(contentHeight > TEXT_CONTENT_SIZE)
    {
        float coef = contentHeight - TEXT_CONTENT_SIZE;
        
        // view content..
        CGRect frameContent         = viewContent.frame;
        frameContent.size.height    += coef;
        [viewContent setFrame:frameContent];
        // webview..
        CGRect frameWeb             = webContent.frame;
        frameWeb.size.height        += coef;
        [webContent setFrame:frameWeb];
        // img bottom..
        CGRect frameImgBottom       = imgViewBottom.frame;
        frameImgBottom.origin.y     += coef;
        [imgViewBottom setFrame:frameImgBottom];
        // bt..
        CGRect frameBt              = btShare.frame;
        frameBt.origin.y            += coef;
        [btShare setFrame:frameBt];
    }
    
    CGSize scrollSize = CGSizeMake(WINDOW_WIDTH, viewContent.frame.size.height);
    [scroll setContentSize:scrollSize];
    [scroll addSubview:viewContent];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case ZERO:
        {
            NSURL *urlToOpen = [NSURL URLWithString:[dict objectForKey:KEY_LINK]];
           [[UIApplication sharedApplication] openURL:urlToOpen];
        }
            break;
    }
}

@end
