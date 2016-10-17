//
//  VXPaymentManager.h
//  VetX
//
//  Created by YulianMobile on 2/19/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PaymentManagerCompleteBlock)(BOOL success, NSDictionary *result);

@interface VXPaymentManager : NSObject

@property (nonatomic, strong) NSString *currentCustomerID;

+ (VXPaymentManager *)defaultManager;

// Braintree payment related functions
- (void)createCustomerWithCompletion:(PaymentManagerCompleteBlock)complete;

- (void)getBraintreeTokenWithCompletion:(PaymentManagerCompleteBlock)complete;

//- (void)postNonceToServer:(NSString *)paymentNonce type:(NSString *)type completion:(PaymentManagerCompleteBlock)complete;
- (void)postNonceToServer:(NSString *)paymentNonce promocode:(NSString *)promocode type:(NSString *)type completion:(PaymentManagerCompleteBlock)complete;

- (void)postPromoCode:(NSString *)promocode WithCompletion:(PaymentManagerCompleteBlock)complete;

@end
