//
//  UpdateData.h
//  CBM
//
//  Created by Felipe Ricieri on 05/07/13.
//  Copyright (c) 2013 ikomm Digital Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBMRefreshView.h"

@interface UpdateData : NSObject <NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *updateLastKey;
@property (nonatomic, strong) NSDictionary *JSONData;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) CBMRefreshView *loadView;

@property (nonatomic, copy) void (^successCallback)(void);
@property (nonatomic, copy) void (^failCallback)(void);

#pragma mark -
#pragma mark Init Methods

- (id) initWithRootViewController:(UIViewController*) viewController;

#pragma mark -
#pragma mark Sync Methods

- (void) sync: (NSString *) message;
- (void) sync: (NSString *) message success:(void(^)(void))callback;

- (void) syncEnd: (NSString *) message;
- (void) syncError: (NSString *) message;

#pragma mark -
#pragma mark Request Methods

- (void) requestUpdateFrom:(NSString*) strURL
                   success:(void(^)(void))callback;

- (void) requestUpdateFrom:(NSString*) strURL
                   success:(void(^)(void))callback
                      fail:(void(^)(void))finished;

#pragma mark -
#pragma mark Download Methods

- (void) downlaodDataFrom:(NSString*) strURL
                  success:(void(^)(void))callback;

- (void) downlaodDataFrom:(NSString*) strURL
                  success:(void(^)(void))callback
                     fail:(void(^)(void))finished;

#pragma mark -
#pragma mark Request Updates Methods

- (void) readLogs;
- (NSMutableDictionary *)nextStep;
- (NSString*) logKeyWithKey:(NSString*) key andUpdate:(NSString*) update;
- (NSString*) getNextKeyToUpdate;
- (BOOL) checkIfKeyAndUpdateAreDone:(NSString*) key : (NSString*) update;
- (BOOL) isReadyToRequestUpdateForKey:(NSString*) key;
- (void) updatesDidLoad;
- (BOOL) checkIfWasEntireUpdated;

@end
