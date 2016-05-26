//
//  NSDictionary+ToJSONString.m
//  WebSocketTest
//
//  Created by Stanislav on 5/26/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "NSDictionary+ToJSONString.h"

@implementation NSDictionary (ToJSONString)
- (NSString *)jsonStringWithPrettyPrint:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
