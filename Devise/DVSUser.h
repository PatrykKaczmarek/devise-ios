//
//  DVSUser.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

@class DVSConfiguration, DVSUser;

/// The completion block of all user-related requests.
///
/// @param user The response user object of the request.
/// @param error An error that occured, if any.
typedef void (^DVSUserRequestCompletionBlock)(DVSUser *user, NSError *error);

/// The completion block of all user-related requests.
///
/// @param error An error that occured, if any.
typedef void (^DVSUserAnonymousRequestCompletionBlock)(NSError *error);

// /////////////////////////////////////////////////////////////////////////////

/// The user data model.
@interface DVSUser : NSObject

/// User's unique identifier.
@property (strong, nonatomic, readonly) NSString *identifier;

/// User's email address.
@property (strong, nonatomic, readonly) NSString *email;

/// An authentication token which can be used in protected requests.
@property (strong, nonatomic, readonly) NSString *token;

// /////////////////////////////////////////////////////////////////////////////

/// Creates a user object by decoding it from its JSON reprensentation.
///
/// You may override this method in your subclasses if you use custom parameters
/// which are present in server responses. Just remember to call super.
///
/// @param dictionary A deserialized JSON dictionary representing a user.
- (instancetype)initWithJSONRepresentation:(NSDictionary *)dictionary;

/// The configuration used by the model.
///
/// Uses the default configuration instance by default. You may return a
/// different configuration object in your subclasses.
///
/// @returns A configuration object to use with this model class.
+ (DVSConfiguration *)configuration;

@end

// /////////////////////////////////////////////////////////////////////////////

@interface DVSUser (DVSLocalPersistence) <NSSecureCoding>

/// A locally saved user object (if any).
+ (instancetype)localUser;

/// Saves the locally saved user object.
+ (void)setLocalUser:(DVSUser *)user;

/// Removes the locally saved user object.
+ (void)removeLocalUser;

@end
