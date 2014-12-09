//
//  DVSHTTPClient.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import "DVSHTTPClient.h"
#import "DVSMacros.h"

@implementation DVSHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self == nil) return nil;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;
}

DVSWorkInProgress("Retry mechanism will return");

@end
