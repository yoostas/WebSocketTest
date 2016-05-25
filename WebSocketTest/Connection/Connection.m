//
//  Connection.m
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "Connection.h"

@interface Connection()
@property (strong, nonatomic) SRWebSocket *testSocket;
@end

@implementation Connection

#pragma mark - Singletone initialization

+(Connection *) sharedConnection {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    [self setupSockets];
    return [super init];
}

#pragma mark - Socket setup

- (void) setupSockets {
    self.testSocket.delegate = nil;
    [self.testSocket close];
    NSURL *url = [NSURL URLWithString:wsServerUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SRWebSocket *mySocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.testSocket = mySocket;
    self.testSocket.delegate = self;
    [self.testSocket open];
}

- (void) socketOpen {
    [self setupSockets];
}

- (void) socketClose {
    self.testSocket.delegate = nil;
    [self.testSocket close];
}

#pragma mark - Interaction

-(void) loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    if (!self.testSocket) {
        [self setupSockets];
    }
    NSString *randomString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *loginMessage = [NSString stringWithFormat:@"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"%@\",\"data\":{\"email\":\"%@\",\"password\":\"%@\"}}",randomString,email,password];
    [self.testSocket send:loginMessage];
}

#pragma mark - Sockets delegate

- (void) webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.delegate connectioIsOk];
}

- (void) webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSString *receivedMessage = message;
    if (receivedMessage) {
        [self.delegate messageReseived:[self dictionaryFromString:receivedMessage]];
    }    
}

- (void) webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"FAIL with erro %@",[error localizedDescription]);
    [self.delegate connectionIsNotOk];
    [self  setupSockets];
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self.delegate connectionIsNotOk];
}

#pragma mark - Message processing

- (NSDictionary *) dictionaryFromString:(NSString *)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        return jsonDictionary;
    }
    else {
        return [NSDictionary new];
    }
}

@end
