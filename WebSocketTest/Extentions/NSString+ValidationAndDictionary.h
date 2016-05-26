//
//  NSString+ValidationAndDictionary.h
//  WebSocketTest
//
//  Created by Stanislav on 5/26/16.
//  Copyright © 2016 Stanislav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidationAndDictionary)
-(BOOL) isValidEmail;
- (NSDictionary *) dictionaryFromString;
@end
