//
//  VXPaymentManager.m
//  VetX
//
//  Created by YulianMobile on 2/19/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VXPaymentManager.h"
#import "NetworkManager.h"
#import "UserManager.h"
#import "APIs.h"

@implementation VXPaymentManager

+ (VXPaymentManager *)defaultManager {
    static VXPaymentManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[VXPaymentManager alloc] init];
    });
    return s_manager;
}

- (NSString*)currentCustomerID
{
    if (nil == _currentCustomerID)
    {
        _currentCustomerID = [[UserManager defaultManager] currentUser].customerID;
    }
    
    return _currentCustomerID;
}

- (void)createCustomerWithCompletion:(PaymentManagerCompleteBlock)complete {
    NSDictionary *params = @{@"userID": [[UserManager defaultManager] currentUserID]};
    [[NetworkManager defaultManager] postRequestToURL:CREATE_BRAINTREE_CUSTOMER andParameter:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"status"] isEqualToString:@"Success"]) {
            complete(YES, result);
        }
    } andError:^(NSError *error) {
        if (error) {
            complete(NO, @{@"error": [error localizedDescription]});
        }
    }];
}

- (void)getBraintreeTokenWithCompletion:(PaymentManagerCompleteBlock)complete {
    if (!self.currentCustomerID || [self.currentCustomerID isEqualToString:@""]) {
        [self createCustomerWithCompletion:^(BOOL success, NSDictionary *result) {
            if (success) {
                // Continue to get token.
                User *updatedUser = [[UserManager defaultManager] updateCurrentUser:result];
                NSString *customerID = updatedUser.customerID;
                if (customerID) {
                    NSDictionary *params = @{@"userCustomerID":customerID};
                    [self getTokenWithParam:params completion:^(BOOL success, NSDictionary *result) {
                        if (complete) {
                            complete(success, result);
                        }
                    }];
                }
            }
        }];
    } else {
        NSDictionary *params = @{@"userCustomerID": self.currentCustomerID};
        [self getTokenWithParam:params completion:^(BOOL success, NSDictionary *result) {
            if (complete) {
                complete(success, result);
            }
        }];
    }
}

- (void)getTokenWithParam:(NSDictionary *)parameters completion:(PaymentManagerCompleteBlock)complete {
    [[NetworkManager defaultManager] getRequestFromURL:GET_BRAINTREE_TOKEN andParameters:parameters withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *results = (NSDictionary *)responseObject;
        if ([results[@"status"] isEqualToString:@"Success"]) {
            complete(YES, @{@"token":results[@"token"]});
        } else {
            complete(NO, @{@"error":results[@"error"]});
        }
    } andError:^(NSError *error) {
        complete(NO, @{@"error":[error localizedDescription]});
    }];
}

- (void)postNonceToServer:(NSString *)paymentNonce promocode:(NSString *)promocode type:(NSString *)type completion:(PaymentManagerCompleteBlock)complete {
    NSDictionary *params;
    NSAssert(self.currentCustomerID, @"Current Customer ID is nil");
    @try {
        params = @{@"type":type, @"userCustomerID":self.currentCustomerID, @"payment_method_nonce":paymentNonce, @"promocode": promocode};
    } @catch (NSException *exception) {
        NSLog(@"Some wrong happens to generate params");
    }
    
    [[NetworkManager defaultManager] postRequestToURL:CHECKOUT andParameter:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        BOOL success = [[[response objectForKey:@"data"] objectForKey:@"success"] integerValue] == 1 ? YES : NO;
        if (success) {
            complete(YES, [[response objectForKey:@"data"] objectForKey:@"transaction"]);
        } else {
            complete(NO, @{@"error": @"Fail to finish the transaction"});
        }
    } andError:^(NSError *error) {
        complete(NO, @{@"error":[error localizedDescription]});
    }];
    
}

- (void)postPromoCode:(NSString *)promocode WithCompletion:(PaymentManagerCompleteBlock)complete {
    NSString *url = [NSString stringWithFormat:PROMO_CODE, promocode];
    [[NetworkManager defaultManager] getRequestFromURL:url andParameters:nil withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *results = (NSDictionary *)responseObject;
        complete(YES, @{@"items":results});
    } andError:^(NSError *error) {
        complete(NO, @{@"error":[error localizedDescription]});
    }];
}

@end
