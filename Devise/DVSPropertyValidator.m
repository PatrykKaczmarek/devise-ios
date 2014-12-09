//
//  DVSPropertyValidator.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPropertyValidator.h"
#import "DVSConfiguration.h"
#import "NSString+Devise.h"
#import "NSNumber+Devise.h"
#import "NSError+Devise.h"
#import "NSDate+Devise.h"
#import "DVSValidator.h"

static inline NSString * intToString(NSUInteger x) {
    return [NSString stringWithFormat:@"%lu", (unsigned long)x];
}

NSString * const dvs_attribute = @"{attribute}";

@interface DVSPropertyValidator ()

@property (strong, nonatomic) NSMutableArray *validators;
@property (strong, nonatomic) NSMutableDictionary *descriptions;

@end

@implementation DVSPropertyValidator

#pragma mark - Initializers

- (instancetype)initWithPropertyName:(NSString *)propertyName {
    self = [super init];
    if (self) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
        _propertyName = [propertyName stringByTrimmingCharactersInSet:set];
        _validators = [NSMutableArray array];
        _descriptions = [NSMutableDictionary dictionary];
        [self initializeValidatorMessages];
    }
    return self;
}

+ (DVSPropertyValidator *)validatorForPropertyName:(NSString *)propertyName {
    return [[[self class] alloc] initWithPropertyName:propertyName];
}

#pragma mark - Public Methods

- (NSError *)simpleValidationOfValue:(id)value {
    
    for (DVSValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            return error;
        }
    }
    return nil;
}

- (NSArray *)complexValidationOfValue:(id)value {
    NSMutableArray *array = [NSMutableArray array];
    
    for (DVSValidationBlock block in self.validators) {
        NSError *error = block(value);
        if (error) {
            [array addObject:error];
        }
    }
    return array;
}

- (NSDictionary *)errorDescriptions {
    return [self.descriptions copy];
}

- (NSString *)messageforErrorDescription:(DVSErrorDescription)errorDescription {
    return self.descriptions[@(errorDescription)];
}

- (void)setMessage:(NSString *)message forErrorDescription:(DVSErrorDescription)errorDescription {
    self.descriptions[@(errorDescription)] = message;
}

#pragma mark - Messages
#pragma mark Overall Messages

- (DVSPropertyValidator *(^)(NSString *))nilOrEmpty {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionRequired];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))localizedPropertyName {
    return ^(NSString *name) {
        [self setMessage:name forErrorDescription:DVSErrorDescriptionLocalizedPropertyName];
        return self;
    };
}

#pragma mark NSString messages:

- (DVSPropertyValidator *(^)(NSString *))isntEmail {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionSyntaxEmail];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntDecimal {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionDecimal];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooShort {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionTooShort];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooLong {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionTooLong];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))notExactLength {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionExactLength];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))doesntMatch {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionDoesntMatch];
        return self;
    };
}

#pragma mark NSNumber messages:

- (DVSPropertyValidator *(^)(NSString *))isntTrue {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionIsntTrue];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntFalse {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionIsntFalse];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooSmall {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionTooSmall];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))tooBig {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionTooBig];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))notExact {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionExact];
        return self;
    };
}

#pragma mark Compare messages:

- (DVSPropertyValidator *(^)(NSString *))isntEqual {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionEqual];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isEqual {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionNotEqual];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntGreater {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionGreaterThan];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntLess {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionLessThan];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntGreaterOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionGreaterThanOrEqualTo];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))isntLessOrEqual {
    return ^(NSString *message) {
        [self setMessage:message forErrorDescription:DVSErrorDescriptionLessThanOrEqualTo];
        return self;
    };
}

#pragma mark - Rules
#pragma mark Overall rules:

