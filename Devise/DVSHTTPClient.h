//
//  DVSHTTPClient.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

/// The DVSHTTPClient class provides a network abstraction layer.
@interface DVSHTTPClient : AFHTTPSessionManager

/// The number of retries in case of connection issues (default: 0).
@property (assign, nonatomic) NSUInteger numberOfRetries;

/// The duration (in seconds) after which a next retry happens (default: 0).
@property (assign, nonatomic) NSTimeInterval retryTresholdDuration;

@end
