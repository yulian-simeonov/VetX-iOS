//
//  UserManager.h
//  VetX
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequestModel.h"
#import "AddPetRequestModel.h"
#import "User.h"

@interface UserManager : NSObject

@property (nonatomic, strong) NSString *currentUserID;

+ (UserManager *)defaultManager;

// User related functions
// Register new user
- (void)registerUser:(UserRequestModel *)requestModel
               photo:(NSData *)imageData
          andSuccess:(void (^)(BOOL finished))successBlock
            andError:(void (^)(NSError *error))errorBlock;
- (void)signupWithFB:(NSString *)fbToken
          andSuccess:(void (^)(BOOL))successBlock
            andError:(void (^)(NSError *))errorBlock;

- (void)loginUser:(UserRequestModel *)requestModel
       andSuccess:(void (^)(BOOL finished))successBlock
         andError:(void (^)(NSError *error))errorBlock;

- (void)updateUserProfile:(UserRequestModel *)requestModel
               andSuccess:(void (^)(BOOL finished))successBlock
                 andError:(void (^)(NSError *error))errorBlock;
- (void)updateUserProfile:(UserRequestModel *)requestModel
                    image:(NSData *)profileImage
               andSuccess:(void (^)(BOOL finished))successBlock
                 andError:(void (^)(NSError *error))errorBlock;
- (void)updateOldPassword:(NSString *)oldPassword
             withPassword:(NSString *)password
                  confirm:(NSString *)confirmPassword
               andSuccess:(void (^)(BOOL finished))successBlock
                 andError:(void (^)(NSError *error))errorBlock;
- (void)sendNotificationFrom:(NSString *)fromUser
                          to:(NSString *)toUser
                  completion:(void (^)(BOOL finished))complete;

- (void)addDeviceToken:(NSString *)token;
- (void)forgotPassword:(NSString *)email;
- (User *)currentUser;
- (BOOL)logoutCurrentUser;

- (User *)updateCurrentUser:(NSDictionary *)responseDict;
- (void)getLatestCurrentUserInfo;

- (void)addPet:(AddPetRequestModel *)requestModel
    andProfile:(NSData *)image
    andSuccess:(void (^)(BOOL finished))successBlock
      andError:(void (^)(NSError *error))errorBlock;
- (void)updatePet:(NSString *)petID
             info:(AddPetRequestModel *)requestModel
       andProfile:(NSData *)image
       andSuccess:(void (^)(BOOL finished))successBlock
         andError:(void (^)(NSError *error))errorBlock;
- (void)getPetTypeBreedComplete:(void (^)(BOOL finished, NSDictionary *data))complete;
- (void)addMedicalRecord:(NSString *)petID
                   image:(NSData *)imageData
                    type:(NSString *)type
                 success:(void (^)(BOOL finished))successBlock
                andError:(void (^)(NSError *error))errorBlock;
- (void)deleteMedicalRecord:(NSString *)petID
                       type:(NSString *)type
                    success:(void (^)(BOOL finished))successBlock
                   andError:(void (^)(NSError *error))errorBlock;

// Twilio video call token
- (void)getTwilioToken;

//- (void)getBreeds;


@end
