//
//  UserManager.m
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"
#import "UserResponseModel.h"
#import "APIs.h"
#import "NSDictionary+WithoutNilValue.h"
#import "NetworkManager.h"
#import <Realm/Realm.h>
#import <RBQFetchedResultsController/RBQFRC.h>
#import "TypeBreedResponseModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserManager ()

@property (nonatomic) dispatch_queue_t realmQueue;

@end

@implementation UserManager

+ (UserManager *)defaultManager {
    static UserManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[UserManager alloc] init];
        s_manager.realmQueue = dispatch_queue_create("com.vetx.realm.user", DISPATCH_QUEUE_SERIAL);
    });
    return s_manager;
}

- (NSString*)currentUserID
{
    if (nil == _currentUserID)
    {
        _currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_USER_ID];
    }
    
    return _currentUserID;
}

- (void)setCurrentUser:(NSString *)userID accessToken:(NSString *)token {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!userID || !token) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_ID];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:userID forKey:CURRENT_USER_ID];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (void)registerUser:(UserRequestModel *)requestModel photo:(NSData *)imageData andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock{
    
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] postRequestToURL:REGISTER_USER andParameter:parameters attachedData:imageData withAuth:NO andSuccess:^(id responseObject) {
        // Store user object and token
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        UserResponseModel *user = [MTLJSONAdapter modelOfClass:UserResponseModel.class
                                                   fromJSONDictionary:responseDictionary error:&error];
        UserModel *currentUser = user.user;
        [self setCurrentUser:currentUser.userID accessToken:currentUser.token];
        [self storeUserRespModelToRealm:user];
        successBlock(YES);
    } andError:^(NSError *error) {
        // Handle Register Error
        errorBlock(error);
    }];
}

- (void)signupWithFB:(NSString *)fbToken andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSDictionary *params = @{@"access_token": fbToken};
    [[NetworkManager defaultManager] getRequestFromURL:FB_AUTH_USER andParameters:params withAuth:NO andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        UserResponseModel *user = [MTLJSONAdapter modelOfClass:UserResponseModel.class
                                            fromJSONDictionary:responseDictionary error:&error];
        UserModel *currentUser = user.user;
        [self setCurrentUser:currentUser.userID accessToken:currentUser.token];
        [self storeUserRespModelToRealm:user];
        successBlock(YES);
    } andError:^(NSError *error) {
        NSLog(@"FB AUTH ERROR: %@", error);
    }];
}

- (void)loginUser:(UserRequestModel *)requestModel andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] postRequestToURL:LOGIN_USER andParameter:parameters withAuth:NO andSuccess:^(id responseObject) {
        // Store response
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSString *token = [responseObject objectForKey:@"token"];
        NSError *error;
        UserResponseModel *user = [MTLJSONAdapter modelOfClass:UserResponseModel.class
                                            fromJSONDictionary:responseDictionary error:&error];
        UserModel *currentUser = user.user;
        [self setCurrentUser:currentUser.userID accessToken:token];
        [self storeUserRespModelToRealm:user];
        successBlock(YES);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)updateUserProfile:(UserRequestModel *)requestModel andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] postRequestToURL:UPDATE_USER_PROFILE andParameter:parameters withAuth:YES andSuccess:^(id responseObject) {
        // Store user object and token
        [self storeUserData:responseObject];
        successBlock(YES);
    } andError:^(NSError *error) {
        // Handle Register Error
        errorBlock(error);
    }];
}

