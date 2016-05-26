//
//  Connection.h
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import "NSString+ValidationAndDictionary.h"
#import "NSDictionary+ToJSONString.h"

static NSString * const errorType               = @"CUSTOMER_ERROR";
static NSString * const successType             = @"CUSTOMER_API_TOKEN";
static NSString * const apiToken                = @"api_token";
static NSString * const apiTokenExparationDate  = @"api_token_expiration_date";
static NSString * const errorDescription        = @"error_description";

static NSString * const kServicename            = @"testService"; //for sskeychin

static NSString * const wsServerUrl             = @"ws://52.29.182.220:8080/customer-gateway/customer";



@protocol ConnectionDelegate <NSObject>
@required
- (void) messageReseived:(NSDictionary *)message;
- (void) connectioIsOk;
- (void) connectionIsNotOk;
@end

@interface Connection : NSObject <SRWebSocketDelegate>

@property (weak, nonatomic) NSObject <ConnectionDelegate> *delegate;

+ (Connection *) sharedConnection;

+ (instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void) socketOpen;
- (void) socketClose;
- (void) setupSockets;

- (void) loginWithEmail:(NSString *)email andPassword:(NSString *)password;
@end
