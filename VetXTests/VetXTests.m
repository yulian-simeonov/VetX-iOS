//
//  VetXTests.m
//  VetXTests
//
//  Created by YulianMobile on 2/10/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserRequestModel.h"
#import "NSDictionary+WithoutNilValue.h"

@interface VetXTests : XCTestCase

@end

@implementation VetXTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // Given
    UserRequestModel *model = [UserRequestModel new];
    model.firstName         = @"ZK";
    model.lastName          = @"Dou";
    model.email             = @"ZK@DOU.COM";
    model.password          = @"123456";
    model.confirmPassword   = @"123456";
    
    // When
    NSDictionary *user = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    NSDictionary *expect = @{@"email":@"ZK@DOU.COM",@"firstName":@"ZK", @"lastName":@"Dou", @"password":@"123456", @"repeatPassword":@"123456"};
    
    // Then
    XCTAssertEqualObjects([user withoutNilValue], expect, @"User Request Model - New User");
}

- (void)testUserIDParam {

    // Given a user id
    UserRequestModel *model = [UserRequestModel new];
    model.userID = @"asfd123";
    
    // When
    NSDictionary *user = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    NSDictionary *expect = @{@"userID":@"asfd123"};
    
    XCTAssertEqualObjects([user withoutNilValue], expect, @"User Request Model - User ID");
}

- (void)testRealmStoreQuestion {
    // Dummy data for question objects
    NSDictionary *fakeQuestions = @{@"questions": @[
                                            @{@"_id":@"123faefea",
                                              @"text":@"Why do cats purr?",
                                              @"details":@"My 2 years old cat keeps purring every day. Why do cats purr?",
                                              @"score":@1,
                                              @"user":@{@"id":@"safsfe",
                                                        @"firstName":@"Zongkun",
                                                        @"lastName":@"Dou",
                                                        @"email":@"zkdou@gmail.com"}},
                                            @{@"_id":@"afealfjs",
                                              @"text":@"How long do cats live?",
                                              @"details":@"My cat is already 10 years old, how long can he still live?",
                                              @"score":@3,
                                              @"user":@{@"id":@"safsfe1213",
                                                        @"firstName":@"Michael",
                                                        @"lastName":@"Trudell",
                                                        @"email":@"mtrudel@gmail.com"}},
                                            @{@"_id":@"123faef12321",
                                              @"text":@"Why do cats knead?",
                                              @"details":@"I always see cats knead, is it normal? And you do they knead?",
                                              @"score":@2.2,
                                              @"user":@{@"id":@"safsfe121332",
                                                        @"firstName":@"Tan",
                                                        @"lastName":@"Kabra",
                                                        @"email":@"tan@vetxapp.com"}},
                                            @{@"_id":@"124564fea",
                                              @"text":@"Why do dogs chase their tails?",
                                              @"details":@"Sometimes, my dog will suddenly start to chase its tail. And I also saw other dogs chase their tails, why they do this?",
                                              @"score":@5,
                                              @"user":@{@"id":@"safsfe",
                                                        @"firstName":@"Zongkun",
                                                        @"lastName":@"Dou",
                                                        @"email":@"zkdou@gmail.com"}},
                                            @{@"_id":@"123f32424aefea",
                                              @"text":@"How do you clean dogs' ears?",
                                              @"details":@"I want to help me doy cealn his ears, how can I do this?",
                                              @"score":@4,
                                              @"user":@{@"id":@"safsfe214",
                                                        @"firstName":@"John",
                                                        @"lastName":@"D.",
                                                        @"email":@"john.d@gmail.com"}},
                                            @{@"_id":@"123ffe23efea",
                                              @"text":@"Why are dogs' noses wet?",
                                              @"details":@"I touched my dog's nose today and it is wet, does he get sick?",
                                              @"score":@4.2,
                                              @"user":@{@"id":@"safs1231fe",
                                                        @"firstName":@"Liam",
                                                        @"lastName":@"Will",
                                                        @"email":@"liam.w@gmail.com"}},
                                            @{@"_id":@"123f123754aefea",
                                              @"text":@"Why do dogs bury bones?",
                                              @"details":@"Sometimes, my dog will try to bury his bones, why he like to do this? Is he hungry?",
                                              @"score":@1.9,
                                              @"user":@{@"id":@"safsfe65631fss",
                                                        @"firstName":@"Yunxin",
                                                        @"lastName":@"Li",
                                                        @"email":@"yunxin@gmail.com"}},
                                            @{@"_id":@"123fa213jfdaefea",
                                              @"text":@"Why do cats hate water?",
                                              @"details":@"I try to give my cat a bath, but it seems he hates water and is terrified. Why all the cats hate water?",
                                              @"score":@3.3,
                                              @"user":@{@"id":@"safsfe",
                                                        @"firstName":@"Zongkun",
                                                        @"lastName":@"Dou",
                                                        @"email":@"zkdou@gmail.com"}},
                                            @{@"_id":@"123ajflkdafaefea",
                                              @"text":@"Should I Brush My Pet's Teeth?",
                                              @"details":@"Should I brush my pet's teeth every day like human?",
                                              @"score":@0.4,
                                              @"user":@{@"id":@"safsfas46546fe",
                                                        @"firstName":@"Antony",
                                                        @"lastName":@"Davis",
                                                        @"email":@"antony.da@gmail.com"}}
                                            ]};
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
