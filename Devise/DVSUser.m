//
//  DVSUser.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import <UICKeyChainStore/UICKeyChainStore.h>

#import "DVSConfiguration.h"
#import "DVSHTTPClient.h"
#import "DVSUser.h"

@interface DVSUser ()

@property (strong, nonatomic, readwrite) NSString *identifier;
@property (strong, nonatomic, readwrite) NSString *email;
@property (strong, nonatomic, readwrite) NSString *token;

@end

#pragma mark -

@implementation DVSUser

#pragma mark Object lifecycle

- (instancetype)initWithJSONRepresentation:(NSDictionary *)dictionary {
    self = [super init];
    if (self == nil) return nil;
    self.identifier = dictionary[@"id"];
    self.email = dictionary[@"email"];
    self.token = dictionary[@"authenticationToken"];
    return self;
}

- (instancetype)init {
    return [self initWithJSONRepresentation:nil];
}

#pragma mark Configuration

+ (DVSConfiguration *)configuration {
    return [DVSConfiguration defaultConfiguration];
}

@end

#pragma mark -

@implementation DVSUser (DVSLocalPersistence)

#pragma mark Local persistence management

+ (instancetype)localUser {
    NSString *keychainService = [self configuration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
    NSData *archivedData = [UICKeyChainStore dataForKey:keychainKey service:keychainService];
    return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}

+ (void)setLocalUser:(DVSUser *)user {
    [self removeLocalUser];
    NSString *keychainService = [self configuration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [UICKeyChainStore setData:archivedData forKey:keychainKey service:keychainService];
}

+ (void)removeLocalUser {
    NSString *keychainService = [self configuration].keychainServiceName;
    NSString *keychainKey = NSStringFromClass(self);
    [UICKeyChainStore removeItemForKey:keychainKey service:keychainService];
}

#pragma mark Object serialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self == nil) return nil;
    self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
    self.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifier"];
    self.token = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"token"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.identifier forKey:@"token"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

DVSWorkInProgress("Bring back networking");
