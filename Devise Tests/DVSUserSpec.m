//
//  DVSUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSAPIManager.h"

SPEC_BEGIN(DVSUserSpec)

describe(@"DVSUser", ^{

    __block DVSConfiguration *configuration = nil;

    NSString *validEmail = @"john.appleseed@apple.com";
    NSString *validPassword = @"$ecr3t";

    beforeEach(^{
        configuration = [[DVSConfiguration alloc] initWithServerURL:[OHHTTPStubs dvs_stubURL]];
        [DVSConfiguration stub:@selector(sharedConfiguration) andReturn:configuration];
    });

    describe(@"logging in", ^{

        __block DVSUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performLogin)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user loginWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertLoginShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performLogin(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertLoginShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performLogin(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs dvs_stubLoginRouteWithOptions:@{
                @"allowedEmail": validEmail,
                @"allowedPassword": validPassword,
            }];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });

        beforeEach(^{
            user = [DVSUser user];
        });

        context(@"using email with incorrect syntax", ^{

            beforeEach(^{
                user.email = @"qux";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using no email", ^{

            beforeEach(^{
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using no password", ^{

            beforeEach(^{
                user.email = validEmail;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });

        });

        context(@"using incorrect email", ^{

            beforeEach(^{
                user.email = @"john.smith@apple.com";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });
            
        });

        context(@"using incorrect password", ^{

            beforeEach(^{
                user.email = validEmail;
                user.password = @"baz";
            });

            it(@"should fail", ^{
                assertLoginShouldFail();
            });
            
        });

        context(@"using correct email and password", ^{

            beforeEach(^{
                user.email = validEmail;
                user.password = validPassword;
            });

            it(@"should succeed", ^{
                assertLoginShouldSucceed();
            });
            
        });

    });

    describe(@"reminding password", ^{

        __block DVSUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performForgotPassword)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user remindPasswordWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertRemindPasswordShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performForgotPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertRemindPasswordShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performForgotPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs dvs_stubForgotPasswordRouteWithOptions:@{
                @"allowedEmail": validEmail,
            }];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });
        
        beforeEach(^{
            user = [DVSUser user];
        });

        context(@"using no email", ^{

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });

        });

        context(@"using email with invalid syntax", ^{

            beforeEach(^{
                user.email = @"fox";
            });

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });
            
        });

        context(@"using incorrect email", ^{

            beforeEach(^{
                user.email = @"john.smith@apple.com";
            });

            it(@"should fail", ^{
                assertRemindPasswordShouldFail();
            });
            
        });

        context(@"using valid email", ^{

            beforeEach(^{
                user.email = validEmail;
            });

            it(@"should succeed", ^{
                assertRemindPasswordShouldSucceed();
            });
            
        });

    });

    describe(@"registration", ^{

        __block DVSUser *user = nil;
        __block id<OHHTTPStubsDescriptor> routeStub = nil;

        void (^performRegisterPassword)(void(^)(BOOL, NSError *)) = ^(void(^completion)(BOOL, NSError *)) {
            [user registerWithSuccess:^{
                if (completion != nil) completion(YES, nil);
            } failure:^(NSError *error) {
                if (completion != nil) completion(NO, error);
            }];
        };

        void (^assertRegisterShouldSucceed)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performRegisterPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beYes];
            [[expectFutureValue(error) shouldEventually] beNil];
        };

        void (^assertRegisterShouldFail)() = ^{
            __block BOOL success = NO; __block NSError *error = nil;
            performRegisterPassword(^(BOOL inputSuccess, NSError *inputError) {
                success = inputSuccess;
                error = inputError;
            });
            [[expectFutureValue(theValue(success)) shouldEventually] beNo];
            [[expectFutureValue(error) shouldEventually] beNonNil];
        };

        beforeAll(^{
            routeStub = [OHHTTPStubs dvs_stubRegisterRouteWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:routeStub];
        });

        beforeEach(^{
            user = [DVSUser user];
        });

        context(@"using no email", ^{

            beforeEach(^{
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using email with invalid syntax", ^{

            beforeEach(^{
                user.email = @"dog";
                user.password = validPassword;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using no password", ^{

            beforeEach(^{
                user.email = validEmail;
            });

            it(@"should fail", ^{
                assertRegisterShouldFail();
            });
            
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = validEmail;
                user.password = validPassword;
            });

            it(@"should succeed", ^{
                assertRegisterShouldSucceed();
            });
            
        });

    });

});

SPEC_END
