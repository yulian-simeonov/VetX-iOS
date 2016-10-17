//
//  NetworkManager.h
//  VetX
//
//  Created by YulianMobile on 2/3/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@protocol NetworkManagerDelegate <NSObject>

- (void)didReceivedSuccessData:(id)response;
- (void)didReceivedError:(NSError *)error;

@end

@interface NetworkManager : AFHTTPSessionManager

@property (nonatomic, assign) id<NetworkManagerDelegate> delegate;

@property (nonatomic, strong) NSString *accessToken;

+ (instancetype)defaultManager;

- (void)getRequestFromURL:(NSString *)url
            andParameters:(NSDictionary *)parameters
                 withAuth:(BOOL)authenticate
               andSuccess:(void (^)(id responseObject))successBlock
                 andError:(void (^)(NSError *error))errorBlock;

- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id responseObject))successBlock
                andError:(void (^)(NSError *error))errorBlock;

- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
            attachedData:(NSData *)attachment
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id responseObject))successBlock
                andError:(void (^)(NSError *error))errorBlock;

- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
                bodyData:(NSData *)bodyData
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id responseObject))successBlock
                andError:(void (^)(NSError *error))errorBlock;

- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
            attachedData:(NSData *)attachment
                fileName:(NSString *)name
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id))successBlock
                andError:(void (^)(NSError *))errorBlock;

- (void)logoutUser;
@end
