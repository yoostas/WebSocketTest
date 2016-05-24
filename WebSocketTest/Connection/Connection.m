//
//  Connection.m
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "Connection.h"
static NSString * const wsServerUrl = @"ws://52.29.182.220:8080/customer-gateway/customer";

@interface Connection()
@property (strong, nonatomic) SRWebSocket *testSocket;
@end

@implementation Connection

#pragma mark - Singletone initialization

+(Connection *)sharedConnection {
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

- (void)setupSockets {
    self.testSocket.delegate = nil;
    [self.testSocket close];
    NSURL *url = [NSURL URLWithString:wsServerUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    SRWebSocket *mySocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.testSocket = mySocket;
    self.testSocket.delegate = self;
    [self.testSocket open];
}

- (void)sendMessage:(NSString *)message {
    
}

#pragma mark - Sockets delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"WebSocket is open now %@", webSocket.protocol);
    NSString *jsonString = @"{\"type\":\"LOGIN_CUSTOMER\",\"sequence_id\":\"a29e4fd0-581d-e06b-c837-4f5f4be7dd18\",\"data\":{\"email\":\"fpi@bk.ru\",\"password\":\"123123\"}}";
    [webSocket send:jsonString];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"FAIL with erro %@",[error localizedDescription]);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
}


@end
