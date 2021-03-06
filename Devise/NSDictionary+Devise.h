//
//  NSDictionary+Devise.h
//  Devise
//
//  Created by Patryk Kaczmarek on 08.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Devise)

/**
 *  Return value associated wth key, converted to NSString
 */
- (NSString *)dvs_stringValueForKey:(id)key;

/**
 *  Return integer value associated with key, converted to NSInteger
 */
- (NSInteger)dvs_integerValueForKey:(id)key;

@end
