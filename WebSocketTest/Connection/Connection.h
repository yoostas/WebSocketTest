//
//  Connection.h
//  WebSocketTest
//
//  Created by Stanislav on 5/24/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"

@interface Connection : NSObject <SRWebSocketDelegate>
+ (Connection *) sharedConnection;

+ (instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)sendMessage:(NSString *)message;
@end
