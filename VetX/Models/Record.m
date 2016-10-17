//
//  Record.m
//  VetX
//
//  Created by YulianMobile on 5/7/16.
//  Copyright © 2016 YulianMobile. All rights reserved.
//

#import "Record.h"

@implementation Record

+ (NSString *)primaryKey {
    return @"record";
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[@"record"];
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"record": @""};
}

- (id)initWithMantleRecordURL:(NSString *)recordURL {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.record = recordURL;
    
    return self;
}


@end