- (void)updateUserProfile:(UserRequestModel *)requestModel image:(NSData *)profileImage andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil] withoutNilValue];
    [[NetworkManager defaultManager] postRequestToURL:UPDATE_USER_PROFILE andParameter:parameters attachedData:profileImage withAuth:YES andSuccess:^(id responseObject) {
        successBlock(YES);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)updateOldPassword:(NSString *)oldPassword
             withPassword:(NSString *)password
                  confirm:(NSString *)confirmPassword
               andSuccess:(void (^)(BOOL))successBlock
                 andError:(void (^)(NSError *))errorBlock {
    NSDictionary *param = @{@"oldPassword": oldPassword, @"newPassword": password, @"newPasswordAgain": confirmPassword};
    [[NetworkManager defaultManager] postRequestToURL:UPDATE_PASSWORD andParameter:param withAuth:YES andSuccess:^(id responseObject) {
        [self storeUserData:responseObject];
        successBlock(YES);
    } andError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)sendNotificationFrom:(NSString *)fromUser to:(NSString *)toUser completion:(void (^)(BOOL))complete {
    NSDictionary *params = @{@"from": fromUser, @"to": toUser};
    [[NetworkManager defaultManager] postRequestToURL:USER_NOTIFY andParameter:params withAuth:YES andSuccess:^(id responseObject) {
        complete(YES);
    } andError:^(NSError *error) {
        complete(NO);
    }];
}

- (BOOL)logoutCurrentUser {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    _currentUserID = nil;
    [[NetworkManager defaultManager] logoutUser];
    [RBQFetchedResultsController deleteCacheWithName:nil];
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
    }
    return YES;
}


- (void)getTwilioToken {
    NSDictionary *params = @{@"_id": self.currentUserID};
    [[NetworkManager defaultManager] getRequestFromURL:GET_TWILIO_TOKEN andParameters:params withAuth:YES andSuccess:^(id responseObject) {
        NSLog(@"Twilio token: %@", responseObject);
    } andError:^(NSError *error) {
        NSLog(@"Error to get the firebase token: %@", error);
    }];
}

- (User *)currentUser {
    if (!self.currentUserID) {
        return nil;
    }
    return [User objectForPrimaryKey:self.currentUserID];
}

- (User *)updateCurrentUser:(NSDictionary *)responseDict {
    UserModel *userModel = [[UserModel alloc] initWithResponseObject:responseDict[@"object"]];
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        User *user = [[User alloc] initWithMantleUserModel:userModel];
        [realm addOrUpdateObject:user];
        [realm commitWriteTransaction];
    }
    return [User objectForPrimaryKey:self.currentUserID];
}

- (void)forgotPassword:(NSString *)email {
    NSDictionary *params = @{@"email": email};
    [[NetworkManager defaultManager] getRequestFromURL:FORGOT_PASSWORD andParameters:params withAuth:NO andSuccess:^(id responseObject) {
        // Store response
        NSLog(@"Porgot password %@", responseObject);
    } andError:^(NSError *error) {
    }];
}

- (void)getLatestCurrentUserInfo {
    if (self.currentUserID == nil) {
        return;
    }
    [[NetworkManager defaultManager] getRequestFromURL:[NSString stringWithFormat:USER_INFO, self.currentUserID] andParameters:nil withAuth:YES andSuccess:^(id responseObject) {
        // Store response
        NSLog(@"Current user info %@", responseObject);
        [self storeUserData:responseObject];
    } andError:^(NSError *error) {
    }];
}


- (void)storeUserRespModelToRealm:(UserResponseModel *)responseModel {
    dispatch_async(self.realmQueue, ^{
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            User *user = [[User alloc] initWithMantleUserModel:responseModel.user];
            [realm addOrUpdateObject:user];
            [realm commitWriteTransaction];
        }
    });
}

/**
 *  Manage User's Pets Information
 */
#pragma mark - Manage Pet Info

- (void)addPet:(AddPetRequestModel *)requestModel andProfile:(NSData *)image andSuccess:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSError *error;
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:&error] withoutNilValue];
    if (error) {
        NSLog(@"Add pet error: %@", [error localizedDescription]);
        return;
    }
    [[NetworkManager defaultManager] postRequestToURL:USER_ADD_PET andParameter:parameters attachedData:image withAuth:YES andSuccess:^(id responseObject) {
        NSLog(@"Add pet successfully: %@", responseObject);
        [self storeUserData:responseObject];
        successBlock(YES);
    } andError:^(NSError *error) {
        NSLog(@"Fail to add pet: %@", [error  localizedDescription]);
        errorBlock(error);
    }];
}

