//
//  NSString+ValidationAndDictionary.m
//  WebSocketTest
//
//  Created by Stanislav on 5/26/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import "NSString+ValidationAndDictionary.h"

@implementation NSString (ValidationAndDictionary)

-(BOOL) isValidEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSDictionary *) dictionaryFromString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
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
