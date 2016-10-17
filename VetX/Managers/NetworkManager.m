//
//  NetworkManager.m
//  VetX
//
//  Created by YulianMobile on 2/3/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "NetworkManager.h"
#import "Keys.h"
#import "APIs.h"

@interface NetworkManager ()

@end


@implementation NetworkManager

+ (instancetype)defaultManager {
    static NetworkManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [[NSURL alloc] initWithString:DEV_SERVER_URL];
        s_manager = [[NetworkManager alloc] initWithBaseURL:baseURL];
    });
    return s_manager;
}

- (NSString*)accessToken
{
    if (nil == _accessToken)
    {
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN];
    }
    
    return _accessToken;
}


- (void)getRequestFromURL:(NSString *)url
            andParameters:(NSDictionary *)parameters
                 withAuth:(BOOL)authenticate
               andSuccess:(void (^)(id responseObject))successBlock
                 andError:(void (^)(NSError *error))errorBlock{
    
    if (authenticate) {
        [self authenticateRequestWithAccessToken:self.accessToken];
    }
    
    [self GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        errorBlock(error);
    }];
    
}


- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id responseObject))successBlock
                andError:(void (^)(NSError *error))errorBlock {
    
    if (authenticate) {
        [self authenticateRequestWithAccessToken: self.accessToken];
    }
    
    [self POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
            attachedData:(NSData *)attachment
                fileName:(NSString *)name
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id))successBlock
                andError:(void (^)(NSError *))errorBlock {
    if (authenticate) {
        [self authenticateRequestWithAccessToken:self.accessToken];
    }
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (attachment) {
            [formData appendPartWithFileData:attachment name:name fileName:@"photo.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}


- (void)postRequestToURL:(NSString *)url
            andParameter:(NSDictionary *)params
            attachedData:(NSData *)attachment
                withAuth:(BOOL)authenticate
              andSuccess:(void (^)(id))successBlock
                andError:(void (^)(NSError *))errorBlock {
    
    if (authenticate) {
        [self authenticateRequestWithAccessToken:self.accessToken];
    }
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (attachment) {
            [formData appendPartWithFileData:attachment name:@"image" fileName:@"photo.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

- (void)postRequestToURL:(NSString *)url andParameter:(NSDictionary *)params bodyData:(NSData *)bodyData withAuth:(BOOL)authenticate andSuccess:(void (^)(id))successBlock andError:(void (^)(NSError *))errorBlock {
    
    if (authenticate) {
        [self authenticateRequestWithAccessToken:self.accessToken];
    }
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:bodyData name:@"payment_method_nonce"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

- (void)authenticateRequestWithAccessToken:(NSString*)accessToken
{
    [self.requestSerializer setValue:[[NSString stringWithFormat:@"JWT %@", accessToken] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

- (void)logoutUser {
    [self postRequestToURL:LOGOUT_USER andParameter:@{} withAuth:YES andSuccess:^(id responseObject) {
        
    } andError:^(NSError *error) {
        
    }];
    _accessToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENT_USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