- (void)updatePet:(NSString *)petID
             info:(AddPetRequestModel *)requestModel
       andProfile:(NSData *)image
       andSuccess:(void (^)(BOOL finished))successBlock
         andError:(void (^)(NSError *error))errorBlock {
    NSError *error;
    NSDictionary *parameters = [[MTLJSONAdapter JSONDictionaryFromModel:requestModel error:&error] withoutNilValue];
    if (error) {
        NSLog(@"Add pet error: %@", [error localizedDescription]);
        errorBlock(error);
        return;
    }
    [[NetworkManager defaultManager] postRequestToURL:[NSString stringWithFormat:UPDATE_PET_PROFILE, petID] andParameter:parameters attachedData:image withAuth:YES andSuccess:^(id responseObject) {
        [self storeUserData:responseObject];
        successBlock(YES);
        
    } andError:^(NSError *error) {
        NSLog(@"Fail to update pet: %@", [error  localizedDescription]);
        errorBlock(error);
    }];
}

- (void)getPetTypeBreedComplete:(void (^)(BOOL finished, NSDictionary *data))complete {
    [[NetworkManager defaultManager] getRequestFromURL:BREEDS andParameters:nil withAuth:YES andSuccess:^(id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        TypeBreedResponseModel *typeBreed = [MTLJSONAdapter modelOfClass:TypeBreedResponseModel.class
                                                      fromJSONDictionary:responseDictionary error:&error];
        complete(YES, typeBreed.typeBreed);
    } andError:^(NSError *error) {
        NSLog(@"Fail to get type and breed: %@", [error localizedDescription]);
    }];
}

- (void)addMedicalRecord:(NSString *)petID
                   image:(NSData *)imageData
                    type:(NSString *)type
                 success:(void (^)(BOOL finished))successBlock
                andError:(void (^)(NSError *error))errorBlock {
    NSString *url = [NSString stringWithFormat:PET_MEDICAL_RECORD, petID];
    
    [[NetworkManager defaultManager] postRequestToURL:url andParameter:nil attachedData:imageData fileName:type withAuth:YES andSuccess:^(id data) {
        NSLog(@"add record response data: %@", data);
        [self storeUserData:data];
        successBlock(YES);
    } andError:^(NSError *err) {
        NSLog(@"add record error : %@", [err localizedDescription]);
        errorBlock(err);
    }];
}

- (void)deleteMedicalRecord:(NSString *)petID type:(NSString *)type success:(void (^)(BOOL))successBlock andError:(void (^)(NSError *))errorBlock {
    NSString *url = [NSString stringWithFormat:DELETE_MEDICAL_RECORDS, petID];
    NSDictionary *param = @{@"delete": @[type], @"petid": petID};
    [[NetworkManager defaultManager] postRequestToURL:url andParameter:param  withAuth:YES andSuccess:^(id data){
        NSLog(@"delete record response data: %@", data);
        [self storeUserData:data];
        successBlock(YES);
    } andError:^(NSError *err) {
        NSLog(@"add record error : %@", [err localizedDescription]);
        errorBlock(err);
    }];
}

- (void)storeUserData:(id)responseObject {
    @try {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        NSError *error;
        UserResponseModel *user = [MTLJSONAdapter modelOfClass:UserResponseModel.class
                                            fromJSONDictionary:responseDictionary error:&error];
        [self storeUserRespModelToRealm:user];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

- (void)addDeviceToken:(NSString *)token {
    NSDictionary *param = @{@"deviceToken":token,
                            @"userID":self.currentUserID,
                            @"deviceType": @"iOS"};
    [[NetworkManager defaultManager] postRequestToURL:USER_DEVICE_TOKEN andParameter:param withAuth:YES andSuccess:^(id data) {
        NSLog(@"add device token successfully: %@", data);
    } andError:^(NSError *err) {
        NSLog(@"add device token error : %@", [err localizedDescription]);
    }];
}

@end
