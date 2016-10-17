//
//  VTXChatManager.m
//  VetX
//
//  Created by YulianMobile on 2/26/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "VTXChatManager.h"
#import "Keys.h"
#import "APIs.h"
#import "NetworkManager.h"
#import "UserManager.h"
#import "Consultation.h"
@import Firebase;
@import FirebaseAuth;

@interface VTXChatManager ()

@property (nonatomic, strong) FIRDatabaseReference *rootRef;
@property (nonatomic, strong) FIRStorageReference *storageRef;
@property (nonatomic, strong) NSString *firebaseToken;

@end

@implementation VTXChatManager

+ (VTXChatManager *)defaultManager {
    static VTXChatManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[VTXChatManager alloc] init];
        s_manager.rootRef = [[FIRDatabase database] reference];
        s_manager.storageRef = [[FIRStorage storage] referenceForURL:@"gs://vetx-1187.appspot.com"];
    });
    return s_manager;
}

- (void)getFirebaseTokenWithQuestion:(NSString *)question transaction:(NSString *)transactionID completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock {
    NSDictionary *params = @{@"userID": [[UserManager defaultManager] currentUserID], @"transactionID": transactionID, @"question":question};
    [[NetworkManager defaultManager] getRequestFromURL:GET_FIREBASE_TOKEN andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSLog(@"Firebase token: %@", responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(YES, result);
    } andError:^(NSError *error) {
        NSLog(@"Error to get the firebase token: %@", error);
        errorBlock(error);
    }];
}

- (void)getOneOnOneTokenWithGroup:(NSString *)groupID transaction:(NSString *)transactionID type:(NSString *)type completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock {
    NSDictionary *params;
    if ([[[UserManager defaultManager] currentUser] licenseID]) {
        params = @{@"vetID": [[UserManager defaultManager] currentUserID], @"groupID":groupID, @"transactionID":transactionID};
    } else {
        params = @{@"userID": [[UserManager defaultManager] currentUserID], @"groupID":groupID, @"transactionID":transactionID};
    }
    NSString *url;
    if ([type isEqualToString:@"text"]) {
        url = GET_FIREBASE_TOKEN;
    } else {
        url = GET_TWILIO_TOKEN;
    }
    [[NetworkManager defaultManager] getRequestFromURL:url andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(YES, result);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)getTwilioTokenWithQuestion:(NSString *)question transaction:(NSString *)transactionID completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock {
    NSDictionary *params = @{@"userID": [[UserManager defaultManager] currentUserID], @"transactionID": transactionID, @"question":question};
    [[NetworkManager defaultManager] getRequestFromURL:GET_TWILIO_TOKEN andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSLog(@"Twilio token: %@", responseObject);
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(YES, result);
    } andError:^(NSError *error) {
        NSLog(@"Error to get the firebase token: %@", error);
        errorBlock(error);
    }];
}

- (void)joinGroup:(NSString *)groupID
       completion:(ChatManagerSuccessBlock)successBlock
            error:(ChatManagerErrorBlock)errorBlock {
    NSDictionary *params = @{@"userID": [[UserManager defaultManager] currentUserID], @"groupID":groupID};
    [[NetworkManager defaultManager] postRequestToURL:JOIN_IN_CHAT andParameter:params withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        successBlock(YES, result);
    } andError:^(NSError *error) {
        NSLog(@"JOIN IN GROUP RESULT: %@", [error localizedDescription]);

        errorBlock(error);
    }];
}

- (void)authorizeUserWithFirebaseToken:(NSString *)token completion:(ChatManagerSuccessBlock)successBlock error:(ChatManagerErrorBlock)errorBlock {
    [[FIRAuth auth] signInWithCustomToken:token completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
        if (error) {
            errorBlock(error);
        } else {
            NSLog(@"Login succeeded! %@", user.uid);
            successBlock(YES, @{@"uid":user.uid});
        }
    }];
}

- (void)queryMessageHistory:(NSString *)groupID completion:(ChatManagerBlock)complete {
    [[[self.rootRef child:@"Message"] child:groupID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ( [snapshot value] == [NSNull null]) {
            complete(NO, nil, nil);
        } else {
            complete(YES, snapshot.value, nil);
        }
    }];
}

- (void)observeNewMessage:(NSString *)groupID completion:(ChatManagerBlock)complete {
    [[[self.rootRef child:@"Message"] child:groupID] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSLog(@"Message history: %@", snapshot.value);
        if ( [snapshot value] == [NSNull null]) {
            complete(NO, nil, nil);
        } else {
            complete(YES, snapshot.value, nil);
        }
    }];
}

- (void)sendImageMessage:(NSData *)imageData sender:(NSString *)senderID name:(NSString *)name group:(NSString *)groupId completion:(ChatManagerBlock)complete {
    NSString *filePath = [NSString stringWithFormat:@"%@.jpeg", [[NSUUID UUID] UUIDString]];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    [[self.storageRef child:filePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            complete(NO, nil, error);
        } else {
            // Google Storage URL
//            NSString *url = [NSString stringWithFormat:@"gs://vetx-1187.appspot.com/%@", metadata.path];
            // Normal HTTP URL
            NSString *url = [metadata.downloadURL absoluteString];
            [self sendMessage:@"" imageURL:url sender:senderID name:name group:groupId completion:^(BOOL success, NSDictionary *result, NSError *error) {
                if (error != nil) {
                    complete(NO, nil, error);
                } else {
                    complete(YES, result, nil);
                }
            }];
        }
    }];
}

- (void)sendMessage:(NSString *)message imageURL:(NSString *)imageURL sender:(NSString *)senderID name:(NSString *)name group:(NSString *)groupID completion:(ChatManagerBlock)complete {
    NSDictionary *value = @{@"message":message, @"senderID":senderID, @"displayName": name, @"created": [FIRServerValue timestamp], @"imageURL":imageURL};
    
    [[[[self.rootRef child:@"Message"] child:groupID] childByAutoId] setValue:value withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (!error) {
            complete(YES, value, nil);
        } else {
            complete(NO, nil, error);
        }
    }];
}

- (void)cleanConsutlationCache {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects:[Consultation allObjects]];
        [realm commitWriteTransaction];
    }
}

@end
