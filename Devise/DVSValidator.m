//
//  DVSValidator.m
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSValidator.h"
#import "NSArray+Devise.h"
#import "DVSConfiguration.h"
#import <objc/runtime.h>

@interface DVSValidator ()

@property (strong, nonatomic) NSMutableArray *validators;

@end

@implementation DVSValidator

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        _validators = [NSMutableArray array];
    }
    return self;
}

+ (DVSValidator *)validator {
    return [[[self class] alloc] init];
}

#pragma mark - Public Methods

+ (BOOL)validateModel:(NSObject *)model error:(NSError **)error usingRules:(NSArray *(^)())rules {

    NSError *validationError = [self validateModel:model usingRules:rules returnTypeClass:[NSError class]];
    if (validationError && *error == NULL) {
        *error = validationError;
        return NO;
    }
    return YES;
}

+ (NSArray *)validateModel:(NSObject *)model usingRules:(NSArray *(^)())rules {
    return [self validateModel:model usingRules:rules returnTypeClass:[NSArray class]];
}

#pragma mark - Private Methods

+ (id)validateModel:(NSObject *)model usingRules:(NSArray *(^)())rules returnTypeClass:(Class)class {
    
    BOOL throwFirstError = NO;
    if (class == [NSArray class]) throwFirstError = NO;
    else if (class == [NSError class]) throwFirstError = YES;
    else NSAssert(NO, @"Allowed class: NSArray or NSError");
    
    NSArray *array = rules();
    NSArray *properties = [self propertiesOfModel:model];
    NSMutableArray *errors = [NSMutableArray array];

    for (DVSPropertyValidator *validator in array) {
        [self validatePropertyInValidator:validator ofModel:model];
        if ([properties dvs_containsString:validator.propertyName]) {
            id value = [model valueForKey:validator.propertyName];
            if (throwFirstError) {
                NSError *validationError = [validator simpleValidationOfValue:value];
                if (validationError) {
                    return validationError;
                }
            } else {
                [errors addObjectsFromArray:[validator complexValidationOfValue:value]];
            }
        }
    }
    return throwFirstError ? nil : [errors copy];
}

+ (void)validatePropertyInValidator:(DVSPropertyValidator *)validator ofModel:(NSObject *)model {
    // Tricky part:
    // Compiler doesn't show warnings if any validation block call isn't ended with parentheses
    // Catch an exception and inform user about possible reason
    @try {
        (void)validator.propertyName;
    }
    @catch (NSException *exception) {
        NSAssert(NO, @"An exception appear during parameter from %@ model validation. Did you remember to use parentheses in block call?", [model class]);
    }
}

+ (NSArray *)propertiesOfClass:(Class)aClass {
    
    uint count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (uint i = 0; i < count ; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return propertyArray;
}

+ (NSArray *)propertiesOfModel:(NSObject *)model {
    
    NSMutableArray *array = [[self propertiesOfClass:[model class]] mutableCopy];
    
    if (![model.superclass isMemberOfClass:[NSObject class]]) {
        [array addObjectsFromArray:[self propertiesOfClass:model.superclass]];
    }
    return [array copy];
}

@end