- (DVSPropertyValidator *(^)())required {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSObject *value) {
            if (!value || [value isKindOfClass:[NSNull class]]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionRequired];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSObject *, DVSComparisionOperator))compareTo {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSObject *compareObject, DVSComparisionOperator comparisionOperator) {
        [self.validators addObject:^(NSObject *value) {
            
            if ([value isKindOfClass:[NSNumber class]]) {
                return [weakSelf compareNumber:(NSNumber *)value toNumber:(NSNumber *)compareObject usingOperator:comparisionOperator];
                
            } else if ([value isKindOfClass:[NSDate class]]) {
                return [weakSelf compareDate:(NSDate *)value toDate:(NSDate *)compareObject usingOperator:comparisionOperator];
                
            } else {
                NSString *description = [NSString stringWithFormat:@"Only NSDate and NSNumber objects can be compared to eachoter. Given parameter is kind of %@ class", [value class]];
                [weakSelf assertWithDescription:description];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSString rules:

- (DVSPropertyValidator *(^)())emailSyntax {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value dvs_isEmail]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionSyntaxEmail];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)())decimal {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value dvs_isDecimal]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionDecimal];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger min, NSUInteger max))lengthRange {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger min, NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooShort attribute:intToString(min)];
            } else if (value.length > max) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger min))minLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger min) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length < min) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooShort attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger max))maxLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length > max) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooLong attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSUInteger length))exactLength {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSUInteger length) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (value.length != length) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionExactLength attribute:intToString(length)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSString *))match {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSString class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToString:string]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionDoesntMatch attribute:string];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark NSNumber rules:

- (DVSPropertyValidator *(^)())falseValue {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@NO]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionIsntFalse];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)())trueValue {
    __weak typeof(self) weakSelf = self;
    
    return ^() {
        [self.validators addObject:^(NSNumber *value) {
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value isEqualToNumber:@YES]) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionIsntTrue];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))min {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger min) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooSmall attribute:intToString(min)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))max {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger max) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger, NSInteger))range {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger min, NSInteger max) {
        [self.validators addObject:^(NSString *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (value.floatValue < min) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooSmall attribute:intToString(min)];
            } else if (value.floatValue > max) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionTooBig attribute:intToString(max)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

- (DVSPropertyValidator *(^)(NSInteger))exact {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger exact) {
        [self.validators addObject:^(NSNumber *value) {
            
            if (![weakSelf isObject:value kindOfClass:[NSNumber class]]) {
                return (NSError *)nil;
            } else if (![value compare:@(exact)] == NSOrderedSame) {
                return [weakSelf errorWithMessage:DVSErrorDescriptionExact attribute:intToString(exact)];
            }
            return (NSError *)nil;
        }];
        return self;
    };
}

#pragma mark - Private Methods

