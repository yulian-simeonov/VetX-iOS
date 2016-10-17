//
//  APIs.m
//  VetX
//
//  Created by YulianMobile on 2/11/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "APIs.h"

NSString * const TOKEN = @"token";
NSString * const CURRENT_USER_ID = @"currentUser";
NSString * const CURRENT_USER_CUSTOMER_ID = @"currentCustomer";

NSString * const FEED = @"/feed";
NSString * const SUGGEST = @"/suggest";
NSString * const BREEDS = @"/breeds";

NSString * const REGISTER_USER = @"/user";
NSString * const LOGIN_USER = @"/user/auth";
NSString * const FB_AUTH_USER = @"/user/facebookauth";
NSString * const USER_ADD_PET = @"/user/pet";
NSString * const USER_INFO = @"/user/%@";
NSString * const UPDATE_USER_PROFILE = @"/user/update";
NSString * const USER_DEVICE_TOKEN = @"/user/device";
NSString * const UPDATE_PASSWORD = @"/user/changePassword";
NSString * const FORGOT_PASSWORD = @"/forgotpassword";
NSString * const LOGOUT_USER = @"/user/logout";
NSString * const USER_NOTIFY = @"/user/notify";

NSString * const PET_MEDICAL_RECORD = @"/user/pet/%@/records";
NSString * const UPDATE_PET_PROFILE = @"/user/pet/%@/update";
NSString * const GET_MEDICAL_RECORDS = @"/user/%@/records";
NSString * const DELETE_MEDICAL_RECORDS = @"/user/pet/%@/deleterecords";

NSString * const QUESTION = @"/question";
NSString * const QUESTIONS_HISTORY = @"/question/%@";
NSString * const ANSWER_QUESTION = @"/question/%@/answer";
NSString * const VET_ANSWERS = @"/answersforvet";

NSString * const GET_FIREBASE_TOKEN = @"/chat_client_token";
NSString * const GET_TWILIO_TOKEN = @"/video_client_token";
NSString * const JOIN_IN_CHAT = @"/join_chat";
NSString * const UNANSWERED_CHAT_GROUP = @"/unanswered_chat";
NSString * const CHAT_HISTORY = @"/chat_group_history";
NSString * const END_CONSULTATION = @"/end_consultation";

NSString * const GET_BRAINTREE_TOKEN = @"/payment_client_token";
NSString * const CREATE_BRAINTREE_CUSTOMER = @"/create_customer";
NSString * const CHECKOUT = @"/checkout";
NSString * const PROMO_CODE = @"/promocode/%@";