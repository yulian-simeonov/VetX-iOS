//
//  VTXChatManager.h
//  VetX
//
//  Created by YulianMobile on 2/26/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChatManagerSuccessBlock)(BOOL success, NSDictionary *result);
typedef void (^ChatManagerErrorBlock)(NSError *error);
typedef void (^ChatManagerBlock)(BOOL success, NSDictionary *result, NSError *error);

@interface VTXChatManager : NSObject

+ (VTXChatManager *)defaultManager;

// Get Firebase authenticate token
- (void)getFirebaseTokenWithQuestion:(NSString *)question
                         transaction:(NSString *)transactionID
                          completion:(ChatManagerSuccessBlock)successBlock
                               error:(ChatManagerErrorBlock)errorBlock;
- (void)getOneOnOneTokenWithGroup:(NSString *)groupID
                      transaction:(NSString *)transactionID
                             type:(NSString *)type
                       completion:(ChatManagerSuccessBlock)successBlock
                            error:(ChatManagerErrorBlock)errorBlock;
- (void)joinGroup:(NSString *)groupID
       completion:(ChatManagerSuccessBlock)successBlock
            error:(ChatManagerErrorBlock)errorBlock;
- (void)getTwilioTokenWithQuestion:(NSString *)question transaction:(NSString *)transactionID completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock;
- (void)authorizeUserWithFirebaseToken:(NSString *)token completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock;
- (void)queryMessageHistory:(NSString *)groupID completion:(ChatManagerBlock)complete;
- (void)sendImageMessage:(NSData *)imageData sender:(NSString *)senderID name:(NSString *)name group:(NSString *)groupId completion:(ChatManagerBlock)complete;
- (void)sendMessage:(NSString *)message imageURL:(NSString *)imageURL sender:(NSString *)senderID name:(NSString *)name group:(NSString *)groupID completion:(ChatManagerBlock)complete;
- (void)observeNewMessage:(NSString *)groupID completion:(ChatManagerBlock)complete;

- (void)cleanConsutlationCache;

@end
