//
//  DVSConfiguration.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

/// The configuration object
@interface DVSConfiguration : NSObject

/// The root URL of the server backend.
@property (copy, nonatomic) NSURL *serverURL;

/// The server-side api version (default: 1).
@property (assign, nonatomic) NSUInteger apiVersion;

/// The keychain service name for local users persistence.
@property (copy, nonatomic) NSString *keychainServiceName;

/// The number of retries in case of connection issues (default: 0).
@property (assign, nonatomic) NSUInteger numberOfRetries;

/// The duration (in seconds) after which a next retry happens (default: 0).
@property (assign, nonatomic) NSTimeInterval retryTresholdDuration;

/// Whether the network activity indicator should be visible.
@property (assign, nonatomic) BOOL showsNetworkActivityIndicator;

// /////////////////////////////////////////////////////////////////////////////

/// Returns a default instance of the configuration object.
+ (instancetype)defaultConfiguration;

/// Creates and returns an instance of configuration object.
///
/// @param serverURL The root URL of the server backend.
- (instancetype)initWithServerURL:(NSURL *)serverURL NS_DESIGNATED_INITIALIZER;

@end