- (NSError *)compareNumber:(NSNumber *)number toNumber:(NSNumber *)compareNumber usingOperator:(DVSComparisionOperator)comparisionOperator {
    
    if (![self isObject:compareNumber kindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    NSString *attribute = compareNumber.stringValue;
    switch (comparisionOperator) {
        case DVSComparisionOperatorEqual:
            if (![number isEqualToNumber:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorNotEqual:
            if ([number isEqualToNumber:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionNotEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThan:
            if (![number dvs_isLessThan:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionLessThan attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThan:
            if (![number dvs_isGreaterThan:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionGreaterThan attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThanOrEqualTo:
            if (![number dvs_isLessThanOrEqualTo:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionLessThanOrEqualTo attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThanOrEqualTo:
            if (![number dvs_isGreaterThanOrEqualTo:compareNumber]) {
                return [self errorWithMessage:DVSErrorDescriptionGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSError *)compareDate:(NSDate *)date toDate:(NSDate *)compareDate usingOperator:(DVSComparisionOperator)comparisionOperator {
    
    if (![self isObject:compareDate kindOfClass:[NSDate class]]) {
        return nil;
    }
    
    NSString *attribute = [self.dateFormatter stringFromDate:compareDate];
    switch (comparisionOperator) {
        case DVSComparisionOperatorEqual:
            if (![date isEqual:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorNotEqual:
            if ([date isEqualToDate:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionNotEqual attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThan:
            if (![date dvs_isEarlierThan:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionLessThan attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThan:
            if (![date dvs_isLaterThan:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionGreaterThan attribute:attribute];
            } break;
        case DVSComparisionOperatorLessThanOrEqualTo:
            if (![date dvs_isEarlierThanOrEqualTo:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionLessThanOrEqualTo attribute:attribute];
            } break;
        case DVSComparisionOperatorGreaterThanOrEqualTo:
            if (![date dvs_isLaterThanOrEqualTo:compareDate]) {
                return [self errorWithMessage:DVSErrorDescriptionGreaterThanOrEqualTo attribute:attribute];
            } break;
    }
    return nil;
}

- (NSError *)errorWithMessage:(DVSErrorDescription)message attribute:(NSString *)attribute {
    NSString *propertyName = [self messageforErrorDescription:DVSErrorDescriptionLocalizedPropertyName];
    NSString *description = [NSString stringWithFormat:@"%@ %@", propertyName, [self messageforErrorDescription:message]];
    if (attribute) {
        description = [description stringByReplacingOccurrencesOfString:dvs_attribute withString:attribute];
    }
    return [NSError dvs_errorWithDescription:description code:DVSErrorValidationFailed];
}

- (NSError *)errorWithMessage:(DVSErrorDescription)message {
    return [self errorWithMessage:message attribute:nil];
}

- (BOOL)isObject:(NSObject *)object kindOfClass:(Class)class {
    
    if (object == nil) {
        return NO;
        
    } else if (![object isKindOfClass:class]) {
        NSAssert3(NO, @"Parameter %@(%@ class) is not kind of %@ class", object, [object class], class);
    }
    return YES;
}

- (void)assertWithDescription:(NSString *)description {
    NSAssert(NO, description);
}

- (void)initializeValidatorMessages {
    [self setMessage:@"cannot be nil or empty" forErrorDescription:DVSErrorDescriptionRequired];
    [self setMessage:_propertyName forErrorDescription:DVSErrorDescriptionLocalizedPropertyName];
    // NSString:
    [self setMessage:@"is too short. Should be min {attribute} signs." forErrorDescription:DVSErrorDescriptionTooShort];
    [self setMessage:@"is too long. Should be max {attribute} signs." forErrorDescription:DVSErrorDescriptionTooLong];
    [self setMessage:@"hasn't exact length. Should has {attribute} signs." forErrorDescription:DVSErrorDescriptionExactLength];
    [self setMessage:@"has invalid email syntax" forErrorDescription:DVSErrorDescriptionSyntaxEmail];
    [self setMessage:@"isn't decimal" forErrorDescription:DVSErrorDescriptionDecimal];
    [self setMessage:@"doesn't match {attribute}" forErrorDescription:DVSErrorDescriptionDoesntMatch];
    
    // NSNumber:
    [self setMessage:@"is too small. Should be min {attribute}." forErrorDescription:DVSErrorDescriptionTooSmall];
    [self setMessage:@"is too big. Should be max {attribute}." forErrorDescription:DVSErrorDescriptionTooBig];
    [self setMessage:@"should be true." forErrorDescription:DVSErrorDescriptionIsntTrue];
    [self setMessage:@"should be false." forErrorDescription:DVSErrorDescriptionIsntFalse];
    [self setMessage:@"isn't exact. Should be {attribute}." forErrorDescription:DVSErrorDescriptionExact];
    
    // Two NSObjects comparision:
    [self setMessage:@"isn't equal to {attribute}" forErrorDescription:DVSErrorDescriptionEqual];
    [self setMessage:@"is equal to {attribute}" forErrorDescription:DVSErrorDescriptionNotEqual];
    [self setMessage:@"is greater than or equal to {attribute}. Should be less than {attribute}." forErrorDescription:DVSErrorDescriptionLessThan];
    [self setMessage:@"is less than or equal to {attribute}. Should be greater than {attribute}." forErrorDescription:DVSErrorDescriptionGreaterThan];
    [self setMessage:@"is greater than {attribute}. Should be less or equal to {attribute}." forErrorDescription:DVSErrorDescriptionLessThanOrEqualTo];
    [self setMessage:@"is less than {attribute}. Should be greater or equal to {attribute}." forErrorDescription:DVSErrorDescriptionGreaterThanOrEqualTo];
}

- (NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _dateFormatter = dateFormatter;
    }
    return _dateFormatter;
}

@end
