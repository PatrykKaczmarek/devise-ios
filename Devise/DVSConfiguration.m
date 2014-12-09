//
//  DVSConfiguration.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "DVSConfiguration.h"

@implementation DVSConfiguration

#pragma mark Initialization

+ (instancetype)defaultConfiguration {
    static dispatch_once_t onceToken;
    static DVSConfiguration *defaultConfiguration = nil;
    dispatch_once(&onceToken, ^{
        defaultConfiguration = [[self alloc] initWithServerURL:nil];
    });
    return defaultConfiguration;
}

- (instancetype)initWithServerURL:(NSURL *)serverURL {
    self = [super init];
    if (self == nil) return nil;
    self.serverURL = serverURL;
    self.apiVersion = 1;
    self.keychainServiceName = @"co.netguru.lib.devise.keychain";
    self.numberOfRetries = 0;
    self.retryTresholdDuration = 0.0;
    return self;
}

- (instancetype)init {
    return [self initWithServerURL:nil];
}

#pragma mark Property accessors

- (void)setShowsNetworkActivityIndicator:(BOOL)shows {
    if (_showsNetworkActivityIndicator != shows) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = shows;
        _showsNetworkActivityIndicator = shows;
    }
}

@end
