//
//  DVSValidator.h
//  Devise
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSPropertyValidator.h"

typedef NSError * (^DVSValidationBlock)(NSString *);

#define validate(property) ({[DVSPropertyValidator validatorForPropertyName:@#property];})

@interface DVSValidator : NSObject
/**
 *  Validates given model with selected rules. Returns YES when validation succeeded, NO otherwise.
 *
 *  @param model Model within properties are validated
 *  @param error Validation error with decription, nil when validation will pass
 *  @param rules An array of validation rules. Every property within a model is validated separately
 *
 *  @return result of validation. YES if validation will pass, NO otherwise.
 */
+ (BOOL)validateModel:(NSObject *)model error:(NSError **)error usingRules:(NSArray *(^)())rules;

/**
 *  Validates given model with selected rules. Returns empty array when validation succeeded. If not, array will contains errors.
 *
 *  @param model Model within properties are validated
 *  @param rules An array of validation rules. Every property within a model is validated separately
 *
 *  @return an array of errors. If validation will pass then array is empty.
 */
+ (NSArray *)validateModel:(NSObject *)model usingRules:(NSArray *(^)())rules;

@end
